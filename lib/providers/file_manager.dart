import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManager {

  String _writeBuffer = "";
  final Permission permission = Permission.storage;

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  void addToBuffer(String line) {
    _writeBuffer += line + "\n";
  }

  void cleanBuffer() {
    _writeBuffer = "";
  }

  Future<bool> getStoragePermission() async {
    final status = await permission.request();
    if(status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> writeBufferToPath(String path) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted) {
      final localPath = await _localPath;
      final file = File("$localPath/$path");
      // Write the file.
      return file.writeAsString(_writeBuffer);
    } else {
      print("Permission Dennied"); //TODO
    }
  }
}