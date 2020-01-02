// To parse this JSON data, do
//
//     final teslaState = teslaStateFromJson(jsonString);

import 'dart:convert';

import 'package:http/http.dart' as http;

TeslaInfo teslaStateFromJson(String str) {
  final _response = json.decode(str);
  return TeslaInfo.fromJson(_response['response']);
}

String teslaStateToJson(TeslaInfo data) => json.encode(data.toJson());

Future<TeslaInfo> teslaStateFromNetwork(String token, String id) async {
  // debugPrint('ID -> $id');
  final url =
      'https://owner-api.teslamotors.com/api/1/vehicles/$id/vehicle_data';
  final response = await http.get(
    url,
    headers: {
      'User-Agent': "sidecar-tesla",
      'Authorization': 'Bearer $token',
    },
  );
  // debugPrint(response.body);
  if (!response.body.contains("response")) return null;
  return teslaStateFromJson(response.body);
}

class TeslaInfo {
  // int id;
  int userId;
  int vehicleId;
  String vin;
  String displayName;
  String optionCodes;
  dynamic color;
  List<String> tokens;
  String state;
  bool inService;
  String idS;
  bool calendarEnabled;
  int apiVersion;
  dynamic backseatToken;
  dynamic backseatTokenUpdatedAt;
  DriveState driveState;
  ClimateState climateState;
  ChargeState chargeState;
  GuiSettings guiSettings;
  VehicleState vehicleState;
  VehicleConfig vehicleConfig;

  TeslaInfo({
    // this.id,
    this.userId,
    this.vehicleId,
    this.vin,
    this.displayName,
    this.optionCodes,
    this.color,
    this.tokens,
    this.state,
    this.inService,
    this.idS,
    this.calendarEnabled,
    this.apiVersion,
    this.backseatToken,
    this.backseatTokenUpdatedAt,
    this.driveState,
    this.climateState,
    this.chargeState,
    this.guiSettings,
    this.vehicleState,
    this.vehicleConfig,
  });

  TeslaInfo copyWith({
    // double id,
    int userId,
    int vehicleId,
    String vin,
    String displayName,
    String optionCodes,
    dynamic color,
    List<String> tokens,
    String state,
    bool inService,
    String idS,
    bool calendarEnabled,
    int apiVersion,
    dynamic backseatToken,
    dynamic backseatTokenUpdatedAt,
    DriveState driveState,
    ClimateState climateState,
    ChargeState chargeState,
    GuiSettings guiSettings,
    VehicleState vehicleState,
    VehicleConfig vehicleConfig,
  }) =>
      TeslaInfo(
        // id: id ?? this.id,
        userId: userId ?? this.userId,
        vehicleId: vehicleId ?? this.vehicleId,
        vin: vin ?? this.vin,
        displayName: displayName ?? this.displayName,
        optionCodes: optionCodes ?? this.optionCodes,
        color: color ?? this.color,
        tokens: tokens ?? this.tokens,
        state: state ?? this.state,
        inService: inService ?? this.inService,
        idS: idS ?? this.idS,
        calendarEnabled: calendarEnabled ?? this.calendarEnabled,
        apiVersion: apiVersion ?? this.apiVersion,
        backseatToken: backseatToken ?? this.backseatToken,
        backseatTokenUpdatedAt:
            backseatTokenUpdatedAt ?? this.backseatTokenUpdatedAt,
        driveState: driveState ?? this.driveState,
        climateState: climateState ?? this.climateState,
        chargeState: chargeState ?? this.chargeState,
        guiSettings: guiSettings ?? this.guiSettings,
        vehicleState: vehicleState ?? this.vehicleState,
        vehicleConfig: vehicleConfig ?? this.vehicleConfig,
      );

  factory TeslaInfo.fromJson(Map<String, dynamic> json) => TeslaInfo(
        // id: json["id"].toDouble(),
        userId: json["user_id"],
        vehicleId: json["vehicle_id"],
        vin: json["vin"],
        displayName: json["display_name"],
        optionCodes: json["option_codes"],
        color: json["color"],
        tokens: List<String>.from(json["tokens"].map((x) => x)),
        state: json["state"],
        inService: json["in_service"],
        idS: json["id_s"],
        calendarEnabled: json["calendar_enabled"],
        apiVersion: json["api_version"],
        backseatToken: json["backseat_token"],
        backseatTokenUpdatedAt: json["backseat_token_updated_at"],
        driveState: DriveState.fromJson(json["drive_state"]),
        climateState: ClimateState.fromJson(json["climate_state"]),
        chargeState: ChargeState.fromJson(json["charge_state"]),
        guiSettings: GuiSettings.fromJson(json["gui_settings"]),
        vehicleState: VehicleState.fromJson(json["vehicle_state"]),
        vehicleConfig: VehicleConfig.fromJson(json["vehicle_config"]),
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "user_id": userId,
        "vehicle_id": vehicleId,
        "vin": vin,
        "display_name": displayName,
        "option_codes": optionCodes,
        "color": color,
        "tokens": List<dynamic>.from(tokens.map((x) => x)),
        "state": state,
        "in_service": inService,
        "id_s": idS,
        "calendar_enabled": calendarEnabled,
        "api_version": apiVersion,
        "backseat_token": backseatToken,
        "backseat_token_updated_at": backseatTokenUpdatedAt,
        "drive_state": driveState.toJson(),
        "climate_state": climateState.toJson(),
        "charge_state": chargeState.toJson(),
        "gui_settings": guiSettings.toJson(),
        "vehicle_state": vehicleState.toJson(),
        "vehicle_config": vehicleConfig.toJson(),
      };
}

class ChargeState {
  bool batteryHeaterOn;
  int batteryLevel;
  double batteryRange;
  int chargeCurrentRequest;
  int chargeCurrentRequestMax;
  bool chargeEnableRequest;
  double chargeEnergyAdded;
  int chargeLimitSoc;
  int chargeLimitSocMax;
  int chargeLimitSocMin;
  int chargeLimitSocStd;
  double chargeMilesAddedIdeal;
  double chargeMilesAddedRated;
  bool chargePortColdWeatherMode;
  bool chargePortDoorOpen;
  String chargePortLatch;
  double chargeRate;
  bool chargeToMaxRange;
  int chargerActualCurrent;
  dynamic chargerPhases;
  int chargerPilotCurrent;
  int chargerPower;
  int chargerVoltage;
  String chargingState;
  String connChargeCable;
  double estBatteryRange;
  String fastChargerBrand;
  bool fastChargerPresent;
  String fastChargerType;
  double idealBatteryRange;
  bool managedChargingActive;
  dynamic managedChargingStartTime;
  bool managedChargingUserCanceled;
  int maxRangeChargeCounter;
  int minutesToFullCharge;
  bool notEnoughPowerToHeat;
  bool scheduledChargingPending;
  dynamic scheduledChargingStartTime;
  double timeToFullCharge;
  int timestamp;
  bool tripCharging;
  int usableBatteryLevel;
  dynamic userChargeEnableRequest;

