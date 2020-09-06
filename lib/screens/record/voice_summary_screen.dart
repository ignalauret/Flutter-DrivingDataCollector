import 'package:audioplayers/audioplayers.dart';
import 'package:driving_data_collector/models/record.dart';
import 'package:driving_data_collector/providers/records.dart';
import 'package:driving_data_collector/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoiceSummaryScreen extends StatefulWidget {
  static const routeName = "/voice-summary";
  @override
  _VideoSummaryScreenState createState() => _VideoSummaryScreenState();
}

class _VideoSummaryScreenState extends State<VoiceSummaryScreen> {
  Record _record;
  final _audioPlayer = AudioPlayer();

  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      final int id = ModalRoute.of(context).settings.arguments;
      _record = Provider.of<Records>(context).getRecordById(id);
      _audioPlayer.play(_record.mediaPath, isLocal: true);
      _isInitialized = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Grabación ${_record.id}"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName("/"));
          },
        ),
      ),
      body: Center(
        child: Text("Hola"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_isPlaying) {
            _audioPlayer.stop();
            _isPlaying = false;
          } else {
            _audioPlayer.play(_record.mediaPath, isLocal: true);
            _isPlaying = true;
          }
        },
        backgroundColor: Styles.kAccentColor,
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
