import 'package:flutter/material.dart';

class Google_alexa extends StatefulWidget {
  const Google_alexa({Key? key}) : super(key: key);

  @override
  _GoogleAlexaPageState createState() => _GoogleAlexaPageState();
}

class _GoogleAlexaPageState extends State<Google_alexa> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alexa'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            width: _isPressed ? 80 : 100,
            height: _isPressed ? 80 : 100,
            decoration: BoxDecoration(
              color: _isPressed ? Colors.grey[300] : Colors.grey[200],
              borderRadius: BorderRadius.circular(_isPressed ? 40 : 50),
            ),
            child: Icon(
              Icons.mic,
              size: _isPressed ? 40 : 50,
              color: _isPressed ? Colors.grey[600] : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
