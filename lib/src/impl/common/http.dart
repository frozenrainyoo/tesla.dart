library tesla.impl.common.http;

import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../../../tesla.dart';

abstract class TeslaHttpClient implements TeslaClient {
  TeslaHttpClient(this.email, this.password, this.token, this.endpoints);

  @override
  final String email;

  @override
  final String password;

  @override
  final TeslaApiEndpoints endpoints;

  @override
  TeslaAccessToken token;

  bool isCurrentTokenValid(bool refreshable) {
    if (token == null) {
      return false;
    }

    if (refreshable) {
      var now = new DateTime.now();
      return token.expiresAt.difference(now).abs().inSeconds >= 60;
    }
    return true;
  }

  @override
  bool get isAuthorized => isCurrentTokenValid(true);

  @override
  Future login() async {
    if (!isCurrentTokenValid(false)) {
      const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random _rnd = Random();

      var codeVerifier = String.fromCharCodes(Iterable.generate(
          86, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      var base64CodeVerifier = Base64Encoder.urlSafe().convert(
          const Utf8Encoder().convert(codeVerifier));

      List<int> bytes = const Utf8Encoder().convert(codeVerifier);
      var hash = sha256.convert(bytes);
      var codeChallenge = Base64Encoder.urlSafe().convert(hash.bytes);

      var state = Base64Encoder.urlSafe().convert(
          const Utf8Encoder().convert(
              String.fromCharCodes(Iterable.generate(
              8, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))))
          )
      );

      var step1 = await sendHttpRequest("oauth2/v3/authorize",
          queryParameters: {
            "client_id": "ownerapi",
            "code_challenge": codeChallenge,
            "code_challenge_method": "S256",
            "redirect_uri": "https://auth.tesla.com/void/callback",
            "response_type": "code",
            "scope": "openid email offline_access",
            "state": state,
          },
          needsToken: false,
          type: TeslaApiType.OauthApiStep1,
      );

      step1['identity'] = email;
      step1['credential'] = password;

      var step2 = await sendHttpRequest("oauth2/v3/authorize",
        queryParameters: {
          "client_id": "ownerapi",
          "code_challenge": codeChallenge,
          "code_challenge_method": "S256",
          "redirect_uri": "https://auth.tesla.com/void/callback",
          "response_type": "code",
          "scope": "openid email offline_access",
          "state": state,
        },
        body: step1,
        needsToken: false,
        type: TeslaApiType.OauthApiStep2,
      );

      var step3 = await sendHttpRequest("oauth2/v3/token",
        body: {
          "grant_type": "authorization_code",
          "client_id": "ownerapi",
          "code": step2["code"],
          "code_verifier": codeVerifier,
          "redirect_uri": "https://auth.tesla.com/void/callback",
        },
        needsToken: false,
        type: TeslaApiType.OauthApiStep3,
      );

      var accessToken = step3['access_token'];
      var step4 = await sendHttpRequest("oauth/token",
        body: {
            "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
            "client_id": endpoints.clientId,
            "client_secret": endpoints.clientSecret,
          },
        type: TeslaApiType.OwnersApi,
        headers: {
          "Authorization": "Bearer ${accessToken}",
        },
        needsToken: false,
      );

      step4["refresh_token"] = step3["refresh_token"];
      token = new TeslaJsonAccessToken(step4);
      return;
    }

    var refresh = await sendHttpRequest("oauth2/v3/token",
        body: {
          "grant_type": "refresh_token",
          "client_id": "ownerapi",
          "refresh_token": token.refreshToken,
          "scope": "openid email offline_access",
        },
        needsToken: false,
        type: TeslaApiType.OauthApiStep3);

    var accessToken = refresh['access_token'];
    var step4 = await sendHttpRequest("oauth/token",
      body: {
        "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
        "client_id": endpoints.clientId,
        "client_secret": endpoints.clientSecret,
      },
      type: TeslaApiType.OwnersApi,
      headers: {
        "Authorization": "Bearer ${accessToken}",
      },
      needsToken: false,
    );

    step4["refresh_token"] = refresh["refresh_token"];
    token = new TeslaJsonAccessToken(step4);
  }

