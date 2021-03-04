library tesla.impl.io;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../tesla.dart';
import 'common/summon.dart';
import 'common/http.dart';

import 'package:html/parser.dart';

final ContentType _jsonContentType =
    new ContentType("application", "json", charset: "utf-8");

final ContentType _urlencodedContentType =
new ContentType("application", "x-www-form-urlencoded", charset: "utf-8");


HttpClient _createHttpClient() {
  var client = new HttpClient();
  client.userAgent = "Tesla.dart";
  return client;
}

class TeslaClientImpl extends TeslaHttpClient {
  TeslaClientImpl(String email, String password, TeslaAccessToken token,
      TeslaApiEndpoints endpoints,
      {HttpClient client})
      : this.client = client == null ? _createHttpClient() : client,
        super(email, password, token, endpoints);

  final HttpClient client;

  @override
  Future<dynamic> sendHttpRequest(
    String url, {
    bool needsToken: true,
    String extract,
    Map<String, dynamic> body,
    TeslaApiType type = TeslaApiType.OwnersApi,
    Map<String, dynamic /*String|Iterable<String>*/ > queryParameters,
    Map<String, String> headers,
  }) async {
    Uri uri;
    if (type == TeslaApiType.TeslaApi) {
      uri = endpoints.teslaApiUl.resolve(url);
      needsToken = false;
    } else if (type == TeslaApiType.OwnersApi) {
      uri = endpoints.ownersApiUrl.resolve(url);
    } else {
      uri = endpoints.authApiUrl.resolve(url);
    }

    if (endpoints.enableProxyMode) {
      uri = uri.replace(queryParameters: {"__tesla": "api"});
    }

    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    var request;
    if (type == TeslaApiType.OauthApiStep1) {
      request = await client.getUrl(uri);
    } else if (type == TeslaApiType.OauthApiStep2) {
      request = await client.postUrl(uri);
      request.followRedirects = false;
    } else {
      if (body == null) {
        request = await client.getUrl(uri);
      } else {
        request = await client.postUrl(uri);
      }
    }

    request.headers.set("User-Agent", "Tesla.dart");
    request.headers.add("x-tesla-user-agent", "Tesla.dart");
    request.headers.add("X-Requested-With", "com.teslamotors.tesla");

    if (headers != null) {
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });
    }

    if (needsToken) {
      if (!isCurrentTokenValid(true)) {
        await login();
      }
      request.headers.add("Authorization", "Bearer ${token.accessToken}");
    }
    if (body != null) {
      if (type == TeslaApiType.OauthApiStep2) {
        request.headers.contentType = _urlencodedContentType;
        var parts = [];
        body.forEach((key, value) {
          parts.add('${Uri.encodeQueryComponent(key)}='
              '${Uri.encodeQueryComponent(value)}');
        });
        var formData = parts.join('&');
        List<int> bodyBytes = utf8.encode(formData);
        request.headers.set('Content-Length', bodyBytes.length.toString());
        request.add(bodyBytes);
      } else {
        request.headers.contentType = _jsonContentType;
        request.write(const JsonEncoder().convert(body));
      }
    }
    HttpClientResponse response = await request.close()
      .timeout(const Duration(seconds: 4));
    var content =
        await response.cast<List<int>>().transform(const Utf8Decoder()).join();
    if (type == TeslaApiType.OauthApiStep2) {
      if (response.statusCode == 302) {
        if (content.contains("Your account has been locked")) {
          throw new Exception(
              "Failed to perform action. (Status Code: ${response.statusCode})\n${content}");
        }
      }
    } else {
      if (response.statusCode != 200) {
        throw new Exception(
            "Failed to perform action. (Status Code: ${response.statusCode})\n${content}");
      }
    }

    var result;
    if (type == TeslaApiType.OauthApiStep1) {
      var document = parse(content);
      var inputs = document.querySelectorAll("input[type=hidden]");
      var i = 1;
      Map<String, String> temp = new Map();
      inputs.forEach((element) {
        var name = element.attributes['name'];
        var value = element.attributes['value'];
        temp[name] = value;
      });
      response.headers.forEach((name, values) {
        if (name == "set-cookie") {
          if (values.length == 0) {
            throw new Exception("Failed Cookie");
          }
          values.forEach((element) {
            if (element.contains("tesla-auth.sid")) {
              temp['cookie'] = element.split(";")[0];
            }
          });
        }
      });
      result = temp;
    } else if (type == TeslaApiType.OauthApiStep2) {
      Map<String, String> temp = new Map();
      response.headers.forEach((name, values) {
        if (name == "location") {
          if (values.length == 0) {
            throw new Exception("Failed Cookie");
          }
          values.forEach((element) {
            if (element.contains("code=")) {
              temp['code'] = element.split("code=")[1].split("&")[0];
            }
          });
        }
      });
      result = temp;
    } else {
      result = const JsonDecoder().convert(content);
    }

    if (result is Map) {
      if (extract != null) {
        return result[extract];
      }
    }

    return result;
  }

  @override
  Future<SummonClient> summon(int vehicleId, String token) async {
    var uri = endpoints.summonConnectUrl.resolve(vehicleId.toString());
    if (endpoints.enableProxyMode) {
      uri = uri.replace(queryParameters: {"__tesla": "summon"});
    }
    return await SummonClientImpl.connect(uri, email, token);
  }

  @override
  Future close() async {
    await client.close();
  }
}

class SummonClientImpl extends SummonCommonClient {
  SummonClientImpl(this.socket) {
    socket.listen(_onData);
    socket.done.then((_) {
      stopAutoHeartbeat();
    });
  }

  final WebSocket socket;

  void _onData(input) {
    if (input is String) {
      onMessageReceived(input);
    } else {
      var text = const Utf8Decoder().convert(input);
      onMessageReceived(text);
    }
  }

  @override
  void send(SummonRequestMessage message) {
    var output = const JsonEncoder().convert(
        <String, dynamic>{"msg_type": message.type}..addAll(message.params));
    socket.add(output);
  }

  @override
  void close() {
    super.close();
    socket.close();
  }

  static Future<SummonClient> connect(
      Uri url, String email, String token) async {
    var auth = const Base64Encoder.urlSafe()
        .convert(const Utf8Encoder().convert("${email}:${token}"));

    // ignore: close_sinks
    var socket = await WebSocket.connect(url.toString(),
        headers: {"Authorization": "Basic ${auth}"});
    var client = new SummonClientImpl(socket);
    return client;
  }
}
