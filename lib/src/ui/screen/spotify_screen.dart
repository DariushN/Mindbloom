import 'dart:typed_data';

import 'package:feather/src/models/internal/mood.dart';
import 'package:feather/src/models/internal/weather_enum.dart';
import 'package:feather/src/ui/widget/size_icon_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:feather/src/models/internal/genre_const_lib.dart' as genre_lib;
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/crossfade_state.dart' as cross;
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';



const cliendID = 'e642985d7aba406b9868328b6d9c22e3';
const redirectURL = 'http://mysite.com/callback/';

class SpotifyScreen extends StatefulWidget {
  Mood mood;
  SpotifyScreen(this.mood);
  @override
  _HomeState createState() => _HomeState(mood);
}

class _HomeState extends State<SpotifyScreen> {
  Mood mood;
  _HomeState(this.mood);
  bool _loading = false;
  cross.CrossfadeState crossfadeState;

  @override
  Widget build(BuildContext context) {
    return _sampleFlowWidget(context);
  }

  Widget _sampleFlowWidget(BuildContext context2) {
    return StreamBuilder<ConnectionStatus>(
      stream: SpotifySdk.subscribeConnectionStatus(),
      builder: (context, snapshot) {
        bool _connected = false;
        if (snapshot.data != null) {
          _connected = snapshot.data.connected;
        }

        return Stack(
          children: [
            ListView(
              padding: EdgeInsets.all(18),
              children: [
                Text("Genre: ${genre_lib.mapMoodWeatherToGenre[mood][CurrentWeatherHandler.currentWeather]['genre']} ", textAlign: TextAlign.center ,style: TextStyle(fontSize: 18)),
                Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.settings_remote, color: Colors.white,),
                        onPressed: () => connectToSpotifyRemote(),
                      ),
                      SizedIconButton(
                        width: 50,
                        icon: Icons.play_circle_filled,
                        onPressed: () => play(),
                      ),
                      FlatButton(
                          child: Icon(Icons.favorite, color: Colors.white,),
                          onPressed: () => addToLibrary()),
                    ],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedIconButton(
                      width: 50,
                      icon: Icons.skip_previous,
                      onPressed: () => skipPrevious(),
                    ),
                    SizedIconButton(
                      width: 50,
                      icon: Icons.play_arrow,
                      onPressed: () => resume(),
                    ),
                    SizedIconButton(
                      width: 50,
                      icon: Icons.pause,
                      onPressed: () => pause(),
                    ),
                    SizedIconButton(
                      width: 50,
                      icon: Icons.skip_next,
                      onPressed: () => skipNext(),
                    ),
                  ],
                ),
                Divider(),
                Divider(),
                _connected
                    ? PlayerStateWidget()
                    : InstructionsWidget(),
              ],
            ),
            _loading
                ? Container(
                color: Colors.black12,
                child: Center(child: CircularProgressIndicator()))
                : SizedBox(),
          ],
        );
      },
    );
  }

  Widget InstructionsWidget() {
    return
      Column(
        children: <Widget>[
          Text('Get started', textAlign: TextAlign.center, style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold),),
          Divider(),
          Row(
            children: <Widget>[
              Icon(Icons.settings_remote, color: Colors.white,),
              Text('   Connect to spotify', textAlign: TextAlign.center, style: TextStyle(fontSize: 24),),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.play_circle_filled, color: Colors.white,),
              Text('   Play generated playlist', textAlign: TextAlign.center, style: TextStyle(fontSize: 24),),
            ],
          ),
        ],
      );
  }

  Widget PlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      initialData: PlayerState(null, false, 1, 1, null, null),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        if (snapshot.data != null && snapshot.data.track != null) {
          var playerState = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  "${playerState.track.name} by ${playerState.track.artist.name}", textAlign: TextAlign.center,),
              Divider(),
              SpotifyImageWidget(playerState.track.imageUri.raw)
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget SpotifyImageWidget(uri) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: ImageUri(
              uri),
          dimension: ImageDimension.x_small,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data);
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: Center(child: Text('Getting image...')),
            );
          }
        });
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: cliendID,
          redirectUrl: redirectURL);
      setStatus(result
          ? "connect to spotify successful"
          : "conntect to spotify failed");
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus("not implemented");
    }
  }


  Future getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  Future getCrossfadeState() async {
    try {
      var crossfadeStateValue = await SpotifySdk.getCrossFadeState();
      setState(() {
        crossfadeState = crossfadeStateValue;
      });
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  Future<void> queue() async {
    try {
      await SpotifySdk.queue(
          spotifyUri: "spotify:track:58kNJana4w5BIjlZE2wq5m");
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri:'spotify:track:58kNJana4w5BIjlZE2wq5m'); //genre_lib.mapMoodWeatherToGenre[mood][CurrentWeatherHandler.currentWeather]['playlistLink']);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }


  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: "spotify:track:58kNJana4w5BIjlZE2wq5m");
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  void setStatus(String code, {String message = ""}) {
    var text = message.isEmpty ? "" : " : $message";
  }
}