import 'package:better_player/better_player.dart';
import 'package:better_player_example/constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

class ControllerControlsPage extends StatefulWidget {
  @override
  _ControllerControlsPageState createState() => _ControllerControlsPageState();
}

class _ControllerControlsPageState extends State<ControllerControlsPage> {
  BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      fullScreenByDefault: true,
      allowedScreenSleep: false,
      autoPlay: true,
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.NETWORK, Constants.elephantDreamVideoUrl);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    super.initState();
  }

  @override
  void dispose() {
    print("dispose was called");
    _betterPlayerController.pause();
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(10);
    final double itemWidth = scaler.getWidth(40);
    final double itemPotraitHeight = scaler.getHeight(5);
    final double itemPotraitWidth = scaler.getWidth(24);
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      onWillPop: () async => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Colors.black87.withAlpha(150),
                title: Text(
                  'Are you Leaving....?',
                  style: TextStyle(color: Colors.white),
                ),
                content: Container(
                  color: Colors.transparent,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            color: Colors.transparent,
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              setState(() {
                                _betterPlayerController.pause();
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            color: Colors.transparent,
                            child: Text(
                              'cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => Navigator.of(context).pop(false)),
                      ),
                    ],
                  ),
                ),
              )),
      child: MaterialApp(
        color: Colors.black,
        debugShowCheckedModeBanner: false,
        home: Container(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
        ),
      ),
    );
  }
}
