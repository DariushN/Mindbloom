import 'dart:convert';

import 'package:feather/src/models/internal/geo_position.dart';
import 'package:feather/src/models/internal/unit.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/config/ids.dart';
import 'package:feather/src/utils/date_time_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static final StorageManager _instance = StorageManager._internal();

  StorageManager._internal();

  factory StorageManager() {
    return _instance;
  }

  Future<Unit> getUnit() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      int unit = sharedPreferences.getInt(Ids.storageUnitKey);
      if (unit == null) {
        return Unit.metric;
      } else {
        if (unit == 0) {
          return Unit.metric;
        } else {
          return Unit.imperial;
        }
      }
    } catch (exc, stackTrace) {
      return Unit.metric;
    }
  }

  saveUnit(Unit unit) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      int unitValue = 0;
      if (unit == Unit.metric) {
        unitValue = 0;
      } else {
        unitValue = 1;
      }

      sharedPreferences.setInt(Ids.storageUnitKey, unitValue);
    } catch (exc, stackTrace) {
    }
  }

  void saveRefreshTime(int refreshTime) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();

      sharedPreferences.setInt(Ids.storageRefreshTimeKey, refreshTime);
    } catch (exc, stackTrace) {
    }
  }

  Future<int> getRefreshTime() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      int refreshTime = sharedPreferences.getInt(Ids.storageRefreshTimeKey);
      if (refreshTime == null || refreshTime == 0) {
        refreshTime = 600000;
      }
      return refreshTime;
    } catch (exc, stackTrace) {
      return 600000;
    }
  }

  void saveLastRefreshTime(int lastRefreshTime) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt(Ids.storageLastRefreshTimeKey, lastRefreshTime);
    } catch (exc, stackTrace) {
    }
  }

  Future<int> getLastRefreshTime() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      int lastRefreshTime =
          sharedPreferences.getInt(Ids.storageLastRefreshTimeKey);
      if (lastRefreshTime == null || lastRefreshTime == 0) {
        lastRefreshTime = DateTimeHelper.getCurrentTime();
      }
      return lastRefreshTime;
    } catch (exc, stackTrace) {
      return DateTimeHelper.getCurrentTime();
    }
  }

  saveLocation(GeoPosition geoPosition) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(
          Ids.storageLocationKey, json.encode(geoPosition));
    } catch (exc, stackTrace) {
    }
  }

  Future<GeoPosition> getLocation() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      String jsonData = sharedPreferences.getString(Ids.storageLocationKey);
      if (jsonData != null) {
        return GeoPosition.fromJson(json.decode(jsonData));
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      return null;
    }
  }

  saveWeather(WeatherResponse response) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(Ids.storageWeatherKey, json.encode(response));
    } catch (exc, stackTrace) {
    }
  }

  Future<WeatherResponse> getWeather() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      String jsonData = sharedPreferences.getString(Ids.storageWeatherKey);
      if (jsonData != null) {
        return WeatherResponse.fromJson(jsonDecode(jsonData));
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      return null;
    }
  }
}
