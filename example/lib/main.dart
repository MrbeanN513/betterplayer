// import 'package:better_player_example/pages/controller_controls_page.dart';
// import 'package:better_player_example/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:better_player/better_player.dart';
import 'package:better_player_example/constants.dart';

import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ControllerControlsPage(),
    );
  }
}

class ControllerControlsPage extends StatefulWidget {
  @override
  _ControllerControlsPageState createState() => _ControllerControlsPageState();
}

class _ControllerControlsPageState extends State<ControllerControlsPage> {
  BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(rotation: 0,
      fullScreenByDefault: true,
      allowedScreenSleep: false,
      autoPlay: true,
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.NETWORK,
        "https://www.dl.dropboxusercontent.com/s/kyn04xlsn9uvt8h/The.Kissing.Booth.2018.720p.NF.WEB-DL.Hindi-English.x264-KatmovieHD.mkv");
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
    var _isporttrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(10);
    final double itemWidth = scaler.getWidth(20);
    final double itemPotraitHeight = scaler.getHeight(5);
    // final double itemPotraitWidth = scaler.getWidth(24);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new OrientationBuilder(builder: (context, orientation) {
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
                    width: itemWidth,
                    color: Colors.transparent,
                    height: orientation == Orientation.landscape
                        ? itemHeight
                        : itemPotraitHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExitDpad(
                            onTap: () {
                              Navigator.of(context).pop(true);
                              setState(() {
                                _betterPlayerController.pause();
                              });
                            },
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExitDpad(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: RaisedButton(
                                color: Colors.transparent,
                                child: Text(
                                  'cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pop(false)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        child: Container(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
        ),
      );
    });
  }
}
