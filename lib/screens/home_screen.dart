import 'package:driving_data_collector/models/record.dart';
import 'package:driving_data_collector/providers/file_manager.dart';
import 'package:driving_data_collector/providers/records.dart';
import 'package:driving_data_collector/screens/record/record_method_screen.dart';
import 'package:driving_data_collector/utils/styles.dart';
import 'package:driving_data_collector/widgets/records/records_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    fileManager.getStoragePermission().then((granted) {
      if (granted) {
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
      body: FutureBuilder<List<Record>>(
          future: Provider.of<Records>(context).fetchRecords(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
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
                            _buildStatus("Acceso al almacenamiento",
                                storageStatus, storageStatusText),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 20,
                    margin: const EdgeInsets.only(left: 15, top: 30),
                    child: Text(
                      "Mis Grabaciones",
                      style: Styles.kMainTitleStyle,
                    ),
                  ),
                  Expanded(
                    child: RecordsList(snapshot.data),
                  ),
                ],
              ),
            );
          }),
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
