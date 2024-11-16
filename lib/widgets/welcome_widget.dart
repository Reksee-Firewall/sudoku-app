import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class WelcomeWidget extends StatefulWidget {
  final Function(String) onNameChanged;
  final Function(Level) onDifficultyChanged;
  final Function() onStartGame;

  const WelcomeWidget({
    super.key,
    required this.onNameChanged,
    required this.onDifficultyChanged,
    required this.onStartGame,
  });

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  String playerName = '';
  Level selectedDifficulty = Level.expert;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Bem-vindo ao Sudoku!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
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
          const Text(
            'Selecione a dificuldade:',
            style: TextStyle(fontSize: 16),
          ),
          ExpansionTile(
            title: Text(
              selectedDifficulty.toString().split('.').last,
              style: const TextStyle(fontSize: 16),
            ),
            children: Level.values.map((Level level) {
              return RadioListTile<Level>(
                title: Text(level.toString().split('.').last),
                value: level,
                groupValue: selectedDifficulty,
                onChanged: (Level? value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                  widget.onDifficultyChanged(value!);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (playerName.isNotEmpty) {
                widget.onStartGame();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, insira seu nome!')),
                );
              }
            },
            child: const Text('Iniciar Jogo'),
          ),
        ],
      ),
    );
  }
}
