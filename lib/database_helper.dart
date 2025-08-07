import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ShushiRecord {
  final int? id;
  final String date;
  final String keibajo;
  final String raceNumber;
  final String bakenType;
  final String baban;
  final int kakekin;
  final int haraimodoshi;

  ShushiRecord({
    this.id,
    required this.date,
    required this.keibajo,
    required this.raceNumber,
    required this.bakenType,
    required this.baban,
    required this.kakekin,
    required this.haraimodoshi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'keibajo': keibajo,
      'raceNumber': raceNumber,
      'bakenType': bakenType,
      'baban': baban,
      'kakekin': kakekin,
      'haraimodoshi': haraimodoshi,
    };
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shushi.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE shushi_records ( 
  id $idType, 
  date $textType,
  keibajo $textType,
  raceNumber $textType,
  bakenType $textType,
  baban $textType,
  kakekin $intType,
  haraimodoshi $intType
  )
''');
  }

  Future<int> create(ShushiRecord record) async {
    final db = await instance.database;
    return await db.insert('shushi_records', record.toMap());
  }

  Future<List<ShushiRecord>> getRecordsByDate(String date) async {
    final db = await instance.database;
    final maps = await db.query(
      'shushi_records',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'id DESC',
    );

    return List.generate(maps.length, (i) {
      return ShushiRecord(
        id: maps[i]['id'] as int,
        date: maps[i]['date'] as String,
        keibajo: maps[i]['keibajo'] as String,
        raceNumber: maps[i]['raceNumber'] as String,
        bakenType: maps[i]['bakenType'] as String,
        baban: maps[i]['baban'] as String,
        kakekin: maps[i]['kakekin'] as int,
        haraimodoshi: maps[i]['haraimodoshi'] as int,
      );
    });
  }

  // 全てのレコードを取得する
  Future<List<ShushiRecord>> getAllRecords() async {
    final db = await instance.database;
    // 日付の新しい順で並び替える
    final maps = await db.query(
      'shushi_records',
      orderBy: 'date DESC, id DESC',
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return ShushiRecord(
        id: maps[i]['id'] as int,
        date: maps[i]['date'] as String,
        keibajo: maps[i]['keibajo'] as String,
        raceNumber: maps[i]['raceNumber'] as String,
        bakenType: maps[i]['bakenType'] as String,
        baban: maps[i]['baban'] as String,
        kakekin: maps[i]['kakekin'] as int,
        haraimodoshi: maps[i]['haraimodoshi'] as int,
      );
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
