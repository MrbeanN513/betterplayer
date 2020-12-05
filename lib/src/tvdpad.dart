import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

class ButtonPlayDpad extends StatefulWidget {
  const ButtonPlayDpad({
    Key key,
    @required this.onTap,
    this.onFocus,
    this.child,
    this.onLongPress,
  }) : super(key: key);
  final Widget child;
  final Function onTap;
  final Function onFocus;
  final Function onLongPress;
  @override
  _ButtonPlayDpadState createState() => _ButtonPlayDpadState();
}

class _ButtonPlayDpadState extends State<ButtonPlayDpad>
    with SingleTickerProviderStateMixin {
  FocusNode node;
  AnimationController controller;
  Animation<double> animation;
  int focusAlpha = 100;

  Widget image;

  @override
  void initState() {
    node = FocusNode();

    node.addListener(onFocusChange);
    controller = AnimationController(
        duration: const Duration(milliseconds: 10),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (node.hasFocus) {
      controller.forward();
      setState(() => _ami = !_ami);

      if (widget.onFocus != null) {
        widget.onFocus();
      }
    } else {
      controller.reverse();
      setState(() => _ami = false);
    }
  }

  bool _ami = false;

  void onTap() {
    node.requestFocus();
    if (widget.onTap != null) {
      widget.onTap();
    }
  }

  void onLongPress() {
    node.requestFocus();
    if (widget.onLongPress != null) {
      widget.onLongPress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      child: RawMaterialButton(
        splashColor: Colors.transparent,
        hoverColor: Colors.black,
        onLongPress: onLongPress,
        onPressed: onTap,
        focusNode: node,
        focusColor: Colors.transparent,
        focusElevation: 0,
        child: buildCover(context),
      ),
    );
  }

  Widget buildCover(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        height: 120,
        width: 120,
        color: Colors.transparent,
        child: Container(
          decoration: _ami
              ? BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)))
              : BoxDecoration(
                  border: Border.all(width: 0, color: Colors.transparent),
                ),
          child: widget.child,
        ),
      ),
    );
  }
}

//!//!//!//!//!//!
class TrackbarDpad extends StatefulWidget {
  const TrackbarDpad({
    Key key,
    @required this.onTap,
    this.onFocus,
    this.child,
    this.onLongPress,
  }) : super(key: key);
  final Widget child;
  final Function onTap;
  final Function onFocus;
  final Function onLongPress;
  @override
  _TrackbarDpadState createState() => _TrackbarDpadState();
}

class _TrackbarDpadState extends State<TrackbarDpad>
    with SingleTickerProviderStateMixin {
  FocusNode node;
  AnimationController controller;
  Animation<double> animation;
  int focusAlpha = 100;

  Widget image;

  @override
  void initState() {
    node = FocusNode();

    node.addListener(onFocusChange);
    controller = AnimationController(
        duration: const Duration(milliseconds: 10),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (node.hasFocus) {
      controller.forward();
      setState(() => _ami = !_ami);

      if (widget.onFocus != null) {
        widget.onFocus();
      }
    } else {
      controller.reverse();
      setState(() => _ami = false);
    }
  }

  bool _ami = false;

  void onTap() {
    node.requestFocus();
    if (widget.onTap != null) {
      widget.onTap();
    }
  }

  void onLongPress() {
    node.requestFocus();
    if (widget.onLongPress != null) {
      widget.onLongPress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          height: 60,
          width: 170,
          child: RawMaterialButton(
            splashColor: Colors.transparent,
            hoverColor: Colors.black,
            onLongPress: onLongPress,
            onPressed: onTap,
            focusNode: node,
            focusColor: Colors.transparent,
            focusElevation: 0,
            child: buildCover(context),
          ),
        );
      },
    );
  }

  Widget buildCover(BuildContext context) {
    return new OrientationBuilder(builder: (context, orientation) {
      return GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Container(
          height: 60,
          width: 170,
          decoration: _ami
              ? BoxDecoration(
                  border: Border.all(
                    width: 2.5,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)))
              : BoxDecoration(
                  border: Border.all(width: 0, color: Colors.transparent),
                ),
          child: widget.child,
        ),
      );
    });
  }
}

//////////////////////////////////
class ButtomDialougeDpad extends StatefulWidget {
  const ButtomDialougeDpad({
    Key key,
    @required this.onTap,
    this.onFocus,
    this.child,
    this.onLongPress,
  }) : super(key: key);
  final Widget child;
  final Function onTap;
  final Function onFocus;
  final Function onLongPress;
  @override
  _ButtomDialougeDpadState createState() => _ButtomDialougeDpadState();
}

