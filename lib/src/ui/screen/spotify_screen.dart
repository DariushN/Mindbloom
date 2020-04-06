import 'dart:typed_data';

import 'package:feather/src/ui/widget/size_icon_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<SpotifyScreen> {
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
              padding: EdgeInsets.all(8),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.settings_remote),
                      onPressed: () => connectToSpotifyRemote(),
                    ),
                    FlatButton(
                      child: Text("get auth token "),
                      onPressed: () => getAuthenticationToken(),
                    ),
                  ],
                ),
                Divider(),
                Text("Player State", style: TextStyle(fontSize: 16)),
                _connected
                    ? PlayerStateWidget()
                    : Center(
                  child: Text("Not connected"),
                ),
                Divider(),
                Text("Player Context", style: TextStyle(fontSize: 16)),
                _connected
                    ? PlayerContextWidget()
                    : Center(
                  child: Text("Not connected"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedIconButton(
                      width: 50,
                      icon: Icons.queue_music,
                      onPressed: () => queue(),
                    ),
                    SizedIconButton(
                      width: 50,
                      icon: Icons.play_circle_filled,
                      onPressed: () => play(),
                    ),
                    SizedIconButton(
                      width: 50,
                      icon: Icons.repeat,
                      onPressed: () => toggleRepeat(),
                    ),
                    SizedIconButton(
                      width: 50,
                      icon: Icons.shuffle,
                      onPressed: () => toggleShuffle(),
                    ),
                  ],
                ),
                FlatButton(
                    child: Icon(Icons.favorite),
                    onPressed: () => addToLibrary()),
                Row(
                  children: <Widget>[
                    FlatButton(
                        child: Text("seek to"), onPressed: () => seekTo()),
                    FlatButton(
                        child: Text("seek to relative"),
                        onPressed: () => seekToRelative()),
                  ],
                ),
                Divider(),
                Text("Crossfade State", style: TextStyle(fontSize: 16)),
                FlatButton(
                    child: Text("getCrossfadeState"),
                    onPressed: () => getCrossfadeState()),
                Text("Is enabled: ${crossfadeState?.isEnabled}"),
                Text("Duration: ${crossfadeState?.duration}"),
                Divider(),
                _connected
                    ? SpotifyImageWidget()
                    : Text('Connect to see an image...'),
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

  Widget PlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      initialData: PlayerState(null, false, 1, 1, null, null),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        if (snapshot.data != null && snapshot.data.track != null) {
          var playerState = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  "${playerState.track.name} by ${playerState.track.artist.name} from the album ${playerState.track.album.name} "),
              Text("Speed: ${playerState.playbackSpeed}"),
              Text(
                  "Progress: ${playerState.playbackPosition}ms/${playerState.track.duration}ms"),
              Text("IsPaused: ${playerState.isPaused}"),
              Text("Is Shuffling: ${playerState.playbackOptions.isShuffling}"),
              Text("RepeatMode: ${playerState.playbackOptions.repeatMode}"),
              Text("Image URI: ${playerState.track.imageUri.raw}"),
              Text(
                  "Is episode? ${playerState.track.isEpisode}. Is podcast?: ${playerState.track.isPodcast}"),
            ],
          );
        } else {
          return Center(
            child: Text("Not connected"),
          );
        }
      },
    );
  }

  Widget PlayerContextWidget() {
    return StreamBuilder<PlayerContext>(
      stream: SpotifySdk.subscribePlayerContext(),
      initialData: PlayerContext("", "", "", ""),
      builder: (BuildContext context, AsyncSnapshot<PlayerContext> snapshot) {
        if (snapshot.data != null && snapshot.data.uri != "") {
          var playerContext = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Title: ${playerContext.title}"),
              Text("Subtitle: ${playerContext.subtitle}"),
              Text("Type: ${playerContext.type}"),
              Text("Uri: ${playerContext.uri}"),
            ],
          );
        } else {
          return Center(
            child: Text("Not connected"),
          );
        }
      },
    );
  }

  Widget SpotifyImageWidget() {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: ImageUri(
              'spotify:image:ab67616d0000b2736b4f6358fbf795b568e7952d'),
          dimension: ImageDimension.large,
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

  Future<void> getAuthenticationToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAuthenticationToken(
          clientId: "", redirectUrl: "");
      setStatus("Got a token: $authenticationToken");
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
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
      await SpotifySdk.play(spotifyUri: "spotify:track:58kNJana4w5BIjlZE2wq5m");
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

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus("not implemented");
    }
  }

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
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