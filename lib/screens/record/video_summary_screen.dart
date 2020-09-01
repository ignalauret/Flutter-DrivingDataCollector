import 'dart:io';

import 'package:driving_data_collector/models/record.dart';
import 'package:driving_data_collector/providers/records.dart';
import 'package:driving_data_collector/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoSummaryScreen extends StatefulWidget {
  static const routeName = "/video-summary";
  @override
  _VideoSummaryScreenState createState() => _VideoSummaryScreenState();
}

class _VideoSummaryScreenState extends State<VideoSummaryScreen> {
  VideoPlayerController _controller;
  Record _record;

  bool _isInitialized = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      final String id = ModalRoute.of(context).settings.arguments;
      _record = Provider.of<Records>(context).getRecordById(id);
      _controller = VideoPlayerController.file(File(_record.mediaPath))
        ..initialize().then((_) {
          setState(() {});
        });
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
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        backgroundColor: Styles.kAccentColor,
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