  ChargeState({
    this.batteryHeaterOn,
    this.batteryLevel,
    this.batteryRange,
    this.chargeCurrentRequest,
    this.chargeCurrentRequestMax,
    this.chargeEnableRequest,
    this.chargeEnergyAdded,
    this.chargeLimitSoc,
    this.chargeLimitSocMax,
    this.chargeLimitSocMin,
    this.chargeLimitSocStd,
    this.chargeMilesAddedIdeal,
    this.chargeMilesAddedRated,
    this.chargePortColdWeatherMode,
    this.chargePortDoorOpen,
    this.chargePortLatch,
    this.chargeRate,
    this.chargeToMaxRange,
    this.chargerActualCurrent,
    this.chargerPhases,
    this.chargerPilotCurrent,
    this.chargerPower,
    this.chargerVoltage,
    this.chargingState,
    this.connChargeCable,
    this.estBatteryRange,
    this.fastChargerBrand,
    this.fastChargerPresent,
    this.fastChargerType,
    this.idealBatteryRange,
    this.managedChargingActive,
    this.managedChargingStartTime,
    this.managedChargingUserCanceled,
    this.maxRangeChargeCounter,
    this.minutesToFullCharge,
    this.notEnoughPowerToHeat,
    this.scheduledChargingPending,
    this.scheduledChargingStartTime,
    this.timeToFullCharge,
    this.timestamp,
    this.tripCharging,
    this.usableBatteryLevel,
    this.userChargeEnableRequest,
  });

  ChargeState copyWith({
    bool batteryHeaterOn,
    int batteryLevel,
    double batteryRange,
    int chargeCurrentRequest,
    int chargeCurrentRequestMax,
    bool chargeEnableRequest,
    double chargeEnergyAdded,
    int chargeLimitSoc,
    int chargeLimitSocMax,
    int chargeLimitSocMin,
    int chargeLimitSocStd,
    double chargeMilesAddedIdeal,
    double chargeMilesAddedRated,
    bool chargePortColdWeatherMode,
    bool chargePortDoorOpen,
    String chargePortLatch,
    double chargeRate,
    bool chargeToMaxRange,
    int chargerActualCurrent,
    dynamic chargerPhases,
    int chargerPilotCurrent,
    int chargerPower,
    int chargerVoltage,
    String chargingState,
    String connChargeCable,
    double estBatteryRange,
    String fastChargerBrand,
    bool fastChargerPresent,
    String fastChargerType,
    double idealBatteryRange,
    bool managedChargingActive,
    dynamic managedChargingStartTime,
    bool managedChargingUserCanceled,
    int maxRangeChargeCounter,
    int minutesToFullCharge,
    bool notEnoughPowerToHeat,
    bool scheduledChargingPending,
    dynamic scheduledChargingStartTime,
    double timeToFullCharge,
    int timestamp,
    bool tripCharging,
    int usableBatteryLevel,
    dynamic userChargeEnableRequest,
  }) =>
      ChargeState(
        batteryHeaterOn: batteryHeaterOn ?? this.batteryHeaterOn,
        batteryLevel: batteryLevel ?? this.batteryLevel,
        batteryRange: batteryRange ?? this.batteryRange,
        chargeCurrentRequest: chargeCurrentRequest ?? this.chargeCurrentRequest,
        chargeCurrentRequestMax:
            chargeCurrentRequestMax ?? this.chargeCurrentRequestMax,
        chargeEnableRequest: chargeEnableRequest ?? this.chargeEnableRequest,
        chargeEnergyAdded: chargeEnergyAdded ?? this.chargeEnergyAdded,
        chargeLimitSoc: chargeLimitSoc ?? this.chargeLimitSoc,
        chargeLimitSocMax: chargeLimitSocMax ?? this.chargeLimitSocMax,
        chargeLimitSocMin: chargeLimitSocMin ?? this.chargeLimitSocMin,
        chargeLimitSocStd: chargeLimitSocStd ?? this.chargeLimitSocStd,
        chargeMilesAddedIdeal:
            chargeMilesAddedIdeal ?? this.chargeMilesAddedIdeal,
        chargeMilesAddedRated:
            chargeMilesAddedRated ?? this.chargeMilesAddedRated,
        chargePortColdWeatherMode:
            chargePortColdWeatherMode ?? this.chargePortColdWeatherMode,
        chargePortDoorOpen: chargePortDoorOpen ?? this.chargePortDoorOpen,
        chargePortLatch: chargePortLatch ?? this.chargePortLatch,
        chargeRate: chargeRate ?? this.chargeRate,
        chargeToMaxRange: chargeToMaxRange ?? this.chargeToMaxRange,
        chargerActualCurrent: chargerActualCurrent ?? this.chargerActualCurrent,
        chargerPhases: chargerPhases ?? this.chargerPhases,
        chargerPilotCurrent: chargerPilotCurrent ?? this.chargerPilotCurrent,
        chargerPower: chargerPower ?? this.chargerPower,
        chargerVoltage: chargerVoltage ?? this.chargerVoltage,
        chargingState: chargingState ?? this.chargingState,
        connChargeCable: connChargeCable ?? this.connChargeCable,
        estBatteryRange: estBatteryRange ?? this.estBatteryRange,
        fastChargerBrand: fastChargerBrand ?? this.fastChargerBrand,
        fastChargerPresent: fastChargerPresent ?? this.fastChargerPresent,
        fastChargerType: fastChargerType ?? this.fastChargerType,
        idealBatteryRange: idealBatteryRange ?? this.idealBatteryRange,
        managedChargingActive:
            managedChargingActive ?? this.managedChargingActive,
        managedChargingStartTime:
            managedChargingStartTime ?? this.managedChargingStartTime,
        managedChargingUserCanceled:
            managedChargingUserCanceled ?? this.managedChargingUserCanceled,
        maxRangeChargeCounter:
            maxRangeChargeCounter ?? this.maxRangeChargeCounter,
        minutesToFullCharge: minutesToFullCharge ?? this.minutesToFullCharge,
        notEnoughPowerToHeat: notEnoughPowerToHeat ?? this.notEnoughPowerToHeat,
        scheduledChargingPending:
            scheduledChargingPending ?? this.scheduledChargingPending,
        scheduledChargingStartTime:
            scheduledChargingStartTime ?? this.scheduledChargingStartTime,
        timeToFullCharge: timeToFullCharge ?? this.timeToFullCharge,
        timestamp: timestamp ?? this.timestamp,
        tripCharging: tripCharging ?? this.tripCharging,
        usableBatteryLevel: usableBatteryLevel ?? this.usableBatteryLevel,
        userChargeEnableRequest:
            userChargeEnableRequest ?? this.userChargeEnableRequest,
      );

