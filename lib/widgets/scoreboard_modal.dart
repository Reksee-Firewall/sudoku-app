import 'package:flutter/material.dart';
import 'package:sudoku/database_helper.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:intl/intl.dart';

class ScoreboardModal extends StatefulWidget {
  const ScoreboardModal({super.key});

  @override
  State<ScoreboardModal> createState() => _ScoreboardModalState();
}

class _ScoreboardModalState extends State<ScoreboardModal> {
  Level? selectedLevel;
  List<Map<String, dynamic>> scores = [];

  final Map<Level, String> difficultyTranslations = {
    Level.easy: "Fácil",
    Level.medium: "Médio",
    Level.hard: "Difícil",
    Level.expert: "Mestre",
  };

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final data = await DatabaseHelper.instance.getScores();
    setState(() {
      scores = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedScores =
        <String, Map<Level, Map<String, Map<String, dynamic>>>>{};

    for (var score in scores) {
      String name = score['name'];
      Level level = Level.values
          .firstWhere((e) => e.toString().split('.').last == score['level']);

      String date =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(score['date']));

      if (!groupedScores.containsKey(name)) {
        groupedScores[name] = {};
      }

      if (!groupedScores[name]!.containsKey(level)) {
        groupedScores[name]![level] = {};
      }

      if (!groupedScores[name]![level]!.containsKey(date)) {
        groupedScores[name]![level]![date] = {
          'name': name,
          'wins': 0,
          'losses': 0,
          'date': date,
          'level': level,
        };
      }

      if (score['result'] == 1) {
        groupedScores[name]![level]![date]!['wins'] += 1;
      } else if (score['result'] == 0) {
        groupedScores[name]![level]![date]!['losses'] += 1;
      }
    }

    final filteredScores = selectedLevel == null
        ? groupedScores.values
            .expand((e) => e.values)
            .expand((e) => e.values)
            .toList()
        : groupedScores.values
            .expand((e) => e.values)
            .expand((e) => e.values)
            .where((score) => score['level'] == selectedLevel)
            .toList();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      title: Text(
        "Pontuações",
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
      ),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Level>(
                      value: selectedLevel,
                      hint: const Text('Filtrar por Nível'),
                      onChanged: (Level? newValue) {
                        setState(() {
                          selectedLevel = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                      items: Level.values
                          .map<DropdownMenuItem<Level>>((Level level) {
                        return DropdownMenuItem<Level>(
                          value: level,
                          child: Text(
                              level.toString().split('.').last.capitalize()),
                        );
                      }).toList(),
                    ),
                  ),
                  if (selectedLevel != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          selectedLevel = null;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: 16.0,
                      columns: const [
                        DataColumn(
                          label: Text('Jogador',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('V / P',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Data',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Nível',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                      rows: filteredScores.map<DataRow>((score) {
                        int wins = score['wins'];
                        int losses = score['losses'];

                        String formattedDate = DateFormat('dd/MM/yy')
                            .format(DateTime.parse(score['date']));

                        return DataRow(cells: [
                          DataCell(Text(score['name'])),
                          DataCell(Text('$wins / $losses')),
                          DataCell(Text(formattedDate)),
                          DataCell(Text(
                              difficultyTranslations[score['level']] ?? '')),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}

extension StringCapitalization on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
