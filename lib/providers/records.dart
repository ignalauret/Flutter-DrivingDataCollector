import 'dart:async';

import 'package:driving_data_collector/models/record.dart';
import 'package:flutter/material.dart';

class Records extends ChangeNotifier {
  final List<Record> _records = [];

  List<Record> get records {
    return [..._records];
  }

  String createRecord(RecordType type, String mediaPath, String dataPath) {
    final id = _records.length.toString();
    final record = Record(
      id: id,
      date: DateTime.now(),
      type: type,
      mediaPath: mediaPath,
      dataPath: dataPath,
    );
    _records.add(record);
    notifyListeners();
    return id;
  }

  Record getRecordById(String id) {
    return records.firstWhere(
      (record) => record.id == id,
      orElse: () => null,
    );
  }
}
