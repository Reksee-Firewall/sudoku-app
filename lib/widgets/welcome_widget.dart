import 'package:flutter/material.dart';
import 'package:sudoku/widgets/difficulty_selector.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class WelcomeWidget extends StatefulWidget {
  final Function(String) onNameChanged;
  final Function(Level) onDifficultyChanged;
  final Function() onStartGame;
  final Function() onViewScoreboard;

  const WelcomeWidget({
    super.key,
    required this.onNameChanged,
    required this.onDifficultyChanged,
    required this.onStartGame,
    required this.onViewScoreboard,
  });

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  String playerName = '';
  Level selectedDifficulty = Level.expert;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/sudoku.png',
                  width: 128,
                  height: 128,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Bem-vindo \nao Sudoku! =)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
            const SizedBox(height: 60),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Digite seu nome',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  playerName = value;
                });
                widget.onNameChanged(value);
              },
            ),
            const SizedBox(height: 20),
            DifficultySelector(
              selectedDifficulty: selectedDifficulty,
              onDifficultyChanged: (Level newDifficulty) {
                setState(() {
                  selectedDifficulty = newDifficulty;
                });
                widget.onDifficultyChanged(newDifficulty);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (playerName.isNotEmpty) {
                  widget.onStartGame();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, insira seu nome!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.2),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Iniciar Jogo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Image.asset(
                    'assets/game-controller.png',
                    width: 32,
                    height: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: widget.onViewScoreboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ver Placar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Image.asset(
                      'assets/ranking.png',
                      width: 32,
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
