import 'dart:async';

import 'package:camera/camera.dart';
import 'package:driving_data_collector/models/record.dart';
import 'package:driving_data_collector/providers/data_stream.dart';
import 'package:driving_data_collector/providers/file_manager.dart';
import 'package:driving_data_collector/providers/records.dart';
import 'package:driving_data_collector/screens/record/video_summary_screen.dart';
import 'package:driving_data_collector/screens/record/voice_summary_screen.dart';
import 'package:driving_data_collector/utils/styles.dart';
import 'package:driving_data_collector/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:provider/provider.dart';

class VoiceRecordScreen extends StatefulWidget {
  static const routeName = "/voice-record";
  @override
  _VoiceRecordScreenState createState() => _VoiceRecordScreenState();
}

class _VoiceRecordScreenState extends State<VoiceRecordScreen> {
  final fileManager = FileManager();
  FlutterAudioRecorder _recorder;
  Recording _recording;
  StreamSubscription<List<double>> listener;

  bool isRecording = false;

  String audioPath;
  String dataPath;
  String timeStamp;

  Future<String> startVoiceRecording() async {
    final String extDir = (await syspaths.getExternalStorageDirectory()).path;
    timeStamp = Time.getTimeStamp();
    final String filePath = '$extDir/a$timeStamp.mp4';
    _recorder = FlutterAudioRecorder(filePath, audioFormat: AudioFormat.AAC);
    await _recorder.initialized;
    audioPath = filePath;
    // Start audio recording.
    await _recorder.start();
    _recording = await _recorder.current(channel: 0);
    // Start accelerations recording.
    listener = DataStream().stream.listen((data) {
      fileManager.addToBuffer(
          "${DateTime.now()},${data[0]},${data[1]},${data[2]},${data[3]},${data[4]}");
    });
    return filePath;
  }

  Future<void> stopVoiceRecording() async {
    if (_recording.status != RecordingStatus.Recording) {
      return;
    }

    await _recorder.stop();
    await listener.cancel();
    // Save accelerations
    dataPath = 'a$timeStamp.txt';
    fileManager.writeBufferToPath(dataPath);

    final createdId = Provider.of<Records>(context, listen: false)
        .createRecord(RecordType.Voice, audioPath, dataPath);
    // Go to summary screen
    Navigator.of(context)
        .pushNamed(VoiceSummaryScreen.routeName, arguments: createdId);
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
                Positioned(
                  bottom: 50,
                  left: (size.width - 100) * 0.5,
                  child: GestureDetector(
                    onTap: () {
                      if (isRecording) {
                        stopVoiceRecording();
                        setState(() {
                          isRecording = false;
                        });
                      } else {
                        startVoiceRecording();
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