class _ButtomDialougeDpadState extends State<ButtomDialougeDpad>
    with SingleTickerProviderStateMixin {
  FocusNode node;
  AnimationController controller;
  Animation<double> animation;
  int focusAlpha = 100;

  Widget image;

  @override
  void initState() {
    node = FocusNode();

    node.addListener(onFocusChange);
    controller = AnimationController(
        duration: const Duration(milliseconds: 10),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (node.hasFocus) {
      controller.forward();
      setState(() => _ami = !_ami);

      if (widget.onFocus != null) {
        widget.onFocus();
      }
    } else {
      controller.reverse();
      setState(() => _ami = false);
    }
  }

  bool _ami = false;

  void onTap() {
    node.requestFocus();
    if (widget.onTap != null) {
      widget.onTap();
    }
  }

  void onLongPress() {
    node.requestFocus();
    if (widget.onLongPress != null) {
      widget.onLongPress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          height: 60,
          width: 200,
          child: RawMaterialButton(
            splashColor: Colors.transparent,
            hoverColor: Colors.black,
            onLongPress: onLongPress,
            onPressed: onTap,
            focusNode: node,
            focusColor: Colors.transparent,
            focusElevation: 0,
            child: buildCover(context),
          ),
        );
      },
    );
  }

  Widget buildCover(BuildContext context) {
    return new OrientationBuilder(builder: (context, orientation) {
      return GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Container(
          height: 60,
          width: 200,
          decoration: _ami
              ? BoxDecoration(
                  border: Border.all(
                    width: 2.5,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)))
              : BoxDecoration(
                  border: Border.all(width: 0, color: Colors.transparent),
                ),
          child: widget.child,
        ),
      );
    });
  }
}

//!//!//*//*
class ExitDpad extends StatefulWidget {
  const ExitDpad({
    Key key,
    @required this.onTap,
    this.onFocus,
    this.child,
    this.onLongPress,
  }) : super(key: key);
  final Widget child;
  final Function onTap;
  final Function onFocus;
  final Function onLongPress;
  @override
  _ExitDpadState createState() => _ExitDpadState();
}

class _ExitDpadState extends State<ExitDpad>
    with SingleTickerProviderStateMixin {
  FocusNode node;
  AnimationController controller;
  Animation<double> animation;
  int focusAlpha = 100;

  Widget image;

  @override
  void initState() {
    node = FocusNode();

    node.addListener(onFocusChange);
    controller = AnimationController(
        duration: const Duration(milliseconds: 10),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (node.hasFocus) {
      controller.forward();
      setState(() => _ami = !_ami);

      if (widget.onFocus != null) {
        widget.onFocus();
      }
    } else {
      controller.reverse();
      setState(() => _ami = false);
    }
  }

  bool _ami = false;

  void onTap() {
    node.requestFocus();
    if (widget.onTap != null) {
      widget.onTap();
    }
  }

  void onLongPress() {
    node.requestFocus();
    if (widget.onLongPress != null) {
      widget.onLongPress();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _isporttrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(5);
    final double itemWidth = scaler.getWidth(10);

    return new OrientationBuilder(builder: (context, orientation) {
      return Container(
        color: Colors.transparent,
        height: _isporttrait ? 50 : itemHeight,
        width: _isporttrait ? 100 : itemWidth,
        child: RawMaterialButton(
          splashColor: Colors.orange,
          hoverColor: Colors.black,
          onLongPress: onLongPress,
          onPressed: onTap,
          focusNode: node,
          focusColor: Colors.transparent,
          focusElevation: 0,
          child: buildCover(context),
        ),
      );
    });
  }

  Widget buildCover(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(5);
    final double itemWidth = scaler.getWidth(10);
    var _isporttrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return new OrientationBuilder(builder: (context, orientation) {
      return GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Container(
          height: _isporttrait ? 50 : itemHeight,
          width: _isporttrait ? 100 : itemWidth,
          color: Colors.transparent,
          child: Container(
            decoration: _ami
                ? BoxDecoration(
                    border: Border.all(
                      width: 2.5,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)))
                : BoxDecoration(
                    border: Border.all(width: 0, color: Colors.transparent),
                  ),
            child: widget.child,
          ),
        ),
      );
    });
  }
}

