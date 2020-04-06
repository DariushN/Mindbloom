import 'dart:collection';
import 'package:feather/src/blocs/application_bloc.dart';
import 'package:feather/src/models/internal/weather_enum.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/resources/config/assets.dart';

class WeatherHelper {
  static String getWeatherIcon(int code) {
    String asset = Assets.iconCloud;
    if (code >= 200 && code <= 299) {
      asset = Assets.iconThunder;
      CurrentWeatherHandler.currentWeather=WeatherEnum.Thunder;
    } else if (code >= 300 && code <= 399) {
      asset = Assets.iconCloudLittleRain;
      CurrentWeatherHandler.currentWeather=WeatherEnum.Rain;
    } else if (code >= 500 && code <= 599) {
      asset = Assets.iconRain;
      CurrentWeatherHandler.currentWeather=WeatherEnum.Rain;
    } else if (code >= 600 && code <= 699) {
      asset = Assets.iconSnow;
      CurrentWeatherHandler.currentWeather=WeatherEnum.Snow;
    } else if (code >= 700 && code <= 799) {
      asset = Assets.iconDust;
      CurrentWeatherHandler.currentWeather=WeatherEnum.Cloud;
    } else if (code == 800) {
      asset = Assets.iconSun;
      CurrentWeatherHandler.currentWeather=WeatherEnum.Sun;
    } else if (code == 801) {
      asset = Assets.iconCloudSun;
      CurrentWeatherHandler.currentWeather=WeatherEnum.Sun;
    } else if (code >= 802) {
      asset = Assets.iconCloud;
      CurrentWeatherHandler.currentWeather=WeatherEnum.Cloud;
    }
    return asset;
  }

  static String _getDayKey(DateTime dateTime) {
    return "${dateTime.day.toString()}-${dateTime.month.toString()}-${dateTime.year.toString()}";
  }

  static String formatTemperature(
      {double temperature,
      int positions = 0,
      round = true,
      metricUnits = true}) {
    var unit = "°C";

    if (!metricUnits) {
      unit = "°F";
    }

    if (round) {
      temperature = temperature.floor().toDouble();
    }

    return "${temperature.toStringAsFixed(positions)} $unit";
  }

  static double convertCelsiusToFahrenheit(double temperature) {
    return 32 + temperature * 1.8;
  }

  static double convertMetersPerSecondToKilometersPerHour(double speed) {
    if (speed != null) {
      return speed * 3.6;
    } else {
      return 0;
    }
  }

  static double convertMetersPerSecondToMilesPerHour(double speed) {
    if (speed != null) {
      return speed * 2.236936292;
    } else {
      return 0;
    }
  }

  static double convertFahrenheitToCelsius(double temperature) {
    return (temperature - 32) * 0.55;
  }

  static String formatPressure(double pressure) {
    String unit = "hPa";
    if (!applicationBloc.isMetricUnits()) {
      unit = "mbar";
    }
    return "${pressure.toStringAsFixed(0)} $unit";
  }

  static String formatRain(double rain) {
    return "${rain.toStringAsFixed(2)} mm/h";
  }

  static String formatWind(double wind) {
    String unit = "km/h";
    if (!applicationBloc.isMetricUnits()) {
      unit = "mi/h";
    }
    return "${wind.toStringAsFixed(1)} $unit";
  }

  static String formatHumidity(double humidity) {
    return "${humidity.toStringAsFixed(0)}%";
  }

  static int getDayMode(System system) {
    int sunrise = system.sunrise * 1000;
    int sunset = system.sunset * 1000;
    return getDayModeFromSunriseSunset(sunrise, sunset);
  }

  static int getDayModeFromSunriseSunset(int sunrise, int sunset) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now >= sunrise && now <= sunset) {
      return 0;
    } else if (now >= sunrise) {
      return 1;
    } else {
      return -1;
    }
  }
}