  factory ChargeState.fromJson(Map<String, dynamic> json) => ChargeState(
        batteryHeaterOn: json["battery_heater_on"],
        batteryLevel: json["battery_level"],
        batteryRange: json["battery_range"].toDouble(),
        chargeCurrentRequest: json["charge_current_request"],
        chargeCurrentRequestMax: json["charge_current_request_max"],
        chargeEnableRequest: json["charge_enable_request"],
        chargeEnergyAdded: json["charge_energy_added"].toDouble(),
        chargeLimitSoc: json["charge_limit_soc"],
        chargeLimitSocMax: json["charge_limit_soc_max"],
        chargeLimitSocMin: json["charge_limit_soc_min"],
        chargeLimitSocStd: json["charge_limit_soc_std"],
        chargeMilesAddedIdeal: json["charge_miles_added_ideal"],
        chargeMilesAddedRated: json["charge_miles_added_rated"],
        chargePortColdWeatherMode: json["charge_port_cold_weather_mode"],
        chargePortDoorOpen: json["charge_port_door_open"],
        chargePortLatch: json["charge_port_latch"],
        chargeRate: json["charge_rate"],
        chargeToMaxRange: json["charge_to_max_range"],
        chargerActualCurrent: json["charger_actual_current"],
        chargerPhases: json["charger_phases"],
        chargerPilotCurrent: json["charger_pilot_current"],
        chargerPower: json["charger_power"],
        chargerVoltage: json["charger_voltage"],
        chargingState: json["charging_state"],
        connChargeCable: json["conn_charge_cable"],
        estBatteryRange: json["est_battery_range"].toDouble(),
        fastChargerBrand: json["fast_charger_brand"],
        fastChargerPresent: json["fast_charger_present"],
        fastChargerType: json["fast_charger_type"],
        idealBatteryRange: json["ideal_battery_range"].toDouble(),
        managedChargingActive: json["managed_charging_active"],
        managedChargingStartTime: json["managed_charging_start_time"],
        managedChargingUserCanceled: json["managed_charging_user_canceled"],
        maxRangeChargeCounter: json["max_range_charge_counter"],
        minutesToFullCharge: json["minutes_to_full_charge"],
        notEnoughPowerToHeat: json["not_enough_power_to_heat"],
        scheduledChargingPending: json["scheduled_charging_pending"],
        scheduledChargingStartTime: json["scheduled_charging_start_time"],
        timeToFullCharge: json["time_to_full_charge"],
        timestamp: json["timestamp"],
        tripCharging: json["trip_charging"],
        usableBatteryLevel: json["usable_battery_level"],
        userChargeEnableRequest: json["user_charge_enable_request"],
      );

  Map<String, dynamic> toJson() => {
        "battery_heater_on": batteryHeaterOn,
        "battery_level": batteryLevel,
        "battery_range": batteryRange,
        "charge_current_request": chargeCurrentRequest,
        "charge_current_request_max": chargeCurrentRequestMax,
        "charge_enable_request": chargeEnableRequest,
        "charge_energy_added": chargeEnergyAdded,
        "charge_limit_soc": chargeLimitSoc,
        "charge_limit_soc_max": chargeLimitSocMax,
        "charge_limit_soc_min": chargeLimitSocMin,
        "charge_limit_soc_std": chargeLimitSocStd,
        "charge_miles_added_ideal": chargeMilesAddedIdeal,
        "charge_miles_added_rated": chargeMilesAddedRated,
        "charge_port_cold_weather_mode": chargePortColdWeatherMode,
        "charge_port_door_open": chargePortDoorOpen,
        "charge_port_latch": chargePortLatch,
        "charge_rate": chargeRate,
        "charge_to_max_range": chargeToMaxRange,
        "charger_actual_current": chargerActualCurrent,
        "charger_phases": chargerPhases,
        "charger_pilot_current": chargerPilotCurrent,
        "charger_power": chargerPower,
        "charger_voltage": chargerVoltage,
        "charging_state": chargingState,
        "conn_charge_cable": connChargeCable,
        "est_battery_range": estBatteryRange,
        "fast_charger_brand": fastChargerBrand,
        "fast_charger_present": fastChargerPresent,
        "fast_charger_type": fastChargerType,
        "ideal_battery_range": idealBatteryRange,
        "managed_charging_active": managedChargingActive,
        "managed_charging_start_time": managedChargingStartTime,
        "managed_charging_user_canceled": managedChargingUserCanceled,
        "max_range_charge_counter": maxRangeChargeCounter,
        "minutes_to_full_charge": minutesToFullCharge,
        "not_enough_power_to_heat": notEnoughPowerToHeat,
        "scheduled_charging_pending": scheduledChargingPending,
        "scheduled_charging_start_time": scheduledChargingStartTime,
        "time_to_full_charge": timeToFullCharge,
        "timestamp": timestamp,
        "trip_charging": tripCharging,
        "usable_battery_level": usableBatteryLevel,
        "user_charge_enable_request": userChargeEnableRequest,
      };
}

class ClimateState {
  bool batteryHeater;
  bool batteryHeaterNoPower;
  String climateKeeperMode;
  int defrostMode;
  double driverTempSetting;
  int fanStatus;
  dynamic insideTemp;
  dynamic isAutoConditioningOn;
  bool isClimateOn;
  bool isFrontDefrosterOn;
  bool isPreconditioning;
  bool isRearDefrosterOn;
  dynamic leftTempDirection;
  double maxAvailTemp;
  double minAvailTemp;
  dynamic outsideTemp;
  double passengerTempSetting;
  bool remoteHeaterControlEnabled;
  dynamic rightTempDirection;
  int seatHeaterLeft;
  int seatHeaterRearCenter;
  int seatHeaterRearLeft;
  int seatHeaterRearLeftBack;
  int seatHeaterRearRight;
  int seatHeaterRearRightBack;
  int seatHeaterRight;
  bool sideMirrorHeaters;
  bool steeringWheelHeater;
  int timestamp;
  bool wiperBladeHeater;