  @override
  Future<List<Vehicle>> listVehicles() async {
    var vehicles = <Vehicle>[];

    var result = await getJsonList("vehicles");

    for (var item in result) {
      vehicles.add(new Vehicle(this, item));
    }

    return vehicles;
  }

  @override
  Future<Vehicle> getVehicle(int id) async {
    return new Vehicle(this, await getJsonMap("vehicles/${id}"));
  }

  @override
  Future<AllVehicleState> getAllVehicleState(int id) async {
    return new AllVehicleState(
        this, await getJsonMap("vehicles/${id}/vehicle_data"));
  }

  @override
  Future<ChargeState> getChargeState(int id) async {
    return new ChargeState(
        this, await getJsonMap("vehicles/${id}/data_request/charge_state"));
  }

  @override
  Future<DriveState> getDriveState(int id) async {
    return new DriveState(
        this, await getJsonMap("vehicles/${id}/data_request/drive_state"));
  }

  @override
  Future<ClimateState> getClimateState(int id) async {
    return new ClimateState(
        this, await getJsonMap("vehicles/${id}/data_request/climate_state"));
  }

  @override
  Future<VehicleConfig> getVehicleConfig(int id) async {
    return new VehicleConfig(
        this, await getJsonMap("vehicles/${id}/data_request/vehicle_config"));
  }

  @override
  Future<GuiSettings> getGuiSettings(int id) async {
    return new GuiSettings(
        this, await getJsonMap("vehicles/${id}/data_request/gui_settings"));
  }

  @override
  Future sendVehicleCommand(int vehicleId, String command,
      {Map<String, dynamic> params}) async {
    var result = await getJsonMap("vehicles/${vehicleId}/command/${command}",
        body: params == null ? {} : params, extract: null);
    if (result["response"] == false) {
      var reason = result["reason"];
      if (reason is String && reason.trim().isNotEmpty) {
        throw new Exception("Failed to send command '${command}': ${reason}");
      } else {
        throw new Exception("Failed to send command '${command}'");
      }
    }
  }

  @override
  Future<List<Supercharger>> listSuperchargers() async {
    var chargers = <Supercharger>[];

    var result = await getJsonList("all-locations", type: TeslaApiType.TeslaApi, standard: false);

    for (var item in result) {
      chargers.add(new Supercharger(this, item));
    }

    return chargers;
  }

  @override
  Future<Vehicle> wake(int id) async {
    return new Vehicle(
        this, await getJsonMap("vehicles/${id}/wake_up", body: {}));
  }

  Future<Map<String, dynamic>> getJsonMap(
    String url, {
    Map<String, dynamic> body,
    String extract: "response",
    bool standard: true,
    TeslaApiType type = TeslaApiType.OwnersApi,
  }) async {
    return (await sendHttpRequest(_apiUrl(url, standard),
        body: body, extract: extract, type: type)) as Map<String, dynamic>;
  }

  Future<List<dynamic>> getJsonList(
    String url, {
    Map<String, dynamic> body,
    String extract: "response",
    bool standard: true,
    TeslaApiType type = TeslaApiType.OwnersApi,
  }) async {
    return (await sendHttpRequest(_apiUrl(url, standard),
        body: body, extract: extract, type: type)) as List<dynamic>;
  }

  Future<dynamic> sendHttpRequest(
    String url, {
    bool needsToken: true,
    String extract,
    Map<String, dynamic> body,
    TeslaApiType type = TeslaApiType.OwnersApi,
    Map<String, dynamic /*String|Iterable<String>*/ > queryParameters,
    Map<String, String> headers,
  });

  String _apiUrl(String path, bool standard) =>
      standard ? "/api/1/${path}" : path;
}
