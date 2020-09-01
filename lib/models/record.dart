import 'dart:io';

import 'package:flutter/cupertino.dart';

enum RecordType { Video, Voice }

class Record {
  final String id;
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
    return (File(this.mediaPath).lengthSync()/1000000).floor();
  }
}
