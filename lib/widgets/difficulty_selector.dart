import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class DifficultySelector extends StatelessWidget {
  final Level selectedDifficulty;
  final Function(Level) onDifficultyChanged;

  DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
  });

  final Map<Level, String> difficultyTranslations = {
    Level.easy: "Fácil",
    Level.medium: "Médio",
    Level.hard: "Difícil",
    Level.expert: "Mestre",
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              const Icon(Icons.settings, color: Colors.blue),
              const SizedBox(width: 8),
              const Text(
                "Nível:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                difficultyTranslations[selectedDifficulty] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.all(10),
          children: Level.values.map((Level level) {
            return RadioListTile<Level>(
              title: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 18,
                    color:
                        level == selectedDifficulty ? Colors.blue : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    difficultyTranslations[level] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: level == selectedDifficulty
                          ? Colors.blue
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
              value: level,
              groupValue: selectedDifficulty,
              onChanged: (Level? value) {
                if (value != null) {
                  onDifficultyChanged(value);
                }
              },
              tileColor: level == selectedDifficulty
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.transparent,
              activeColor: Colors.blue,
              dense: true,
            );
          }).toList(),
        ),
      ),
    );
  }
}
