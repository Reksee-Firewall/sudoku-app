import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class EndGameWidget extends StatefulWidget {
  final bool gameWon;
  final String playerName;
  final Level selectedDifficulty;
  final int elapsedTime;
  final int lives;
  final List<int> finalPuzzle;
  final List<int> solution;
  final void Function() onRetry;

  const EndGameWidget({
    super.key,
    required this.playerName,
    required this.selectedDifficulty,
    required this.elapsedTime,
    required this.lives,
    required this.gameWon,
    required this.finalPuzzle,
    required this.solution,
    required this.onRetry,
  });

  @override
  EndGameWidgetState createState() => EndGameWidgetState();
}

class EndGameWidgetState extends State<EndGameWidget> {
  bool showSolution = false;

  String formatElapsedTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      showSolution = widget.gameWon ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.gameWon ? Colors.green : Colors.red;
    final backgroundColor = widget.gameWon ? Colors.green[50] : Colors.red[50];

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.gameWon ? '🎉 Parabéns! =)' : 'Game Over! =(',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              'Dificuldade',
              widget.selectedDifficulty.toString().split('.').last,
            ),
            _buildInfoRow('Tempo', formatElapsedTime(widget.elapsedTime)),
            _buildInfoRow('Vidas Restantes', widget.lives.toString()),
            _buildInfoRow('Jogador', widget.playerName),
            const SizedBox(height: 10),
            _buildPuzzleComparison(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.gameWon
                    ? const SizedBox.shrink()
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showSolution = !showSolution;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: showSolution
                              ? const Color.fromARGB(255, 78, 78, 78)
                              : Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          showSolution ? 'Ver Jogo Final' : 'Ver Solução',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: widget.onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Reiniciar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleComparison() {
    final puzzleToShow = showSolution ? widget.solution : widget.finalPuzzle;

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: puzzleToShow.length,
      itemBuilder: (context, index) {
        final value = puzzleToShow[index];
        final playerValue = widget.finalPuzzle[index];
        final solutionValue = widget.solution[index];
        final isCorrect = playerValue == solutionValue;

        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.gameWon || isCorrect || showSolution
                ? Colors.green[50]
                : Colors.red[50],
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value == -1 ? '' : value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.gameWon || isCorrect || showSolution
                  ? Colors.black
                  : Colors.red,
            ),
          ),
        );
      },
    );
  }
}
