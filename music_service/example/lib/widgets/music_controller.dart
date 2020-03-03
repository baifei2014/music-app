import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';

import '../player/player.dart';

class MusicControlBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final MusicPlayerValue playerValue = PlayerStateWidget.of(context);
    final metadata = playerValue.metadata;
    if (playerValue.playbackState.state == PlayerState.None) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _ControllerBar(),
          Text.rich(TextSpan(children: [
            TextSpan(text: 'current metadata:'),
            TextSpan(text: metadata?.title),
          ])),
          Text.rich(TextSpan(children: [
            TextSpan(text: playerValue.queue.queueTitle ?? "" + "\n"),
            TextSpan(text: playerValue.queue.queue.join()),
          ])),
          Text.rich(TextSpan(children: [
            TextSpan(text: "playback state : \n"),
            TextSpan(text: """
speed:  ${playerValue.playbackState.speed} 
bufferedPosition:  ${playerValue.playbackState.bufferedPosition} 
position:  ${playerValue.playbackState.position} 
errorCode:  ${playerValue.playbackState.error} 
updateTime:  ${DateTime.fromMillisecondsSinceEpoch(playerValue.playbackState.updateTime).toIso8601String()} 
          """),
          ])),
        ],
      ),
    );
  }
}

class _ControllerBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: <Widget>[
        RepeatModelButton(),
        IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: () {
              PlayerWidget.transportControls(context).skipToPrevious();
            }),
        PlayPauseButton(),
        IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: () {
              PlayerWidget.transportControls(context).skipToNext();
            }),
      ],
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playbackState = PlayerStateWidget.of(context).playbackState;
    if (playbackState.state == PlayerState.Playing) {
      return IconButton(
          icon: Icon(Icons.pause),
          onPressed: () {
            PlayerWidget.transportControls(context).pause();
          });
    } else if (playbackState.state == PlayerState.Buffering) {
      return Container(
        height: 24,
        width: 24,
        //to fit  IconButton min width 48
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.all(4),
        child: CircularProgressIndicator(),
      );
    } else if (playbackState.state == PlayerState.None) {
      return Container();
    } else {
      return IconButton(
          icon: Icon(Icons.play_arrow),
          tooltip: "play mode",
          onPressed: () {
            PlayerWidget.transportControls(context).play();
          });
    }
  }
}

class RepeatModelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MusicPlayerValue state = PlayerStateWidget.of(context);

    Widget icon;
    if (state.playMode == PlayMode.shuffle) {
      icon = const Icon(Icons.shuffle);
    } else if (state.playMode == PlayMode.single) {
      icon = const Icon(Icons.repeat_one);
    } else {
      icon = const Icon(Icons.repeat);
    }
    return IconButton(
        icon: icon,
        onPressed: () {
          PlayerWidget.transportControls(context).setPlayMode(_getNext(state.playMode));
        });
  }

  static PlayMode _getNext(PlayMode playMode) {
    switch (playMode) {
      case PlayMode.sequence:
        return PlayMode.shuffle;
      case PlayMode.shuffle:
        return PlayMode.single;
      case PlayMode.single:
        return PlayMode.sequence;
    }
    throw "can not reach";
  }
}
