import 'package:driving_data_collector/providers/data_stream.dart';
import 'package:driving_data_collector/providers/file_manager.dart';
import 'package:driving_data_collector/screens/record/record_method_screen.dart';
import 'package:driving_data_collector/utils/styles.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum Status { Loading, Ready, Error }

class _HomeScreenState extends State<HomeScreen> {
  final appBar = AppBar(
    title: Text("Recolector de datos"),
  );
  final fileManager = FileManager();

  Status storageStatus = Status.Loading;
  String storageStatusText = "Cargando...";

  @override
  void initState() {
//    DataStream().stream.listen((data) {
//      fileManager.addToBuffer(
//          "${DateTime.now()},${data[0]},${data[1]},${data[2]},${data[3]},${data[4]}");
//    });
  fileManager.getStoragePermission().then((granted) {
    if(granted) {
      setState(() {
        storageStatus = Status.Ready;
        storageStatusText = "Listo";
      });
    } else {
      setState(() {
        storageStatus = Status.Error;
        storageStatusText = "Permiso denegado";
      });
    }
  });
    super.initState();
  }

  Widget _buildStatusIcon(Status status) {
    switch (status) {
      case Status.Loading:
        return Icon(
          Icons.blur_circular,
          color: Styles.kSecondaryColor,
        );
        break;
      case Status.Ready:
        return Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        );
        break;
      case Status.Error:
        return Icon(
          Icons.error_outline,
          color: Colors.red,
        );
        break;
    }
  }

  Widget _buildStatusText(String text, Status status) {
    switch (status) {
      case Status.Loading:
        return Text(
          text,
          style: TextStyle(
            color: Styles.kSecondaryColor,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        );
        break;
      case Status.Ready:
        return Text(
          text,
          style: TextStyle(
            color: Colors.green,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        );
        break;
      case Status.Error:
        return Text(
          text,
          style: TextStyle(
            color: Colors.red,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        );
        break;
    }
  }

  Widget _buildStatus(String statusName, Status status, String statusMessage) {
    return Row(
      children: [
        _buildStatusIcon(status),
        SizedBox(
          width: 8,
        ),
        Text(
          statusName,
          style: Styles.kBoldTextStyle,
        ),
        Spacer(),
        _buildStatusText(statusMessage, status),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Styles.kBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Container(
                        height: 30,
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Estado",
                          style: Styles.kMainTitleStyle,
                        ),
                      ),
                      _buildStatus("Acceso al almacenamiento", Status.Loading, "Cargando..."),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Text(
                "Mis Grabaciones",
                style: Styles.kMainTitleStyle,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RecordMethodScreen.routeName);
        },
        tooltip: 'Record',
        child: Icon(Icons.add),
        backgroundColor: Styles.kAccentColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