  ClimateState({
    this.batteryHeater,
    this.batteryHeaterNoPower,
    this.climateKeeperMode,
    this.defrostMode,
    this.driverTempSetting,
    this.fanStatus,
    this.insideTemp,
    this.isAutoConditioningOn,
    this.isClimateOn,
    this.isFrontDefrosterOn,
    this.isPreconditioning,
    this.isRearDefrosterOn,
    this.leftTempDirection,
    this.maxAvailTemp,
    this.minAvailTemp,
    this.outsideTemp,
    this.passengerTempSetting,
    this.remoteHeaterControlEnabled,
    this.rightTempDirection,
    this.seatHeaterLeft,
    this.seatHeaterRearCenter,
    this.seatHeaterRearLeft,
    this.seatHeaterRearLeftBack,
    this.seatHeaterRearRight,
    this.seatHeaterRearRightBack,
    this.seatHeaterRight,
    this.sideMirrorHeaters,
    this.steeringWheelHeater,
    this.timestamp,
    this.wiperBladeHeater,
  });

  ClimateState copyWith({
    bool batteryHeater,
    bool batteryHeaterNoPower,
    String climateKeeperMode,
    int defrostMode,
    double driverTempSetting,
    int fanStatus,
    dynamic insideTemp,
    dynamic isAutoConditioningOn,
    bool isClimateOn,
    bool isFrontDefrosterOn,
    bool isPreconditioning,
    bool isRearDefrosterOn,
    dynamic leftTempDirection,
    double maxAvailTemp,
    double minAvailTemp,
    dynamic outsideTemp,
    double passengerTempSetting,
    bool remoteHeaterControlEnabled,
    dynamic rightTempDirection,
    int seatHeaterLeft,
    int seatHeaterRearCenter,
    int seatHeaterRearLeft,
    int seatHeaterRearLeftBack,
    int seatHeaterRearRight,
    int seatHeaterRearRightBack,
    int seatHeaterRight,
    bool sideMirrorHeaters,
    bool steeringWheelHeater,
    int timestamp,
    bool wiperBladeHeater,
  }) =>
      ClimateState(
        batteryHeater: batteryHeater ?? this.batteryHeater,
        batteryHeaterNoPower: batteryHeaterNoPower ?? this.batteryHeaterNoPower,
        climateKeeperMode: climateKeeperMode ?? this.climateKeeperMode,
        defrostMode: defrostMode ?? this.defrostMode,
        driverTempSetting: driverTempSetting ?? this.driverTempSetting,
        fanStatus: fanStatus ?? this.fanStatus,
        insideTemp: insideTemp ?? this.insideTemp,
        isAutoConditioningOn: isAutoConditioningOn ?? this.isAutoConditioningOn,
        isClimateOn: isClimateOn ?? this.isClimateOn,
        isFrontDefrosterOn: isFrontDefrosterOn ?? this.isFrontDefrosterOn,
        isPreconditioning: isPreconditioning ?? this.isPreconditioning,
        isRearDefrosterOn: isRearDefrosterOn ?? this.isRearDefrosterOn,
        leftTempDirection: leftTempDirection ?? this.leftTempDirection,
        maxAvailTemp: maxAvailTemp ?? this.maxAvailTemp,
        minAvailTemp: minAvailTemp ?? this.minAvailTemp,
        outsideTemp: outsideTemp ?? this.outsideTemp,
        passengerTempSetting: passengerTempSetting ?? this.passengerTempSetting,
        remoteHeaterControlEnabled:
            remoteHeaterControlEnabled ?? this.remoteHeaterControlEnabled,
        rightTempDirection: rightTempDirection ?? this.rightTempDirection,
        seatHeaterLeft: seatHeaterLeft ?? this.seatHeaterLeft,
        seatHeaterRearCenter: seatHeaterRearCenter ?? this.seatHeaterRearCenter,
        seatHeaterRearLeft: seatHeaterRearLeft ?? this.seatHeaterRearLeft,
        seatHeaterRearLeftBack:
            seatHeaterRearLeftBack ?? this.seatHeaterRearLeftBack,
        seatHeaterRearRight: seatHeaterRearRight ?? this.seatHeaterRearRight,
        seatHeaterRearRightBack:
            seatHeaterRearRightBack ?? this.seatHeaterRearRightBack,
        seatHeaterRight: seatHeaterRight ?? this.seatHeaterRight,
        sideMirrorHeaters: sideMirrorHeaters ?? this.sideMirrorHeaters,
        steeringWheelHeater: steeringWheelHeater ?? this.steeringWheelHeater,
        timestamp: timestamp ?? this.timestamp,
        wiperBladeHeater: wiperBladeHeater ?? this.wiperBladeHeater,
      );

  factory ClimateState.fromJson(Map<String, dynamic> json) => ClimateState(
        batteryHeater: json["battery_heater"],
        batteryHeaterNoPower: json["battery_heater_no_power"],
        climateKeeperMode: json["climate_keeper_mode"],
        defrostMode: json["defrost_mode"],
        driverTempSetting: json["driver_temp_setting"].toDouble(),
        fanStatus: json["fan_status"],
        insideTemp: json["inside_temp"],
        isAutoConditioningOn: json["is_auto_conditioning_on"],
        isClimateOn: json["is_climate_on"],
        isFrontDefrosterOn: json["is_front_defroster_on"],
        isPreconditioning: json["is_preconditioning"],
        isRearDefrosterOn: json["is_rear_defroster_on"],
        leftTempDirection: json["left_temp_direction"],
        maxAvailTemp: json["max_avail_temp"],
        minAvailTemp: json["min_avail_temp"],
        outsideTemp: json["outside_temp"],
        passengerTempSetting: json["passenger_temp_setting"].toDouble(),
        remoteHeaterControlEnabled: json["remote_heater_control_enabled"],
        rightTempDirection: json["right_temp_direction"],
        seatHeaterLeft: json["seat_heater_left"],
        seatHeaterRearCenter: json["seat_heater_rear_center"],
        seatHeaterRearLeft: json["seat_heater_rear_left"],
        seatHeaterRearLeftBack: json["seat_heater_rear_left_back"],
        seatHeaterRearRight: json["seat_heater_rear_right"],
        seatHeaterRearRightBack: json["seat_heater_rear_right_back"],
        seatHeaterRight: json["seat_heater_right"],
        sideMirrorHeaters: json["side_mirror_heaters"],
        steeringWheelHeater: json["steering_wheel_heater"],
        timestamp: json["timestamp"],
        wiperBladeHeater: json["wiper_blade_heater"],
      );

