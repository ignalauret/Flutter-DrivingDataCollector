import 'dart:async';

import 'package:camera/camera.dart';
import 'package:driving_data_collector/models/record.dart';
import 'package:driving_data_collector/providers/data_stream.dart';
import 'package:driving_data_collector/providers/file_manager.dart';
import 'package:driving_data_collector/providers/records.dart';
import 'package:driving_data_collector/screens/record/video_summary_screen.dart';
import 'package:driving_data_collector/utils/styles.dart';
import 'package:driving_data_collector/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:provider/provider.dart';

class VideoRecordScreen extends StatefulWidget {
  VideoRecordScreen(this.cameras);
  final List<CameraDescription> cameras;
  static const routeName = "/video-record";
  @override
  _VideoRecordScreenState createState() => _VideoRecordScreenState();
}

class _VideoRecordScreenState extends State<VideoRecordScreen> {
  final fileManager = FileManager();
  CameraController controller;
  StreamSubscription<List<double>> listener;

  int selectedCamera = 0;
  bool isRecording = false;

  String videoPath;
  String dataPath;
  String timeStamp;

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

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      print("Controller no inicializado");
      return null;
    }
    final String extDir = (await syspaths.getExternalStorageDirectory()).path;
    timeStamp = Time.getTimeStamp();
    final String filePath = '$extDir/v$timeStamp.mp4';
    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }
    try {
      videoPath = filePath;
      // Start video recording.
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    // Start accelerations recording.
    listener = DataStream().stream.listen((data) {
      fileManager.addToBuffer(
          "${DateTime.now()},${data[0]},${data[1]},${data[2]},${data[3]},${data[4]}");
    });
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return;
    }
    try {
      await controller.stopVideoRecording();
      await listener.cancel();
      // Save accelerations
      dataPath = 'a$timeStamp.txt';
      fileManager.writeBufferToPath(dataPath);
    } on CameraException catch (e) {
      print(e);
      return;
    }
    final createdId = Provider.of<Records>(context, listen: false)
        .createRecord(RecordType.Video, videoPath, dataPath);
    // Go to summary screen
    Navigator.of(context)
        .pushNamed(VideoSummaryScreen.routeName, arguments: createdId);
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
