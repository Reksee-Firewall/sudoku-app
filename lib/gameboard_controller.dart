import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'dart:async';
import 'package:collection/collection.dart';

class GameController extends ChangeNotifier {
  List<int> initialPuzzle = List.filled(81, -1);
  List<int> puzzle = List.filled(81, -1);
  String playerName = '';

  // Estado do jogo
  bool gameStarted = false;
  bool gameFinished = false;
  bool gameWon = false;

  bool _isLoading = false;
  int lives = 3;
  Level selectedDifficulty = Level.expert;

  late Sudoku sudoku;

  Timer? _timer;
  int _elapsedTime = 0;
  int? selectedNumber;

  bool get isLoading => _isLoading;
  int get elapsedTime => _elapsedTime;
  List<int> get gamePuzzle => puzzle;

  List<int?> invalidMoveIndexList = <int>[];

  void setPlayerName(String name) {
    playerName = name;
    notifyListeners();
  }

  void setDifficulty(Level difficulty) {
    selectedDifficulty = difficulty;
    notifyListeners();
  }

  void startGame() async {
    _generateSudoku();
  }

  bool isPuzzleSolved() {
    return const ListEquality().equals(puzzle, sudoku.solution);
  }

  void _generateSudoku() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 2));

    sudoku = Sudoku.generate(selectedDifficulty);

    initialPuzzle = List.from(sudoku.puzzle);
    puzzle = List.from(initialPuzzle);

    gameStarted = true;
    _isLoading = false;

    startTimer();
    notifyListeners();
  }

  void startTimer() {
    _elapsedTime = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (gameFinished) {
        timer.cancel();
      } else {
        _elapsedTime++;
        notifyListeners();
      }
    });
  }

  void resetGame() {
    initialPuzzle = List.filled(81, -1);
    puzzle = List.filled(81, -1);
    invalidMoveIndexList = [];
    playerName = '';
    gameWon = false;
    gameStarted = false;
    gameFinished = false;
    _elapsedTime = 0;
    lives = 3;
    _timer?.cancel();
    notifyListeners();
  }

  void clearSelection() {
    selectedNumber = null;
    notifyListeners();
  }

  void finalizeGame() {
    _timer?.cancel();
    gameFinished = true;
    gameWon = isPuzzleSolved();
    notifyListeners();
  }

  void toggleSelectedNumber(int number) {
    if (selectedNumber == number) {
      selectedNumber = null;
    } else {
      selectedNumber = number;
    }
    notifyListeners();
  }

  void loseLife() {
    if (lives > 0) {
      lives--;
      notifyListeners();
    }
  }

  bool hasLivesLeft() {
    return lives > 0;
  }

  bool isMoveValid(int cellIndex, int number) {
    int row = cellIndex ~/ 9;
    int col = cellIndex % 9;

    // Verifica a linha
    for (int i = 0; i < 9; i++) {
      if (puzzle[row * 9 + i] == number && (row * 9 + i) != cellIndex) {
        return false;
      }
    }

    // Verifica a coluna
    for (int i = 0; i < 9; i++) {
      if (puzzle[i * 9 + col] == number && (i * 9 + col) != cellIndex) {
        return false;
      }
    }

    // Verifica o subgrupo 3x3
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        int index = (startRow + i) * 9 + (startCol + j);
        if (puzzle[index] == number && index != cellIndex) {
          return false;
        }
      }
    }

    return true;
  }

  void updateCell(int cellIndex) {
    if (initialPuzzle[cellIndex] == -1) {
      if (selectedNumber != null) {
        // Atualiza a célula com o número selecionado pelo jogador.
        puzzle[cellIndex] = selectedNumber!;
        selectedNumber = null;
        if (!isMoveValid(cellIndex, puzzle[cellIndex])) {
          if (!invalidMoveIndexList.contains(cellIndex)) {
            invalidMoveIndexList.add(cellIndex);
          }
          if (hasLivesLeft()) {
            loseLife();
          } else {
            finalizeGame();
          }
        } else {
          invalidMoveIndexList.remove(cellIndex);
        }
        notifyListeners();
      } else if (puzzle[cellIndex] != -1) {
        // Se nenhum número foi selecionado, limpa a célula.
        puzzle[cellIndex] = -1;

        // Remove o índice da lista de inválidos, caso ele tenha sido corrigido.
        invalidMoveIndexList.remove(cellIndex);
        notifyListeners();
      }
    }
  }
}
