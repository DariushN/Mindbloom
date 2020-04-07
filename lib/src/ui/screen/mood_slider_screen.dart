import 'package:feather/src/blocs/mood_weather_bloc.dart';
import 'package:feather/src/models/internal/mood.dart';
import 'package:feather/src/models/internal/weather_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';



class MoodSliderScreen extends StatefulWidget {
  MoodSliderScreen(this.changeMood);

  final MoodCallback changeMood;

  @override
  MoodSliderState createState() {
    return new MoodSliderState(changeMood);
  }
}

class MoodSliderState extends State<MoodSliderScreen> {
  MoodSliderState(this.changeMood);

  final MoodCallback changeMood;
  var _value = 3.5;
  var currentWeather = WeatherEnum.Cloud;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodWeatherBloc, MoodWeatherState>(
      builder: (context, state) {
        if (state is MoodState) {
          _value = moodToInt(state.mood);
          currentWeather = state.weather;
        }
        if (state is WeatherState) {
          currentWeather = state.weather;
        }
        return Container(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("What's your current mood?",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: Theme.of(context).textTheme.title),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(getIcon(_value),
                      color: Colors.white,
                      size: 70),
                    ),
                    Text(getEmotion(_value),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: Theme.of(context).textTheme.body1),
                SizedBox(
                  height: 100,
                  child: Slider(
                    min: 0,
                    max: 7,
                    value: _value,
                    onChanged: (value) {
                      setState(() {
                        changeMood(getMood(value));
                        _value = value;
                        BlocProvider.of<MoodWeatherBloc>(context).add(MoodChangeEvent(getMood(_value),currentWeather));
                      });
                    },
                  ),
                )
              ]),
            ));
      }
    );
  }
}

Mood getMood(double i) {
  if (0.0 <= i && i < 1.0) {
    return Mood.depressed;
  } else if (1.0 <= i && i < 2.0) {
    return Mood.sad;
  } else if (2.0 <= i && i < 3.0) {
    return Mood.bitter;
  } else if (3.0 <= i && i < 4.0) {
    return Mood.neutral;
  } else if (4.0 <= i && i < 5.0) {
    return Mood.content;
  } else if (5.0 <= i && i < 6.0) {
    return Mood.happy;
  } else if (6.0 <= i && i <= 7.0) {
    return Mood.ecstatic;
  }
  return Mood.depressed;
}

IconData getIcon(double i) {
  if (0.0 <= i && i < 1.0) {
    return FontAwesome5.sad_cry;
  } else if (1.0 <= i && i < 2.0) {
    return FontAwesome5.sad_tear;
  } else if (2.0 <= i && i < 3.0) {
    return FontAwesome5.frown_open;
  } else if (3.0 <= i && i < 4.0) {
    return FontAwesome5.meh;
  } else if (4.0 <= i && i < 5.0) {
    return FontAwesome5.smile;
  } else if (5.0 <= i && i < 6.0) {
    return FontAwesome5.smile_beam;
  } else if (6.0 <= i && i <= 7.0) {
    return FontAwesome5.laugh_beam;
  }
  return FontAwesome5.meh;
}

String getEmotion(double i) {
  if (0.0 <= i && i < 1.0) {
    return 'Depressed';
  } else if (1.0 <= i && i < 2.0) {
    return 'Sad';
  } else if (2.0 <= i && i < 3.0) {
    return 'Bitter';
  } else if (3.0 <= i && i < 4.0) {
    return 'Neutral';
  } else if (4.0 <= i && i < 5.0) {
    return 'Content';
  } else if (5.0 <= i && i < 6.0) {
    return 'Happy';
  } else if (6.0 <= i && i <= 7.0) {
    return 'Ecstatic';
  }
  return 'Neutral';
}

double moodToInt(Mood mood){
  switch(mood){
    case Mood.depressed:
      return 0.5;
      break;
    case Mood.ecstatic:
      return 6.5;
      break;
    case Mood.happy:
      return 5.5;
      break;
    case Mood.content:
      return 4.5;
      break;
    case Mood.neutral:
      return 3.5;
      break;
    case Mood.bitter:
      return 2.5;
      break;
    case Mood.sad:
      return 1.5;
      break;
  }
  return 3.5;
}


typedef MoodCallback = void Function(Mood mood);
