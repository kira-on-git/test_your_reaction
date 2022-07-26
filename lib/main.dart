import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
//root widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Your Reaction',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = ""; //content of the display with milliseconds (ms-display)
  GameState gameState =
      GameState.readyToStart; //default state of the "START" btn
  Timer? waitingTimer;
  Timer? stoppableTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(children: [
        // 1 text on the top
        const Align(
          alignment: Alignment(0, -0.8), // Д/З#3-6
          child: Text(
            'Test your reaction',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.white),
          ),
        ),
        // 2 ms-display
        Align(
          alignment: Alignment.center,
          child: ColoredBox(
            color: const Color(0xFF6D6D6D),
            child: SizedBox(
              width: 300,
              height: 160,
              child: Center(
                child: Text(
                  millisecondsText,
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),


        Align(
          alignment: const Alignment(0, 0.8),
          child: GestureDetector(
            onTap: ()=> setState(() {
              switch (gameState) {
                case GameState.readyToStart: // "START" 0xFF40CA88
                  gameState = GameState.waiting; // btn name "WAIT"
                  millisecondsText = "";
                  _startWaitingTimer(); //Timer starts
                  break;
                case GameState.waiting: // "WAIT" 0xFFE0982D

                //gameState = GameState.canBeStopped; // btn name "STOP"
                  break;
                case GameState.canBeStopped: // "STOP" 0xFFE02D47

                  gameState = GameState.readyToStart; // btn name "START"
                  stoppableTimer?.cancel(); //stops the timer
                  break;
              }
            }),
            child: ColoredBox(
              color: Color(_getButtonColor()), // switches btn color
              child: SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: Text(
                    _getButtonText(),
                    //title of the btn, default is GameState.readyToStart="START"
                    style: const TextStyle(
                        fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

// functions to control the timer
  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      // in $randomMilliseconds seconds our state changed to canBeStopped = "STOP"
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer(); //почему это метод стоит именно здесь?
    });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }

// resets the value of the ms-display
  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }

  // color switcher
  int _getButtonColor() {
    switch (gameState) {
      case GameState.readyToStart:
        return 0xFF40CA88;
      case GameState.waiting:
        return 0xFFE0982D;
      case GameState.canBeStopped:
        return 0xFFE02D47;
    }
  }
// btn name switcher
  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "START";
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStopped:
        return "STOP";
    }
  }
}
//btn states stored
enum GameState { readyToStart, waiting, canBeStopped }
