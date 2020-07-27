import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vector_math/vector_math.dart' show radians;

String audio = 'Silence';

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
          child: ShowSheetButton(),
        ),
      ),
    );
  }
}

class ShowSheetButton extends StatefulWidget {
  @override
  _ShowSheetButtonState createState() => _ShowSheetButtonState();
}

class _ShowSheetButtonState extends State<ShowSheetButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          heroTag: 'btn',
          onPressed: () {
            Navigator.of(context)
                .push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) => RadialMenu()))
                .then((value) {
              setState(() {
                audio = value;
              });
            });
          },
          child: Icon(Icons.music_note),
        ),
        Text('Selected audio: ${audio[0].toUpperCase()}${audio.substring(1)}')
      ],
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: RadialAnimation(controller: controller),
      ),
    );
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
  _open() {
    widget.controller.forward();
  }

  _close() {
    widget.controller.reverse();
    Navigator.pop(context, audio);
  }

  @override
  void initState() {
    super.initState();
    _open();
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
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
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
              flex: 1,
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
                    Transform.scale(
                      scale: widget.scale.value,
                      child: FloatingActionButton(
                        heroTag: 'btn1',
                        child: Icon(Icons.music_note),
                        onPressed: _open,
                        backgroundColor: Color(0xFF008CCE),
                      ),
                    ),
                    Transform.scale(
                      scale: widget.scale.value - 1,
                      child: FloatingActionButton(
                        heroTag: 'btn2',
                        child: Icon(FontAwesomeIcons.timesCircle),
                        onPressed: _close,
                        backgroundColor: Colors.red,
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
            Text(
              'Selected audio: ${audio[0].toUpperCase()}${audio.substring(1)}',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 50.0,
            ),
            /*GestureDetector(
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
            )*/
          ],
        );
      },
    );
  }
}
