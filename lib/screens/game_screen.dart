import 'package:flutter/material.dart';
import 'package:memo_pattern/screens/result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> _pattern = [];
  int level = 1;
  int _gridSize = 3;
  bool _gameStarted = false;

  @override
  void initState() {
    super.initState();
    _generatePattern();
  }

  void _generatePattern() {
    _pattern = List.generate(3, (index) => index); // Generate random positions
    _gameStarted = true;
    setState(() {});
  }

  void _checkGuess(int index) {
    if (_pattern.contains(index)) {
      // Correct guess
      setState(() {
        _pattern.remove(index);
        if (_pattern.isEmpty) {
          // Proceed to next level
          _nextLevel();
        }
      });
    } else {
      // Game over
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResultScreen(),
        ),
      );
    }
  }

  void _nextLevel() {
    setState(() {
      level++;
      _gridSize++;
      _generatePattern();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Level $level')),
        body: SafeArea(
          child: Stack(
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _gridSize),
                itemCount: _gridSize * _gridSize,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _checkGuess(index),
                    child: Container(
                      margin: const EdgeInsets.all(0.1),
                      decoration: BoxDecoration(
                        gradient: _pattern.contains(index)
                            ? const RadialGradient(
                                colors: [
                                  Color.fromRGBO(29, 88, 102, 1.0),
                                  Color.fromRGBO(13, 39, 45, 1.0)
                                ],
                              )
                            : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(235, 226, 211, 1.0),
                                  Color.fromRGBO(147, 147, 147, 1.0)
                                ],
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
