import 'package:camera/camera.dart';
import 'package:driving_data_collector/providers/records.dart';
import 'package:driving_data_collector/screens/home_screen.dart';
import 'package:driving_data_collector/screens/record/record_method_screen.dart';
import 'package:driving_data_collector/screens/record/video_record_screen.dart';
import 'package:driving_data_collector/screens/record/video_summary_screen.dart';
import 'package:driving_data_collector/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Records>(
          create: (context) => Records(),
        )
      ],
      child: MaterialApp(
        title: 'Driving data collector',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Styles.kMainColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        routes: {
          RecordMethodScreen.routeName: (context) => RecordMethodScreen(),
          VideoRecordScreen.routeName: (context) => VideoRecordScreen(cameras),
          VideoSummaryScreen.routeName: (context) => VideoSummaryScreen(),
        },
      ),
    );
  }
}
