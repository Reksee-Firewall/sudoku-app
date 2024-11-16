import 'package:flutter/material.dart';

class SudokuGrid extends StatefulWidget {
  final List<int> initialPuzzle;
  final List<int> puzzle;
  final List<int?> invalidNumberIndex;
  final Function(int) onCellTap;

  const SudokuGrid({
    super.key,
    required this.initialPuzzle,
    required this.puzzle,
    required this.invalidNumberIndex,
    required this.onCellTap,
  });

  @override
  SudokuGridState createState() => SudokuGridState();
}

class SudokuGridState extends State<SudokuGrid> {
  int? selectedCellIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: 81,
        itemBuilder: (context, index) {
          int row = index ~/ 9;
          int col = index % 9;

          bool isInSelectedSquare = false;
          if (selectedCellIndex != null) {
            int selectedRow = selectedCellIndex! ~/ 9;
            int selectedCol = selectedCellIndex! % 9;

            int selectedSquareRowStart = selectedRow ~/ 3 * 3;
            int selectedSquareColStart = selectedCol ~/ 3 * 3;
            isInSelectedSquare = row >= selectedSquareRowStart &&
                row < selectedSquareRowStart + 3 &&
                col >= selectedSquareColStart &&
                col < selectedSquareColStart + 3;
          }

          final isInitializedCell = widget.initialPuzzle[index] != -1;
          final isSelectedRowOrCol = selectedCellIndex != null &&
              (row == selectedCellIndex! ~/ 9 || col == selectedCellIndex! % 9);
          final isSelectedCell = selectedCellIndex == index;

          final border = Border(
            top: BorderSide(
              width: row % 3 == 0 ? 2 : 0.5,
              color: row % 3 == 0 ? Colors.black : Colors.grey,
            ),
            left: BorderSide(
              width: col % 3 == 0 ? 2 : 0.5,
              color: col % 3 == 0 ? Colors.black : Colors.grey,
            ),
            right: BorderSide(
              width: (col == 8) ? 2 : 0.5,
              color: (col == 8) ? Colors.black : Colors.grey,
            ),
            bottom: BorderSide(
              width: (row == 8) ? 2 : 0.5,
              color: (row == 8) ? Colors.black : Colors.grey,
            ),
          );

          return GestureDetector(
            onTap: isInitializedCell
                ? null
                : () {
                    setState(() {
                      selectedCellIndex = index;
                    });
                    widget.onCellTap(index);
                  },
            child: Container(
              decoration: BoxDecoration(
                border: border,
                color: isInitializedCell
                    ? Colors.grey[300]
                    : isSelectedCell
                        ? Colors.cyan.withOpacity(0.40)
                        : isInSelectedSquare
                            ? Colors.cyan.withOpacity(0.2)
                            : isSelectedRowOrCol
                                ? Colors.cyan.withOpacity(0.1)
                                : Colors.white,
              ),
              child: Center(
                child: Text(
                  widget.puzzle[index] == -1
                      ? ''
                      : widget.puzzle[index].toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: (widget.invalidNumberIndex.contains(index))
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