  Map<String, dynamic> toJson() => {
        "battery_heater": batteryHeater,
        "battery_heater_no_power": batteryHeaterNoPower,
        "climate_keeper_mode": climateKeeperMode,
        "defrost_mode": defrostMode,
        "driver_temp_setting": driverTempSetting,
        "fan_status": fanStatus,
        "inside_temp": insideTemp,
        "is_auto_conditioning_on": isAutoConditioningOn,
        "is_climate_on": isClimateOn,
        "is_front_defroster_on": isFrontDefrosterOn,
        "is_preconditioning": isPreconditioning,
        "is_rear_defroster_on": isRearDefrosterOn,
        "left_temp_direction": leftTempDirection,
        "max_avail_temp": maxAvailTemp,
        "min_avail_temp": minAvailTemp,
        "outside_temp": outsideTemp,
        "passenger_temp_setting": passengerTempSetting,
        "remote_heater_control_enabled": remoteHeaterControlEnabled,
        "right_temp_direction": rightTempDirection,
        "seat_heater_left": seatHeaterLeft,
        "seat_heater_rear_center": seatHeaterRearCenter,
        "seat_heater_rear_left": seatHeaterRearLeft,
        "seat_heater_rear_left_back": seatHeaterRearLeftBack,
        "seat_heater_rear_right": seatHeaterRearRight,
        "seat_heater_rear_right_back": seatHeaterRearRightBack,
        "seat_heater_right": seatHeaterRight,
        "side_mirror_heaters": sideMirrorHeaters,
        "steering_wheel_heater": steeringWheelHeater,
        "timestamp": timestamp,
        "wiper_blade_heater": wiperBladeHeater,
      };
}

class DriveState {
  int gpsAsOf;
  int heading;
  double latitude;
  double longitude;
  double nativeLatitude;
  int nativeLocationSupported;
  double nativeLongitude;
  String nativeType;
  int power;
  dynamic shiftState;
  double speed;
  int timestamp;

  DriveState({
    this.gpsAsOf,
    this.heading,
    this.latitude,
    this.longitude,
    this.nativeLatitude,
    this.nativeLocationSupported,
    this.nativeLongitude,
    this.nativeType,
    this.power,
    this.shiftState,
    this.speed,
    this.timestamp,
  });

  DriveState copyWith({
    int gpsAsOf,
    int heading,
    double latitude,
    double longitude,
    double nativeLatitude,
    int nativeLocationSupported,
    double nativeLongitude,
    String nativeType,
    int power,
    dynamic shiftState,
    double speed,
    int timestamp,
  }) =>
      DriveState(
        gpsAsOf: gpsAsOf ?? this.gpsAsOf,
        heading: heading ?? this.heading,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        nativeLatitude: nativeLatitude ?? this.nativeLatitude,
        nativeLocationSupported:
            nativeLocationSupported ?? this.nativeLocationSupported,
        nativeLongitude: nativeLongitude ?? this.nativeLongitude,
        nativeType: nativeType ?? this.nativeType,
        power: power ?? this.power,
        shiftState: shiftState ?? this.shiftState,
        speed: speed ?? this.speed,
        timestamp: timestamp ?? this.timestamp,
      );

