import 'package:bloc/bloc.dart';
import 'package:feather/src/models/internal/mood.dart';
import 'package:feather/src/models/internal/weather_enum.dart';

class MoodWeatherEvent{
  MoodWeatherEvent();
}

class MoodChangeEvent extends MoodWeatherEvent{
  Mood mood;
  MoodChangeEvent(this.mood);
}

class WeatherChangeEvent extends MoodWeatherEvent{
  WeatherEnum weather;
  WeatherChangeEvent(this.weather);
}


class MoodWeatherBloc extends Bloc<MoodWeatherEvent, MoodWeatherState> {
  @override
  MoodWeatherState get initialState => MoodWeatherState();

  @override
  Stream<MoodWeatherState> mapEventToState(MoodWeatherEvent event) async* {
      if(event is MoodChangeEvent) {
        yield MoodState(event.mood);
      }else if (event is WeatherChangeEvent){
        yield WeatherState(event.weather);
        }
    }
}

class MoodState extends MoodWeatherState{
  Mood mood;
  MoodState(this.mood);
}

class WeatherState extends MoodWeatherState{
  WeatherEnum weather;
  WeatherState(this.weather);
}
class MoodWeatherState{
  MoodWeatherState();
}