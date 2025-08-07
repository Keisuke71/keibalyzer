import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'shushi_input_page.dart';
import 'record_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _todayShushi = 0;

  @override
  void initState() {
    super.initState();
    _calculateTodayShushi();
  }

  Future<void> _calculateTodayShushi() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final records = await DatabaseHelper.instance.getRecordsByDate(today);
    int totalKakekin = 0;
    int totalHaraimodoshi = 0;
    for (var record in records) {
      totalKakekin += record.kakekin;
      totalHaraimodoshi += record.haraimodoshi;
    }
    setState(() {
      _todayShushi = totalHaraimodoshi - totalKakekin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keibalyzer ホーム'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('本日の収支', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(
              '¥$_todayShushi',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _todayShushi >= 0
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_chart),
              label: const Text('収支を記録する'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ShushiInputPage(),
                  ),
                );
                // 入力画面から戻ってきたら、本日の収支を再計算する
                _calculateTodayShushi();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text('収支記録一覧を見る'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RecordListPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
