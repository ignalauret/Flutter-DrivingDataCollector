import 'package:driving_data_collector/screens/record/video_record_screen.dart';
import 'package:driving_data_collector/utils/styles.dart';
import 'package:driving_data_collector/widgets/action_button.dart';
import 'package:flutter/material.dart';

class RecordMethodScreen extends StatefulWidget {
  static const routeName = "/start-record";
  @override
  _RecordMethodScreenState createState() => _RecordMethodScreenState();
}

class _RecordMethodScreenState extends State<RecordMethodScreen> {
  String selectedMethod = "Video";

  Widget _buildSelectionCard(
      IconData icon, String title, bool selected, Size size) {
    return Container(
      height: size.width * 0.45,
      width: size.width * 0.45,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMethod = title;
          });
        },
        child: Card(
          elevation: selected ? 1 : 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: selected ? Styles.kBackgroundColor : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: size.width * 0.25,
                color: selected ? Styles.kAccentColor : Colors.black,
              ),
              Text(
                title,
                style: TextStyle(
                  color: selected ? Styles.kAccentColor : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar grabación"),
      ),
      body: Column(
        children: [
          Spacer(),
          Container(
            height: 40,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              "Seleccione un método de grabación",
              style: Styles.kMainTitleStyle,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSelectionCard(
                  Icons.photo_camera, "Video", selectedMethod == "Video", size),
              _buildSelectionCard(
                  Icons.keyboard_voice, "Voz", selectedMethod == "Voz", size),
            ],
          ),
          Spacer(),
          ActionButton("Siguiente", () {
            Navigator.of(context).pushNamed(VideoRecordScreen.routeName);
          }),
        ],
      ),
    );
  }
}