//!//!//!
class HomecarroselDpad extends StatefulWidget {
  const HomecarroselDpad({
    Key key,
    @required this.onTap,
    this.onFocus,
    this.child,
    this.onLongPress,
  }) : super(key: key);
  final Widget child;
  final Function onTap;
  final Function onFocus;
  final Function onLongPress;
  @override
  _HomecarroselDpadState createState() => _HomecarroselDpadState();
}

class _HomecarroselDpadState extends State<HomecarroselDpad>
    with SingleTickerProviderStateMixin {
  FocusNode node;
  AnimationController controller;
  Animation<double> animation;
  int focusAlpha = 100;

  Widget image;

  @override
  void initState() {
    node = FocusNode();

    node.addListener(onFocusChange);
    controller = AnimationController(
        duration: const Duration(milliseconds: 10),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (node.hasFocus) {
      controller.forward();
      setState(() => _ami = !_ami);

      if (widget.onFocus != null) {
        widget.onFocus();
      }
    } else {
      controller.reverse();
      setState(() => _ami = false);
    }
  }

  bool _ami = false;

  void onTap() {
    node.requestFocus();
    if (widget.onTap != null) {
      widget.onTap();
    }
  }

  void onLongPress() {
    node.requestFocus();
    if (widget.onLongPress != null) {
      widget.onLongPress();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(40);
    final double itemWidth = scaler.getWidth(100);

    return new OrientationBuilder(builder: (context, orientation) {
      return Container(
        height: itemHeight,
        width: itemWidth,
        child: RawMaterialButton(
          splashColor: Colors.orange,
          hoverColor: Colors.black,
          onLongPress: onLongPress,
          onPressed: onTap,
          focusNode: node,
          focusColor: Colors.transparent,
          focusElevation: 0,
          child: buildCover(context),
        ),
      );
    });
  }

  Widget buildCover(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(40);
    final double itemWidth = scaler.getWidth(100);

    return new OrientationBuilder(builder: (context, orientation) {
      return GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Container(
          height: itemHeight,
          width: itemWidth,
          color: Colors.black,
          child: Container(
            decoration: _ami
                ? BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: Colors.redAccent[700],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)))
                : BoxDecoration(
                    border: Border.all(width: 0, color: Colors.transparent),
                  ),
            child: widget.child,
          ),
        ),
      );
    });
  }
}

//////////////////////////////////////////////////////////////////////////////////////*
class LogoutDpad extends StatefulWidget {
  const LogoutDpad({
    Key key,
    @required this.onTap,
    this.onFocus,
    this.child,
    this.onLongPress,
  }) : super(key: key);
  final Widget child;
  final Function onTap;
  final Function onFocus;
  final Function onLongPress;
  @override
  _LogoutDpadState createState() => _LogoutDpadState();
}

class _LogoutDpadState extends State<LogoutDpad>
    with SingleTickerProviderStateMixin {
  FocusNode node;
  AnimationController controller;
  Animation<double> animation;
  int focusAlpha = 100;

  Widget image;

  @override
  void initState() {
    node = FocusNode();

    node.addListener(onFocusChange);
    controller = AnimationController(
        duration: const Duration(milliseconds: 10),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (node.hasFocus) {
      controller.forward();
      setState(() => _ami = !_ami);

      if (widget.onFocus != null) {
        widget.onFocus();
      }
    } else {
      controller.reverse();
      setState(() => _ami = false);
    }
  }

  bool _ami = false;

  void onTap() {
    node.requestFocus();
    if (widget.onTap != null) {
      widget.onTap();
    }
  }

  void onLongPress() {
    node.requestFocus();
    if (widget.onLongPress != null) {
      widget.onLongPress();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(10);
    final double itemWidth = scaler.getWidth(30);

    return new OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          height: itemHeight,
          width: itemWidth,
          child: RawMaterialButton(
            splashColor: Colors.transparent,
            hoverColor: Colors.black,
            onLongPress: onLongPress,
            onPressed: onTap,
            focusNode: node,
            focusColor: Colors.transparent,
            focusElevation: 0,
            child: buildCover(context),
          ),
        );
      },
    );
  }

  Widget buildCover(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    final double itemHeight = scaler.getHeight(10);
    final double itemWidth = scaler.getWidth(30);

    return new OrientationBuilder(builder: (context, orientation) {
      return GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Container(
          height: itemHeight,
          width: itemWidth,
          decoration: _ami
              ? BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50)))
              : BoxDecoration(
                  border: Border.all(width: 0, color: Colors.transparent),
                ),
          child: widget.child,
        ),
      );
    });
  }
}
