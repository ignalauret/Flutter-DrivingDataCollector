import 'dart:io';

import 'package:flutter/cupertino.dart';

enum RecordType { Video, Voice }

class Record {
  final int id;
  final RecordType type;
  final DateTime date;
  final String mediaPath;
  final String dataPath;

  Record({
    @required this.id,
    @required this.type,
    @required this.date,
    @required this.mediaPath,
    @required this.dataPath,
  });

  int get fileSizeInMb {
    return (File(this.mediaPath).lengthSync() / 1000000).floor();
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "type": this.type == RecordType.Video ? "v" : "a",
      "date": date.toIso8601String(),
      "mediaPath": mediaPath,
      "dataPath": dataPath,
    };
    return map;
  }

  Record.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        type = map["type"] == "v" ? RecordType.Video : RecordType.Voice,
        date = DateTime.parse(map["date"]),
        mediaPath = map["mediaPath"],
        dataPath = map["dataPath"];
}
