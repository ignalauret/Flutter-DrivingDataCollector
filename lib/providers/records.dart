import 'dart:async';

import 'package:path/path.dart';
import 'package:driving_data_collector/models/record.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Records extends ChangeNotifier {
  List<Record> _records = [];

  List<Record> get records {
    return [..._records];
  }

  Future<List<Record>> fetchRecords() async {
    if (_records.isNotEmpty) return _records;
    await open();
    _records = await getRecordsFromDb();
    return _records;
  }

  int createRecord(RecordType type, String mediaPath, String dataPath) {
    final id = _records.length;
    final record = Record(
      id: id,
      date: DateTime.now(),
      type: type,
      mediaPath: mediaPath,
      dataPath: dataPath,
    );
    _records.add(record);
    insert(record);
    notifyListeners();
    return id;
  }

  Record getRecordById(int id) {
    return records.firstWhere(
      (record) => record.id == id,
      orElse: () => null,
    );
  }

  /* Sqflite Database */
  Database db;

  Future open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data_collector.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table records ( 
      id int primary key, 
      type text not null,
      date text not null,
      mediaPath text not null,
      dataPath text not null)
        ''');
    });
  }

  Future<void> insert(Record record) async {
    await db.insert("records", record.toMap());
  }

  Future<Record> getRecordFromDb(int id) async {
    List<Map> maps = await db.query("records",
        columns: ["id", "type", "date", "mediaPath", "dataPath"],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Record.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Record>> getRecordsFromDb() async {
    List<Map> maps = await db.query(
      "records",
      columns: ["id", "type", "date", "mediaPath", "dataPath"],
    );
    if (maps.length > 0) {
      return maps.map((recordMap) => Record.fromMap(recordMap)).toList();
    }
    return [];
  }

  Future<int> delete(int id) async {
    return await db.delete("records", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Record record) async {
    return await db.update("records", record.toMap(),
        where: 'id = ?', whereArgs: [record.id]);
  }

  Future close() async => db.close();
}
