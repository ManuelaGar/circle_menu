import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vector_math/vector_math.dart' show radians;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: RadialMenu(),
        ),
      ),
    );
  }
}

class RadialMenu extends StatefulWidget {
  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: RadialAnimation(controller: controller));
  }
}

class RadialAnimation extends StatefulWidget {
  RadialAnimation({Key key, this.controller})
      : scale = Tween<double>(begin: 1, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        translation = Tween<double>(begin: 0.0, end: 145.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.elasticOut,
          ),
        ),
        rotation = Tween<double>(begin: 0.0, end: 360).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.7),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translation;
  final Animation<double> rotation;

  @override
  _RadialAnimationState createState() => _RadialAnimationState();
}

class _RadialAnimationState extends State<RadialAnimation> {
  String audio = 'Silence';

  _open() {
    widget.controller.forward();
  }

  _close() {
    widget.controller.reverse();
  }

  _buildButton(double angle, {String image}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate((widget.translation.value) * cos(rad),
            (widget.translation.value) * sin(rad)),
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: () {
            _close();
            setState(() {
              audio = image;
            });
          },
          child: Image.asset(
            'images/$image.png',
            scale: 1,
          ),
        ),
        height: 90.0,
        width: 90.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.white54,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(3, 3),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, builder) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomCenter,
              ),
            ),
            Container(
              height: 500.0,
              width: 500.0,
              child: Transform.rotate(
                angle: radians(widget.rotation.value),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    _buildButton(0, image: 'universe'),
                    _buildButton(45, image: 'river'),
                    _buildButton(90, image: 'piano'),
                    _buildButton(135, image: 'bowl'),
                    _buildButton(180, image: 'wave'),
                    _buildButton(225, image: 'bird'),
                    _buildButton(270, image: 'nature'),
                    _buildButton(315, image: 'silence'),
                    Container(
                      color: Colors.white,
                      height: 120,
                      width: 120,
                    ),
                    Transform.scale(
                      scale: widget.scale.value - 1,
                      child: FloatingActionButton(
                        child: Icon(FontAwesomeIcons.timesCircle),
                        onPressed: _close,
                        backgroundColor: Colors.red,
                      ),
                    ),
                    Transform.scale(
                      scale: widget.scale.value,
                      child: FloatingActionButton(
                        child: Icon(Icons.music_note),
                        onPressed: _open,
                        backgroundColor: Color(0xFF008CCE),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
              ),
            ),
            Text('Selected audio: $audio'),
            SizedBox(
              height: 50.0,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