  factory DriveState.fromJson(Map<String, dynamic> json) => DriveState(
        gpsAsOf: json["gps_as_of"],
        heading: json["heading"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        nativeLatitude: json["native_latitude"].toDouble(),
        nativeLocationSupported: json["native_location_supported"],
        nativeLongitude: json["native_longitude"].toDouble(),
        nativeType: json["native_type"],
        power: json["power"],
        shiftState: json["shift_state"],
        speed: json["speed"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "gps_as_of": gpsAsOf,
        "heading": heading,
        "latitude": latitude,
        "longitude": longitude,
        "native_latitude": nativeLatitude,
        "native_location_supported": nativeLocationSupported,
        "native_longitude": nativeLongitude,
        "native_type": nativeType,
        "power": power,
        "shift_state": shiftState,
        "speed": speed,
        "timestamp": timestamp,
      };
}

class GuiSettings {
  bool gui24HourTime;
  String guiChargeRateUnits;
  String guiDistanceUnits;
  String guiRangeDisplay;
  String guiTemperatureUnits;
  bool showRangeUnits;
  int timestamp;

  GuiSettings({
    this.gui24HourTime,
    this.guiChargeRateUnits,
    this.guiDistanceUnits,
    this.guiRangeDisplay,
    this.guiTemperatureUnits,
    this.showRangeUnits,
    this.timestamp,
  });

  GuiSettings copyWith({
    bool gui24HourTime,
    String guiChargeRateUnits,
    String guiDistanceUnits,
    String guiRangeDisplay,
    String guiTemperatureUnits,
    bool showRangeUnits,
    int timestamp,
  }) =>
      GuiSettings(
        gui24HourTime: gui24HourTime ?? this.gui24HourTime,
        guiChargeRateUnits: guiChargeRateUnits ?? this.guiChargeRateUnits,
        guiDistanceUnits: guiDistanceUnits ?? this.guiDistanceUnits,
        guiRangeDisplay: guiRangeDisplay ?? this.guiRangeDisplay,
        guiTemperatureUnits: guiTemperatureUnits ?? this.guiTemperatureUnits,
        showRangeUnits: showRangeUnits ?? this.showRangeUnits,
        timestamp: timestamp ?? this.timestamp,
      );

  factory GuiSettings.fromJson(Map<String, dynamic> json) => GuiSettings(
        gui24HourTime: json["gui_24_hour_time"],
        guiChargeRateUnits: json["gui_charge_rate_units"],
        guiDistanceUnits: json["gui_distance_units"],
        guiRangeDisplay: json["gui_range_display"],
        guiTemperatureUnits: json["gui_temperature_units"],
        showRangeUnits: json["show_range_units"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "gui_24_hour_time": gui24HourTime,
        "gui_charge_rate_units": guiChargeRateUnits,
        "gui_distance_units": guiDistanceUnits,
        "gui_range_display": guiRangeDisplay,
        "gui_temperature_units": guiTemperatureUnits,
        "show_range_units": showRangeUnits,
        "timestamp": timestamp,
      };
}

class VehicleConfig {
  bool canAcceptNavigationRequests;
  bool canActuateTrunks;
  String carSpecialType;
  String carType;
  String chargePortType;
  bool euVehicle;
  String exteriorColor;
  bool hasAirSuspension;
  bool hasLudicrousMode;
  int keyVersion;
  bool motorizedChargePort;
  String perfConfig;
  bool plg;
  int rearSeatHeaters;
  int rearSeatType;
  bool rhd;
  String roofColor;
  int seatType;
  String spoilerType;
  int sunRoofInstalled;
  String thirdRowSeats;
  int timestamp;
  String trimBadging;
  bool useRangeBadging;
  String wheelType;

  VehicleConfig({
    this.canAcceptNavigationRequests,
    this.canActuateTrunks,
    this.carSpecialType,
    this.carType,
    this.chargePortType,
    this.euVehicle,
    this.exteriorColor,
    this.hasAirSuspension,
    this.hasLudicrousMode,
    this.keyVersion,
    this.motorizedChargePort,
    this.perfConfig,
    this.plg,
    this.rearSeatHeaters,
    this.rearSeatType,
    this.rhd,
    this.roofColor,
    this.seatType,
    this.spoilerType,
    this.sunRoofInstalled,
    this.thirdRowSeats,
    this.timestamp,
    this.trimBadging,
    this.useRangeBadging,
    this.wheelType,
  });

  VehicleConfig copyWith({
    bool canAcceptNavigationRequests,
    bool canActuateTrunks,
    String carSpecialType,
    String carType,
    String chargePortType,
    bool euVehicle,
    String exteriorColor,
    bool hasAirSuspension,
    bool hasLudicrousMode,
    int keyVersion,
    bool motorizedChargePort,
    String perfConfig,
    bool plg,
    int rearSeatHeaters,
    int rearSeatType,
    bool rhd,
    String roofColor,
    int seatType,
    String spoilerType,
    int sunRoofInstalled,
    String thirdRowSeats,
    int timestamp,
    String trimBadging,
    bool useRangeBadging,
    String wheelType,
  }) =>
      VehicleConfig(
        canAcceptNavigationRequests:
            canAcceptNavigationRequests ?? this.canAcceptNavigationRequests,
        canActuateTrunks: canActuateTrunks ?? this.canActuateTrunks,
        carSpecialType: carSpecialType ?? this.carSpecialType,
        carType: carType ?? this.carType,
        chargePortType: chargePortType ?? this.chargePortType,
        euVehicle: euVehicle ?? this.euVehicle,
        exteriorColor: exteriorColor ?? this.exteriorColor,
        hasAirSuspension: hasAirSuspension ?? this.hasAirSuspension,
        hasLudicrousMode: hasLudicrousMode ?? this.hasLudicrousMode,
        keyVersion: keyVersion ?? this.keyVersion,
        motorizedChargePort: motorizedChargePort ?? this.motorizedChargePort,
        perfConfig: perfConfig ?? this.perfConfig,
        plg: plg ?? this.plg,
        rearSeatHeaters: rearSeatHeaters ?? this.rearSeatHeaters,
        rearSeatType: rearSeatType ?? this.rearSeatType,
        rhd: rhd ?? this.rhd,
        roofColor: roofColor ?? this.roofColor,
        seatType: seatType ?? this.seatType,
        spoilerType: spoilerType ?? this.spoilerType,
        sunRoofInstalled: sunRoofInstalled ?? this.sunRoofInstalled,
        thirdRowSeats: thirdRowSeats ?? this.thirdRowSeats,
        timestamp: timestamp ?? this.timestamp,
        trimBadging: trimBadging ?? this.trimBadging,
        useRangeBadging: useRangeBadging ?? this.useRangeBadging,
        wheelType: wheelType ?? this.wheelType,
      );

  factory VehicleConfig.fromJson(Map<String, dynamic> json) => VehicleConfig(
        canAcceptNavigationRequests: json["can_accept_navigation_requests"],
        canActuateTrunks: json["can_actuate_trunks"],
        carSpecialType: json["car_special_type"],
        carType: json["car_type"],
        chargePortType: json["charge_port_type"],
        euVehicle: json["eu_vehicle"],
        exteriorColor: json["exterior_color"],
        hasAirSuspension: json["has_air_suspension"],
        hasLudicrousMode: json["has_ludicrous_mode"],
        keyVersion: json["key_version"],
        motorizedChargePort: json["motorized_charge_port"],
        perfConfig: json["perf_config"],
        plg: json["plg"],
        rearSeatHeaters: json["rear_seat_heaters"],
        rearSeatType: json["rear_seat_type"],
        rhd: json["rhd"],
        roofColor: json["roof_color"],
        seatType: json["seat_type"],
        spoilerType: json["spoiler_type"],
        sunRoofInstalled: json["sun_roof_installed"],
        thirdRowSeats: json["third_row_seats"],
        timestamp: json["timestamp"],
        trimBadging: json["trim_badging"],
        useRangeBadging: json["use_range_badging"],
        wheelType: json["wheel_type"],
      );

  Map<String, dynamic> toJson() => {
        "can_accept_navigation_requests": canAcceptNavigationRequests,
        "can_actuate_trunks": canActuateTrunks,
        "car_special_type": carSpecialType,
        "car_type": carType,
        "charge_port_type": chargePortType,
        "eu_vehicle": euVehicle,
        "exterior_color": exteriorColor,
        "has_air_suspension": hasAirSuspension,
        "has_ludicrous_mode": hasLudicrousMode,
        "key_version": keyVersion,
        "motorized_charge_port": motorizedChargePort,
        "perf_config": perfConfig,
        "plg": plg,
        "rear_seat_heaters": rearSeatHeaters,
        "rear_seat_type": rearSeatType,
        "rhd": rhd,
        "roof_color": roofColor,
        "seat_type": seatType,
        "spoiler_type": spoilerType,
        "sun_roof_installed": sunRoofInstalled,
        "third_row_seats": thirdRowSeats,
        "timestamp": timestamp,
        "trim_badging": trimBadging,
        "use_range_badging": useRangeBadging,
        "wheel_type": wheelType,
      };
}

class VehicleState {
  int apiVersion;
  String autoparkStateV2;
  String autoparkStyle;
  bool calendarSupported;
  String carVersion;
  int centerDisplayState;
  int df;
  int dr;
  int fdWindow;
  int fpWindow;
  int ft;
  int homelinkDeviceCount;
  bool homelinkNearby;
  bool isUserPresent;
  String lastAutoparkError;
  bool locked;
  MediaState mediaState;
  bool notificationsSupported;
  double odometer;
  bool parsedCalendarSupported;
  int pf;
  int pr;
  int rdWindow;
  bool remoteStart;
  bool remoteStartEnabled;
  bool remoteStartSupported;
  int rpWindow;
  int rt;
  bool sentryMode;
  bool sentryModeAvailable;
  bool smartSummonAvailable;
  SoftwareUpdate softwareUpdate;
  SpeedLimitMode speedLimitMode;
  bool summonStandbyModeEnabled;
  int sunRoofPercentOpen;
  String sunRoofState;
  int timestamp;
  bool valetMode;
  bool valetPinNeeded;
  String vehicleName;

  VehicleState({
    this.apiVersion,
    this.autoparkStateV2,
    this.autoparkStyle,
    this.calendarSupported,
    this.carVersion,
    this.centerDisplayState,
    this.df,
    this.dr,
    this.fdWindow,
    this.fpWindow,
    this.ft,
    this.homelinkDeviceCount,
    this.homelinkNearby,
    this.isUserPresent,
    this.lastAutoparkError,
    this.locked,
    this.mediaState,
    this.notificationsSupported,
    this.odometer,
    this.parsedCalendarSupported,
    this.pf,
    this.pr,
    this.rdWindow,
    this.remoteStart,
    this.remoteStartEnabled,
    this.remoteStartSupported,
    this.rpWindow,
    this.rt,
    this.sentryMode,
    this.sentryModeAvailable,
    this.smartSummonAvailable,
    this.softwareUpdate,
    this.speedLimitMode,
    this.summonStandbyModeEnabled,
    this.sunRoofPercentOpen,
    this.sunRoofState,
    this.timestamp,
    this.valetMode,
    this.valetPinNeeded,
    this.vehicleName,
  });

  VehicleState copyWith({
    int apiVersion,
    String autoparkStateV2,
    String autoparkStyle,
    bool calendarSupported,
    String carVersion,
    int centerDisplayState,
    int df,
    int dr,
    int fdWindow,
    int fpWindow,
    int ft,
    int homelinkDeviceCount,
    bool homelinkNearby,
    bool isUserPresent,
    String lastAutoparkError,
    bool locked,
    MediaState mediaState,
    bool notificationsSupported,
    double odometer,
    bool parsedCalendarSupported,
    int pf,
    int pr,
    int rdWindow,
    bool remoteStart,
    bool remoteStartEnabled,
    bool remoteStartSupported,
    int rpWindow,
    int rt,
    bool sentryMode,
    bool sentryModeAvailable,
    bool smartSummonAvailable,
    SoftwareUpdate softwareUpdate,
    SpeedLimitMode speedLimitMode,
    bool summonStandbyModeEnabled,
    int sunRoofPercentOpen,
    String sunRoofState,
    int timestamp,
    bool valetMode,
    bool valetPinNeeded,
    String vehicleName,
  }) =>
      VehicleState(
        apiVersion: apiVersion ?? this.apiVersion,
        autoparkStateV2: autoparkStateV2 ?? this.autoparkStateV2,
        autoparkStyle: autoparkStyle ?? this.autoparkStyle,
        calendarSupported: calendarSupported ?? this.calendarSupported,
        carVersion: carVersion ?? this.carVersion,
        centerDisplayState: centerDisplayState ?? this.centerDisplayState,
        df: df ?? this.df,
        dr: dr ?? this.dr,
        fdWindow: fdWindow ?? this.fdWindow,
        fpWindow: fpWindow ?? this.fpWindow,
        ft: ft ?? this.ft,
        homelinkDeviceCount: homelinkDeviceCount ?? this.homelinkDeviceCount,
        homelinkNearby: homelinkNearby ?? this.homelinkNearby,
        isUserPresent: isUserPresent ?? this.isUserPresent,
        lastAutoparkError: lastAutoparkError ?? this.lastAutoparkError,
        locked: locked ?? this.locked,
        mediaState: mediaState ?? this.mediaState,
        notificationsSupported:
            notificationsSupported ?? this.notificationsSupported,
        odometer: odometer ?? this.odometer,
        parsedCalendarSupported:
            parsedCalendarSupported ?? this.parsedCalendarSupported,
        pf: pf ?? this.pf,
        pr: pr ?? this.pr,
        rdWindow: rdWindow ?? this.rdWindow,
        remoteStart: remoteStart ?? this.remoteStart,
        remoteStartEnabled: remoteStartEnabled ?? this.remoteStartEnabled,
        remoteStartSupported: remoteStartSupported ?? this.remoteStartSupported,
        rpWindow: rpWindow ?? this.rpWindow,
        rt: rt ?? this.rt,
        sentryMode: sentryMode ?? this.sentryMode,
        sentryModeAvailable: sentryModeAvailable ?? this.sentryModeAvailable,
        smartSummonAvailable: smartSummonAvailable ?? this.smartSummonAvailable,
        softwareUpdate: softwareUpdate ?? this.softwareUpdate,
        speedLimitMode: speedLimitMode ?? this.speedLimitMode,
        summonStandbyModeEnabled:
            summonStandbyModeEnabled ?? this.summonStandbyModeEnabled,
        sunRoofPercentOpen: sunRoofPercentOpen ?? this.sunRoofPercentOpen,
        sunRoofState: sunRoofState ?? this.sunRoofState,
        timestamp: timestamp ?? this.timestamp,
        valetMode: valetMode ?? this.valetMode,
        valetPinNeeded: valetPinNeeded ?? this.valetPinNeeded,
        vehicleName: vehicleName ?? this.vehicleName,
      );

  factory VehicleState.fromJson(Map<String, dynamic> json) => VehicleState(
        apiVersion: json["api_version"],
        autoparkStateV2: json["autopark_state_v2"],
        autoparkStyle: json["autopark_style"],
        calendarSupported: json["calendar_supported"],
        carVersion: json["car_version"],
        centerDisplayState: json["center_display_state"],
        df: json["df"],
        dr: json["dr"],
        fdWindow: json["fd_window"],
        fpWindow: json["fp_window"],
        ft: json["ft"],
        homelinkDeviceCount: json["homelink_device_count"],
        homelinkNearby: json["homelink_nearby"],
        isUserPresent: json["is_user_present"],
        lastAutoparkError: json["last_autopark_error"],
        locked: json["locked"],
        mediaState: MediaState.fromJson(json["media_state"]),
        notificationsSupported: json["notifications_supported"],
        odometer: json["odometer"].toDouble(),
        parsedCalendarSupported: json["parsed_calendar_supported"],
        pf: json["pf"],
        pr: json["pr"],
        rdWindow: json["rd_window"],
        remoteStart: json["remote_start"],
        remoteStartEnabled: json["remote_start_enabled"],
        remoteStartSupported: json["remote_start_supported"],
        rpWindow: json["rp_window"],
        rt: json["rt"],
        sentryMode: json["sentry_mode"],
        sentryModeAvailable: json["sentry_mode_available"],
        smartSummonAvailable: json["smart_summon_available"],
        softwareUpdate: SoftwareUpdate.fromJson(json["software_update"]),
        speedLimitMode: SpeedLimitMode.fromJson(json["speed_limit_mode"]),
        summonStandbyModeEnabled: json["summon_standby_mode_enabled"],
        sunRoofPercentOpen: json["sun_roof_percent_open"],
        sunRoofState: json["sun_roof_state"],
        timestamp: json["timestamp"],
        valetMode: json["valet_mode"],
        valetPinNeeded: json["valet_pin_needed"],
        vehicleName: json["vehicle_name"],
      );

  Map<String, dynamic> toJson() => {
        "api_version": apiVersion,
        "autopark_state_v2": autoparkStateV2,
        "autopark_style": autoparkStyle,
        "calendar_supported": calendarSupported,
        "car_version": carVersion,
        "center_display_state": centerDisplayState,
        "df": df,
        "dr": dr,
        "fd_window": fdWindow,
        "fp_window": fpWindow,
        "ft": ft,
        "homelink_device_count": homelinkDeviceCount,
        "homelink_nearby": homelinkNearby,
        "is_user_present": isUserPresent,
        "last_autopark_error": lastAutoparkError,
        "locked": locked,
        "media_state": mediaState.toJson(),
        "notifications_supported": notificationsSupported,
        "odometer": odometer,
        "parsed_calendar_supported": parsedCalendarSupported,
        "pf": pf,
        "pr": pr,
        "rd_window": rdWindow,
        "remote_start": remoteStart,
        "remote_start_enabled": remoteStartEnabled,
        "remote_start_supported": remoteStartSupported,
        "rp_window": rpWindow,
        "rt": rt,
        "sentry_mode": sentryMode,
        "sentry_mode_available": sentryModeAvailable,
        "smart_summon_available": smartSummonAvailable,
        "software_update": softwareUpdate.toJson(),
        "speed_limit_mode": speedLimitMode.toJson(),
        "summon_standby_mode_enabled": summonStandbyModeEnabled,
        "sun_roof_percent_open": sunRoofPercentOpen,
        "sun_roof_state": sunRoofState,
        "timestamp": timestamp,
        "valet_mode": valetMode,
        "valet_pin_needed": valetPinNeeded,
        "vehicle_name": vehicleName,
      };
}

class MediaState {
  bool remoteControlEnabled;

  MediaState({
    this.remoteControlEnabled,
  });

  MediaState copyWith({
    bool remoteControlEnabled,
  }) =>
      MediaState(
        remoteControlEnabled: remoteControlEnabled ?? this.remoteControlEnabled,
      );

  factory MediaState.fromJson(Map<String, dynamic> json) => MediaState(
        remoteControlEnabled: json["remote_control_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "remote_control_enabled": remoteControlEnabled,
      };
}

class SoftwareUpdate {
  int downloadPerc;
  int expectedDurationSec;
  int installPerc;
  int scheduledTimeMs;
  String status;
  String version;

  SoftwareUpdate({
    this.downloadPerc,
    this.expectedDurationSec,
    this.installPerc,
    this.scheduledTimeMs,
    this.status,
    this.version,
  });

  SoftwareUpdate copyWith({
    int downloadPerc,
    int expectedDurationSec,
    int installPerc,
    int scheduledTimeMs,
    String status,
    String version,
  }) =>
      SoftwareUpdate(
        downloadPerc: downloadPerc ?? this.downloadPerc,
        expectedDurationSec: expectedDurationSec ?? this.expectedDurationSec,
        installPerc: installPerc ?? this.installPerc,
        scheduledTimeMs: scheduledTimeMs ?? this.scheduledTimeMs,
        status: status ?? this.status,
        version: version ?? this.version,
      );

  factory SoftwareUpdate.fromJson(Map<String, dynamic> json) => SoftwareUpdate(
        downloadPerc: json["download_perc"],
        expectedDurationSec: json["expected_duration_sec"],
        installPerc: json["install_perc"],
        scheduledTimeMs: json["scheduled_time_ms"],
        status: json["status"],
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "download_perc": downloadPerc,
        "expected_duration_sec": expectedDurationSec,
        "install_perc": installPerc,
        "scheduled_time_ms": scheduledTimeMs,
        "status": status,
        "version": version,
      };
}

class SpeedLimitMode {
  bool active;
  double currentLimitMph;
  int maxLimitMph;
  int minLimitMph;
  bool pinCodeSet;

  SpeedLimitMode({
    this.active,
    this.currentLimitMph,
    this.maxLimitMph,
    this.minLimitMph,
    this.pinCodeSet,
  });

  SpeedLimitMode copyWith({
    bool active,
    double currentLimitMph,
    int maxLimitMph,
    int minLimitMph,
    bool pinCodeSet,
  }) =>
      SpeedLimitMode(
        active: active ?? this.active,
        currentLimitMph: currentLimitMph ?? this.currentLimitMph,
        maxLimitMph: maxLimitMph ?? this.maxLimitMph,
        minLimitMph: minLimitMph ?? this.minLimitMph,
        pinCodeSet: pinCodeSet ?? this.pinCodeSet,
      );

  factory SpeedLimitMode.fromJson(Map<String, dynamic> json) => SpeedLimitMode(
        active: json["active"],
        currentLimitMph: json["current_limit_mph"],
        maxLimitMph: json["max_limit_mph"],
        minLimitMph: json["min_limit_mph"],
        pinCodeSet: json["pin_code_set"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "current_limit_mph": currentLimitMph,
        "max_limit_mph": maxLimitMph,
        "min_limit_mph": minLimitMph,
        "pin_code_set": pinCodeSet,
      };
}
