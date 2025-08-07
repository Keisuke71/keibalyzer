import 'package:flutter/material.dart';

class ShushiInputPage extends StatefulWidget {
  const ShushiInputPage({super.key});

  @override
  State<ShushiInputPage> createState() => _ShushiInputPageState();
}

class _ShushiInputPageState extends State<ShushiInputPage> {
  // 各入力値を保存するための変数
  DateTime? _selectedDate;
  String? _selectedKeibajo;
  String? _selectedRaceNumber;
  String? _selectedBakenType;

  // テキスト入力欄を管理するためのコントローラー
  final TextEditingController _babanController = TextEditingController();
  final TextEditingController _bameiController = TextEditingController();
  final TextEditingController _kakekinController = TextEditingController();
  final TextEditingController _haraimodoshiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('収支入力 - Keibalyzer'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 日付選択 ---
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _selectedDate == null
                    ? '日付を選択'
                    : "${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}",
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
            const Divider(),

            // --- 競馬場選択 (ドロップダウン) ---
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: '競馬場',
                icon: Icon(Icons.location_on),
              ),
              value: _selectedKeibajo,
              items: ['園田', '阪神', '東京', '京都', '中山', 'その他']
                  .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKeibajo = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // --- レース番号入力 ---
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'レース番号 (例: 11R)',
                icon: Icon(Icons.looks_one),
              ),
              onChanged: (value) {
                _selectedRaceNumber = value;
              },
            ),
            const SizedBox(height: 16),

            // --- 馬券の種類 (ドロップダウン) ---
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: '馬券の種類',
                icon: Icon(Icons.receipt_long),
              ),
              value: _selectedBakenType,
              items: ['単勝', '複勝', '馬連', '馬単', '枠連', 'ワイド', '三連複', '三連単']
                  .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBakenType = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // --- 馬番・馬名・金額入力 ---
            TextFormField(
              controller: _babanController,
              decoration: const InputDecoration(labelText: '馬番 (例: 5, 1-7)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bameiController,
              decoration: const InputDecoration(labelText: '馬名 (任意)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kakekinController,
              decoration: const InputDecoration(labelText: '賭けた金額 (円)', prefixText: '¥ '),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _haraimodoshiController,
              decoration: const InputDecoration(labelText: '払戻金 (円)', prefixText: '¥ '),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            // --- 保存ボタン ---
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('保存する'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  // TODO: ここに保存処理と収支計算処理を書く
                  final kakekin = int.tryParse(_kakekinController.text) ?? 0;
                  final haraimodoshi = int.tryParse(_haraimodoshiController.text) ?? 0;
                  final shushi = haraimodoshi - kakekin;

                  // 計算結果をダイアログで表示
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('収支計算結果'),
                        content: Text(
                          'このレースの収支は ¥$shushi です。',
                          style: TextStyle(
                            color: shushi >= 0 ? Colors.green : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}