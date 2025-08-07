import 'package:flutter/material.dart';
import 'package:keibalyzer/shushi_input_page.dart'; // 作成するファイルをインポート

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keibalyzer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark, // ダークテーマを基調に
      ),
      home: const ShushiInputPage(), // 最初に表示する画面として指定
    );
  }
}