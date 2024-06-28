import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronometro-Teban',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerWidget(
              mode: mode,
            );
          },
        );
      },
    );
  }
}

class TimerWidget extends StatefulWidget {
  final WearMode mode;

  const TimerWidget({required this.mode, Key? key}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  late int _currentTime;
  late String _formattedTime;
  late bool _isRunning;

  @override
  void initState() {
    _currentTime = 0;
    _formattedTime = "00:00.00";
    _isRunning = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color activeColor = Colors.green;
    Color ambientColor = Colors.grey[400]!;

    Color displayColor =
        widget.mode == WearMode.active ? activeColor : ambientColor;

    Color textColor =
        widget.mode == WearMode.active ? Colors.white : Colors.grey;

    Color iconCubi = widget.mode == WearMode.active ? Colors.red : Colors.grey;

    return Scaffold(
      backgroundColor:
          widget.mode == WearMode.active ? Colors.black : Colors.grey[800]!,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.timer,
              color: displayColor,
              size: 24.0,
            ),
            const SizedBox(height: 2.0),
            Text(
              "Cronómetro",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: _buildTimeDisplay(displayColor),
            ),
            const SizedBox(height: 10.0),
            _buildControlButtons(displayColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplay(Color displayColor) {
    Color activeColor = Colors.green;
    Color ambientColor = Colors.grey[400]!;

    Color borderColor =
        displayColor == activeColor ? Colors.white : Colors.grey;

    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        _formattedTime,
        style: TextStyle(
          fontSize: 24.0,
          color: displayColor,
          fontFamily: 'Courier',
        ),
      ),
    );
  }

  Widget _buildControlButtons(Color iconColor) {
    Color activeColor = Colors.green;
    Color ambientColor = Colors.grey[400]!;
    Color borderColor =
        widget.mode == WearMode.active ? Colors.white : Colors.grey;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (_isRunning) {
                  _stopTimer();
                } else {
                  _startTimer();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: borderColor, width: 2.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    color: iconColor,
                    size: 22.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 44.0),
            GestureDetector(
              onTap: _resetTimer,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: borderColor, width: 2.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.stop,
                    color: iconColor,
                    size: 22.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _currentTime += 1;
        int minutes = _currentTime ~/ 6000;
        int seconds = (_currentTime ~/ 100) % 60;
        int milliseconds = _currentTime % 100;
        _formattedTime =
            "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}";
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _currentTime = 0;
      _formattedTime = "00:00.00";
      _isRunning = false;
    });
  }
}
