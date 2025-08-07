import 'package:flutter/material.dart';
import 'database_helper.dart';

class RecordListPage extends StatefulWidget {
  const RecordListPage({super.key});

  @override
  State<RecordListPage> createState() => _RecordListPageState();
}

class _RecordListPageState extends State<RecordListPage> {
  late Future<List<ShushiRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = DatabaseHelper.instance.getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('収支記録一覧'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: FutureBuilder<List<ShushiRecord>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('データがありません'));
          }

          final records = snapshot.data!;

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final shushi = record.haraimodoshi - record.kakekin;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text('${record.keibajo} ${record.raceNumber}'),
                  subtitle: Text('${record.date} / ${record.bakenType}'),
                  trailing: Text(
                    '¥$shushi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: shushi >= 0
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
