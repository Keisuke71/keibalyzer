import 'package:flutter/material.dart';
import 'package:keibalyzer/shushi_input_page.dart'; // 作成するファイルをインポート
import 'package:keibalyzer/home_page.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // デスクトップ環境の場合、データベースの初期設定を行う
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

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
      home: const HomePage(), // 最初に表示する画面として指定
    );
  }
}
