import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GameState _gameState = GameState.readyToStart;
  String millisecondsText = '';
  Timer? _waitingTimer;
  Timer? _stoppableTimer;

  String _getButtonText() => switch (_gameState) {
    GameState.readyToStart => 'START',
    GameState.waiting => 'WAIT',
    GameState.canBeStopped => 'STOP'
  };

  final _buttonColor = <GameState, int>{
    GameState.readyToStart: 0xFF40CA88,
    GameState.waiting: 0xFFE0982D,
    GameState.canBeStopped: 0xFFE02D47
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment(0, -0.8),
            child: Text(
              'Test your \n reaction speed',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900),
            )
          ),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: const Color(0xFF6D6D6D),
              child: SizedBox(
                width: 300,
                height: 108,
                child: Center(
                  child: Text(
                    millisecondsText,
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ),
          Align(
            alignment: const Alignment(0, 0.8),
            child: GestureDetector(
              onTap: () => setState(() {
                switch (_gameState) {
                  case GameState.readyToStart:
                    _gameState = GameState.waiting;
                    millisecondsText = '...';
                    _startWaitingTimer();
                  case GameState.waiting:
                    //actually do nothing
                    break;
                  case GameState.canBeStopped:
                    _gameState = GameState.readyToStart;
                    _stoppableTimer?.cancel();
                }
              }),
              child: ColoredBox(
                color: Color(_buttonColor[_gameState]!),
                child: SizedBox(
                  width: 300,
                  height: 108,
                  child: Center(
                    child: Text(
                      _getButtonText(),
                      style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            )
          ),

        ]
      )
    );
  }

  @override
  void dispose() {
    _waitingTimer?.cancel();
    _stoppableTimer?.cancel();
    super.dispose();
  }

  void _startWaitingTimer() {
    _waitingTimer = Timer(Duration(seconds: Random().nextInt(4) + 1), () {
      setState(() => _gameState = GameState.canBeStopped);
      _startStoppableTimer();
    });
  }
  
  void _startStoppableTimer() {
    _stoppableTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() => millisecondsText = '${(timer.tick * 16)} ms');
    });
  }
  
}

enum GameState { readyToStart, waiting, canBeStopped }