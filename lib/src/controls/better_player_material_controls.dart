import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:better_player/src/controls/better_player_clickable_widget.dart';
import 'package:better_player/src/controls/better_player_controls_configuration.dart';
import 'package:better_player/src/controls/better_player_controls_state.dart';
import 'package:better_player/src/controls/better_player_material_progress_bar.dart';
import 'package:better_player/src/controls/better_player_progress_colors.dart';
import 'package:better_player/src/core/better_player_controller.dart';
import 'package:better_player/src/core/better_player_utils.dart';
import 'package:better_player/src/video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

import 'better_player_clickable_widget.dart';

class BetterPlayerMaterialControls extends StatefulWidget {
  ///Callback used to send information if player bar is hidden or not
  final Function(bool visbility) onControlsVisibilityChanged;

  ///Controls config
  final BetterPlayerControlsConfiguration controlsConfiguration;

  BetterPlayerMaterialControls(
      {Key key, this.onControlsVisibilityChanged, this.controlsConfiguration})
      : assert(onControlsVisibilityChanged != null),
        assert(controlsConfiguration != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BetterPlayerMaterialControlsState();
  }
}

class _BetterPlayerMaterialControlsState
    extends BetterPlayerControlsState<BetterPlayerMaterialControls> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = true;

  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _displayTapped = false;
  bool _wasLoading = false;
  VideoPlayerController _controller;
  BetterPlayerController _betterPlayerController;
  StreamSubscription _controlsVisibilityStreamSubscription;

  BetterPlayerControlsConfiguration get _controlsConfiguration =>
      widget.controlsConfiguration;

  @override
  VideoPlayerValue get latestValue => _latestValue;

  @override
  BetterPlayerController get betterPlayerController => _betterPlayerController;

  @override
  BetterPlayerControlsConfiguration get betterPlayerControlsConfiguration =>
      _controlsConfiguration;

  @override
  Widget build(BuildContext context) {
    var _islandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    _wasLoading = isLoading(_latestValue);
    if (_latestValue?.hasError == true) {
      return _buildErrorWidget();
    }
    return MouseRegion(
      onHover: (_) {
        cancelAndRestartTimer();
      },
      child: GestureDetector(
        onTap: cancelAndRestartTimer,
        onDoubleTap: () {
          cancelAndRestartTimer();
          // _onPlayPause();
        },
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                // _buildTopBar(),

                Expanded(flex: 1, child: Container()),
                Expanded(flex: 1, child: Container()),
                _wasLoading
                    ? Expanded(
                        flex: 5,
                        child: Center(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: _buildLoadingWidget())))
                    : Expanded(flex: 5, child: _buildHitArea()),
                Expanded(flex: 1, child: _buildBottomBar()),
                Expanded(
                  flex: 1,
                  child: _islandScape
                      ? _buildBottombuttonBar()
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    _controller?.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
    _controlsVisibilityStreamSubscription?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = _betterPlayerController;
    _betterPlayerController = BetterPlayerController.of(context);
    _controller = _betterPlayerController.videoPlayerController;
    _latestValue = _controller.value;

    if (_oldController != _betterPlayerController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  Widget _buildErrorWidget() {
    if (_betterPlayerController.errorBuilder != null) {
      return _betterPlayerController.errorBuilder(context,
          _betterPlayerController.videoPlayerController.value.errorDescription);
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              color: _controlsConfiguration.iconsColor,
              size: 55,
            ),
            Card(
              color: Colors.yellow,
              child: Text(
                _betterPlayerController.translations.generalDefaultError + "!!",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
  }

  AnimatedOpacity _buildBottomBar() {
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(20);
    // final double itemWidth = scaler.getWidth(40);
    final double itemPotraitHeight = scaler.getHeight(20);
    // final double itemPotraitWidth = scaler.getWidth(24);
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _controlsConfiguration.controlsHideTime,
      onEnd: _onPlayerHide,
      child: Container(
        height: itemHeight,
        color: Colors.transparent,
        child: Row(
          children: [
            // _controlsConfiguration.enablePlayPause
            //     ? _buildPlayPause(_controller)
            //     : const SizedBox(),

            _betterPlayerController.isLiveStream()
                ? const SizedBox()
                : _controlsConfiguration.enableProgressBar
                    ? _buildProgressBar()
                    : const SizedBox(),
            _controlsConfiguration.enableProgressBar
                ? _buildPosition()
                : const SizedBox(),
            // _controlsConfiguration.enableMute
            //     ? _buildMuteButton(_controller)
            //     : const SizedBox(),
            // _controlsConfiguration.enableFullscreen
            //     ? _buildExpandButton()
            //     : const SizedBox(),
          ],
        ),
      ),
    );
  }

  AnimatedOpacity _buildBottombuttonBar() {
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(1);
    final double itemWidth = scaler.getWidth(100);
    final double itemPotraitHeight = scaler.getHeight(3);
    // final double itemPotraitWidth = scaler.getWidth(100);
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _controlsConfiguration.controlsHideTime,
      onEnd: _onPlayerHide,
      child: Container(
        height: itemHeight,
        width: itemWidth,
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: TrackbarDpad(
                  onTap: _showAudioDialog,
                  child: RaisedButton.icon(
                      disabledColor: Colors.transparent,
                      color: Colors.transparent,
                      onPressed: _showAudioDialog,
                      icon: Icon(Icons.audiotrack, color: Colors.white),
                      label: Text("AudioTracks",
                          style: TextStyle(color: Colors.white))),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: TrackbarDpad(
                  onTap: _showSubtitleDialog,
                  child: RaisedButton.icon(
                      disabledColor: Colors.transparent,
                      color: Colors.transparent,
                      onPressed: _showSubtitleDialog,
                      icon: Icon(Icons.audiotrack, color: Colors.white),
                      label: Text("SubtitlesList",
                          style: TextStyle(color: Colors.white))),
                ),
              ),
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }

  _showAudioDialog() {
    // ScreenScaler scaler = ScreenScaler()..init(context);
    // final double itemHeight = scaler.getHeight(100);
    // final double itemWidth = scaler.getWidth(40);
    // final double itemPotraitHeight = scaler.getHeight(20);
    // final double itemPotraitWidth = scaler.getWidth(24);
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              backgroundColor: Colors.black87.withAlpha(150),
              title: new Text("Audio_Tracks",
                  style: TextStyle(color: Colors.white)),
              content: Container(
                color: Colors.transparent,
                width: 200,
                height: 150,
                child: Column(
                  children: [
                    ButtomDialougeDpad(
                      onTap: () {
                        _betterPlayerController.setAudioTrack("eng");
                      },
                      child: ListTile(
                        onTap: () {
                          _betterPlayerController.setAudioTrack("eng");
                        },
                        tileColor: Colors.black87.withAlpha(150),
                        leading: Icon(Icons.audiotrack, color: Colors.white),
                        title: Text('Default',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    ButtomDialougeDpad(
                      onTap: () {
                        _betterPlayerController.setAudioTrack("hin");
                      },
                      child: ListTile(
                        onTap: () {
                          _betterPlayerController.setAudioTrack("hin");
                        },
                        tileColor: Colors.black87.withAlpha(150),
                        leading: Icon(Icons.audiotrack, color: Colors.white),
                        title: Text('Hindi',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget _buildHitArea() {
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(40);
    // final double itemWidth = scaler.getWidth(40);
    final double itemPotraitHeight = scaler.getHeight(11);
    // final double itemPotraitWidth = scaler.getWidth(24);
    return new OrientationBuilder(builder: (context, orientation) {
      return Container(
        height: orientation == Orientation.landscape
            ? itemHeight
            : itemPotraitHeight,
        color: Colors.transparent,
        child: Center(
          child: AnimatedOpacity(
            opacity: _hideStuff ? 0.0 : 1.0,
            duration: _controlsConfiguration.controlsHideTime,
            child: Stack(
              children: [
                _buildMiddleRow(),
                _buildNextVideoWidget(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMiddleRow() {
    return Row(
      verticalDirection: VerticalDirection.down,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlsConfiguration.enableSkips
            ? _buildSkipButton()
            : const SizedBox(),
        _controlsConfiguration.enablePlayPause
            ? _buildPlayPause(_controller)
            : const SizedBox(),
        // _buildReplayButton(),
        _controlsConfiguration.enableSkips
            ? _buildForwardButton()
            : const SizedBox(),
      ],
    );
  }

  _showSubtitleDialog() {
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(100);
    final double itemWidth = scaler.getWidth(40);
    final double itemPotraitHeight = scaler.getHeight(20);
    final double itemPotraitWidth = scaler.getWidth(24);
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              backgroundColor: Colors.black87.withAlpha(150),
              title:
                  new Text("Sub_List", style: TextStyle(color: Colors.white)),
              content: Container(
                color: Colors.transparent,
                width: 200,
                height: 150,
                child: Column(
                  children: [
                    ButtomDialougeDpad(
                      onTap: () {
                        _betterPlayerController.setSubTrack("eng");
                      },
                      child: ListTile(
                        onTap: () {
                          _betterPlayerController.setSubTrack("eng");
                        },
                        tileColor: Colors.black87.withAlpha(150),
                        leading: Icon(Icons.audiotrack, color: Colors.white),
                        title: Text('Default',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    ButtomDialougeDpad(
                      onTap: () {
                        _betterPlayerController.setSubTrack(null);
                      },
                      child: ListTile(
                        onTap: () {
                          _betterPlayerController.setSubTrack(null);
                        },
                        tileColor: Colors.black87.withAlpha(150),
                        leading: Icon(Icons.audiotrack, color: Colors.white),
                        title: Text('Sub_off',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ButtonPlayDpad(
        onTap: skipBack,
        child: Container(
          color: Colors.transparent,
          width: 120,
          height: 120,
          child: IconButton(
            icon: Icon(
              Icons.replay_30_sharp,
              size: 50,
              color: _controlsConfiguration.iconsColor,
            ),
            onPressed: skipBack,
          ),
        ),
      ),
    );
  }

  Widget _buildForwardButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: ButtonPlayDpad(
        onTap: skipForward,
        child: Container(
          color: Colors.transparent,
          width: 120,
          height: 120,
          child: IconButton(
            splashColor: Colors.white70,
            icon: Icon(
              Icons.forward_30_sharp,
              size: 50,
              color: _controlsConfiguration.iconsColor,
            ),
            onPressed: skipForward,
          ),
        ),
      ),
    );
  }

  Widget _buildNextVideoWidget() {
    return StreamBuilder<int>(
      stream: _betterPlayerController.nextVideoTimeStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return BetterPlayerMaterialClickableWidget(
            onTap: () {
              _betterPlayerController.playNextVideo();
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 4, right: 24),
                decoration: BoxDecoration(
                  color: _controlsConfiguration.controlBarColor,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "${_betterPlayerController.translations.controlsNextVideoIn} ${snapshot.data} ...",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildPlayPause(VideoPlayerController controller) {
    bool isFinished = isVideoFinished(_latestValue);

    return ButtonPlayDpad(
      onTap: _onPlayPause,
      child: Container(
        color: Colors.transparent,
        width: 120,
        height: 120,
        // margin: const EdgeInsets.symmetric(horizontal: 4),
        // padding: const EdgeInsets.symmetric(horizontal: 12),
        child: isFinished
            ? IconButton(
                onPressed: () {
                  if (_latestValue != null && _latestValue.isPlaying) {
                    if (_displayTapped) {
                      setState(() {
                        _hideStuff = true;
                      });
                    } else
                      cancelAndRestartTimer();
                  } else {
                    _onPlayPause();

                    setState(() {
                      _hideStuff = true;
                    });
                  }
                },
                icon: Icon(
                  Icons.replay,
                  size: 120,
                  color: _controlsConfiguration.iconsColor,
                ),
              )
            : Icon(
                controller.value.isPlaying
                    ? _controlsConfiguration.pauseIcon
                    : _controlsConfiguration.playIcon,
                color: _controlsConfiguration.iconsColor,
                size: 120,
              ),
      ),
    );
  }

  Widget _buildPosition() {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;
    final timeleft =
        _latestValue != null ? (duration - position) : Duration.zero;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        // '${BetterPlayerUtils.formatDuration(position)}/${BetterPlayerUtils.formatDuration(duration)}\n'
        '${BetterPlayerUtils.formatDuration(timeleft)}',
        style: TextStyle(
          fontSize: 10,
          color: _controlsConfiguration.textColor,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  void cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<Null> _initialize() async {
    _controller.addListener(_updateState);

    _betterPlayerController.play();
    _updateState();

    if ((_controller.value != null && _controller.value.isPlaying) ||
        _betterPlayerController.autoPlay) {
      _startHideTimer();
    }
    _betterPlayerController.toggleFullScreen();
    if (_controlsConfiguration.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }

    _controlsVisibilityStreamSubscription =
        _betterPlayerController.controlsVisibilityStream.listen((state) {
      setState(() {
        _hideStuff = !state;
      });
      if (!_hideStuff) {
        cancelAndRestartTimer();
      }
    });
  }

  void _onPlayPause() {
    bool isFinished = false;

    if (_latestValue?.position != null && _latestValue?.duration != null) {
      isFinished = _latestValue.position >= _latestValue.duration;
    }

    setState(() {
      if (_controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        _betterPlayerController.pause();
      } else {
        cancelAndRestartTimer();

        if (!_controller.value.initialized) {
        } else {
          if (isFinished) {
            _betterPlayerController.seekTo(Duration(seconds: 0));
          }
          _betterPlayerController.play();
          _betterPlayerController.cancelNextVideoTimer();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    if (this.mounted) {
      if (!this._hideStuff ||
          isVideoFinished(_controller.value) ||
          _wasLoading ||
          isLoading(_controller.value)) {
        setState(() {
          _latestValue = _controller.value;
          if (isVideoFinished(_latestValue)) {
            _hideStuff = false;
          }
        });
      }
    }
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: BetterPlayerMaterialVideoProgressBar(
          _controller,
          _betterPlayerController,
          onDragStart: () {
            _hideTimer?.cancel();
          },
          onDragEnd: () {
            _startHideTimer();
          },
          colors: BetterPlayerProgressColors(
              playedColor: Colors.red,
              handleColor: _controlsConfiguration.progressBarHandleColor,
              bufferedColor: Colors.grey,
              backgroundColor:
                  _controlsConfiguration.progressBarBackgroundColor),
        ),
      ),
    );
  }

  void _onPlayerHide() {
    _betterPlayerController.toggleControlsVisibility(!_hideStuff);
    widget.onControlsVisibilityChanged(!_hideStuff);
  }

  Widget _buildLoadingWidget() {
    return CircularProgressIndicator(
      strokeWidth: 4,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    );
  }
  // Widget _buildTopBar() {
  //   return _controlsConfiguration.enableOverflowMenu
  //       ? AnimatedOpacity(
  //           opacity: _hideStuff ? 0.0 : 1.0,
  //           duration: _controlsConfiguration.controlsHideTime,
  //           onEnd: _onPlayerHide,
  //           child: Container(
  //             height: _controlsConfiguration.controlBarHeight,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 _buildMoreButton(),
  //               ],
  //             ),
  //           ),
  //         )
  //       : const SizedBox();
  // }

  // Widget _buildMoreButton() {
  //   return BetterPlayerMaterialClickableWidget(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8),
  //       child: Icon(
  //         _controlsConfiguration.overflowMenuIcon,
  //         color: _controlsConfiguration.iconsColor,
  //       ),
  //     ),
  //     onTap: () {
  //       onShowMoreClicked();
  //     },
  //   );
  // }

  // Widget _buildLiveWidget() {
  //   return Expanded(
  //     child: Text(
  //       _betterPlayerController.translations.controlsLive,
  //       style: TextStyle(
  //           color: _controlsConfiguration.liveTextColor,
  //           fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }

  // Widget _buildExpandButton() {
  //   return BetterPlayerMaterialClickableWidget(
  //     onTap: _onExpandCollapse,
  //     child: AnimatedOpacity(
  //       opacity: _hideStuff ? 0.0 : 1.0,
  //       duration: _controlsConfiguration.controlsHideTime,
  //       child: Container(
  //         height: _controlsConfiguration.controlBarHeight,
  //         margin: EdgeInsets.only(right: 12.0),
  //         padding: EdgeInsets.symmetric(horizontal: 8.0),
  //         child: Center(
  //           child: Icon(
  //             _betterPlayerController.isFullScreen
  //                 ? Icons.fullscreen_exit
  //                 : Icons.fullscreen,
  //             color: _controlsConfiguration.iconsColor,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildHitAreaClickableButton({Widget icon, Function onClicked}) {
  //   return BetterPlayerMaterialClickableWidget(
  //     child: Align(
  //       alignment: Alignment.center,
  //       child: Container(
  //         decoration: BoxDecoration(
  //           color: Colors.transparent,
  //           borderRadius: BorderRadius.circular(48),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(12),
  //           child: Stack(
  //             children: [icon],
  //           ),
  //         ),
  //       ),
  //     ),
  //     onTap: onClicked,
  //   );
  // }

  // Widget _buildReplayButton() {
  //   bool isFinished = isVideoFinished(_latestValue);
  //   if (!isFinished) {
  //     return const SizedBox();
  //   }

  //   return _buildHitAreaClickableButton(
  //     icon: Icon(
  //       Icons.replay,
  //       size: 32,
  //       color: _controlsConfiguration.iconsColor,
  //     ),
  //     onClicked: () {
  //       if (_latestValue != null && _latestValue.isPlaying) {
  //         if (_displayTapped) {
  //           setState(() {
  //             _hideStuff = true;
  //           });
  //         } else
  //           cancelAndRestartTimer();
  //       } else {
  //         _onPlayPause();

  //         setState(() {
  //           _hideStuff = true;
  //         });
  //       }
  //     },
  //   );
  // }

  // Widget _buildMuteButton(
  //   VideoPlayerController controller,
  // ) {
  //   return BetterPlayerMaterialClickableWidget(
  //     onTap: () {
  //       cancelAndRestartTimer();
  //       if (_latestValue.volume == 0) {
  //         _betterPlayerController.setVolume(_latestVolume ?? 0.5);
  //       } else {
  //         _latestVolume = controller.value.volume;
  //         _betterPlayerController.setVolume(0.0);
  //       }
  //     },
  //     child: AnimatedOpacity(
  //       opacity: _hideStuff ? 0.0 : 1.0,
  //       duration: _controlsConfiguration.controlsHideTime,
  //       child: ClipRect(
  //         child: Container(
  //           child: Container(
  //             height: _controlsConfiguration.controlBarHeight,
  //             padding: EdgeInsets.symmetric(horizontal: 8),
  //             child: Icon(
  //               (_latestValue != null && _latestValue.volume > 0)
  //                   ? _controlsConfiguration.muteIcon
  //                   : _controlsConfiguration.unMuteIcon,
  //               color: _controlsConfiguration.iconsColor,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _onExpandCollapse() {
  //   setState(() {
  //     _hideStuff = true;

  //     _betterPlayerController.toggleFullScreen();
  //     _showAfterExpandCollapseTimer =
  //         Timer(_controlsConfiguration.controlsHideTime, () {
  //       setState(() {
  //         cancelAndRestartTimer();
  //       });
  //     });
  //   });
  // }

}
