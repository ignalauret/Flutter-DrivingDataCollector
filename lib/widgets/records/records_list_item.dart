import 'dart:io';

import 'package:driving_data_collector/models/record.dart';
import 'package:driving_data_collector/screens/record/video_summary_screen.dart';
import 'package:driving_data_collector/utils/styles.dart';
import 'package:flutter/material.dart';

class RecordsListItem extends StatelessWidget {
  RecordsListItem(this._record);
  final Record _record;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(VideoSummaryScreen.routeName, arguments: _record.id);
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _record.type == RecordType.Video
                        ? Styles.kAccentColor
                        : Styles.kSecondaryColor,
                  ),
                  child: Icon(
                    _record.type == RecordType.Video
                        ? Icons.videocam
                        : Icons.keyboard_voice,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Grabación ${_record.id}",
                        style: Styles.kBoldTextStyle,
                      ),
                      Text(_record.date.toString()),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  child: IconButton(
                    icon: Icon(Icons.cloud_upload),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Subir grabación",
                            style: Styles.kMainTitleStyle,
                          ),
                          content: Container(
                            height: 300,
                            child: Column(
                              children: [
                                Text("Tamaño: ${_record.fileSizeInMb} MB"),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
