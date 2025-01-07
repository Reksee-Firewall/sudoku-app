import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/widgets/endgame_widget.dart';
import 'package:sudoku/widgets/scoreboard_modal.dart';
import 'package:sudoku/widgets/sudoku_grid.dart';
import 'package:sudoku/widgets/welcome_widget.dart';
import 'gameboard_controller.dart';

class GameboardPage extends StatelessWidget {
  const GameboardPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameController(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 2.0,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 58.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          leading: Consumer<GameController>(
            builder: (context, controller, child) {
              return IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: controller.gameStarted
                      ? Colors.black
                      : Colors.transparent,
                ),
                onPressed: controller.resetGame,
              );
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Consumer<GameController>(
              builder: (context, controller, child) {
                if (controller.gameStarted && !controller.gameFinished) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Jogador: ${controller.playerName}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Nível: ${controller.selectedDifficulty.toString().split('.').last}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Tempo: ${controller.elapsedTime}s',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return Icon(
                                index < controller.lives
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SudokuGrid(
                        initialPuzzle: controller.initialPuzzle,
                        puzzle: controller.gamePuzzle,
                        invalidNumberIndex: controller.invalidMoveIndexList,
                        onCellTap: (index) {
                          controller.updateCell(index);
                        },
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: List.generate(
                              9,
                              (index) {
                                int number = index + 1;
                                return GestureDetector(
                                  onTap: () =>
                                      controller.toggleSelectedNumber(number),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: controller.selectedNumber == number
                                          ? Colors.blue
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$number',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: controller.selectedNumber ==
                                                  number
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: controller.finalizeGame,
                        child: const Text('Finalizar Jogo'),
                      ),
                    ],
                  );
                } else if (controller.isLoading) {
                  return const CircularProgressIndicator();
                } else if (controller.gameStarted && controller.gameFinished) {
                  return EndGameWidget(
                    gameWon: controller.gameWon,
                    playerName: controller.playerName,
                    selectedDifficulty: controller.selectedDifficulty,
                    elapsedTime: controller.elapsedTime,
                    lives: controller.lives,
                    onRetry: controller.resetGame,
                    finalPuzzle: controller.puzzle,
                    solution: controller.sudoku.solution,
                  );
                } else {
                  return WelcomeWidget(
                    onNameChanged: controller.setPlayerName,
                    onDifficultyChanged: controller.setDifficulty,
                    onStartGame: controller.startGame,
                    onViewScoreboard: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ScoreboardModal(),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
