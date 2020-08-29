import 'dart:io';

import 'package:camera/camera.dart';
import 'package:driving_data_collector/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

class VideoRecordScreen extends StatefulWidget {
  VideoRecordScreen(this.cameras);
  final List<CameraDescription> cameras;
  static const routeName = "/video-record";
  @override
  _VideoRecordScreenState createState() => _VideoRecordScreenState();
}

class _VideoRecordScreenState extends State<VideoRecordScreen> {
  CameraController controller;
  int selectedCamera = 0;

  bool isRecording = false;
  String videoPath;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  Future<void> takePicture() async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final path = "${appDir.path}/${DateTime.now()}";
    await controller.takePicture(path);
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      print("Controller no inicializado");
      return null;
    }

    final String extDir = (await syspaths.getExternalStorageDirectory()).path;
    final String filePath = '$extDir/test_video.mp4';
    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  child: controller.value.isInitialized
                      ? CameraPreview(controller)
                      : Container(
                          color: Colors.black,
                        ),
                ),
                Positioned(
                  bottom: 50,
                  left: (size.width - 100) * 0.5,
                  child: GestureDetector(
                    onTap: () {
                      if (isRecording) {
                        stopVideoRecording();
                        setState(() {
                          isRecording = false;
                        });
                      } else {
                        startVideoRecording();
                        setState(() {
                          isRecording = true;
                        });
                      }
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Styles.kMainColor,
                        borderRadius: BorderRadius.circular(50),
                        border:
                            Border.all(color: Styles.kAccentColor, width: 3),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        isRecording ? Icons.stop : Icons.fiber_manual_record,
                        color: Styles.kAccentColor,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
