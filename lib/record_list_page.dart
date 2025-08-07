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

  Future<void> _deleteRecord(int id) async {
    await DatabaseHelper.instance.delete(id);
    // 削除が成功したことをユーザーに通知
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('記録を削除しました')));
    // 画面を再読み込みしてリストを更新
    setState(() {
      _recordsFuture = DatabaseHelper.instance.getAllRecords();
    });
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

              // スワイプで削除できるDismissibleウィジェットでラップする
              return Dismissible(
                key: Key(record.id.toString()), // 各項目を一位に特定するためのキー
                direction: DismissDirection.endToStart, // 右から左へのスワイプのみ許可
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                // 削除が確定された時の処理
                onDismissed: (direction) {
                  _deleteRecord(record.id!);
                },
                // 削除する前に確認ダイアログを表示する
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('確認'),
                        content: const Text('この記録を本当に削除しますか？'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              '削除',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text('${record.keibajo} ${record.raceNumber}'),
                    subtitle: Text(
                      '${record.date} / ${record.bakenType} (${record.tensu}点)',
                    ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
