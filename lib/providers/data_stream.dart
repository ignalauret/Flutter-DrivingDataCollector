import 'dart:async';

import 'package:driving_data_collector/utils/constants.dart';
import 'package:location/location.dart';
import 'package:sensors/sensors.dart';

class DataStream {
  DataStream() {
    // Get accelerometer data
    accelerometerEvents.listen((AccelerometerEvent event) {
      accelerometerData = [event.x, event.y, event.z];
    });
    // Get location data
    Location location = Location();
    location.onLocationChanged.listen((LocationData currentLocation) {
      locationData = [currentLocation.latitude, currentLocation.longitude];
    });
    Timer.periodic(
      Duration(milliseconds: (1000 / Constants.sensorDataPerSecond).floor()),
      (timer) {
        // Concat lists
        final data = [...accelerometerData, ...locationData];
        _controller.sink.add(data);
      },
    );
  }

  // ignore: close_sinks
  final _controller = StreamController<List<double>>();
  List<double> accelerometerData = [0.0, 0.0, 0.0];
  List<double> locationData = [0.0, 0.0];

  Stream<List<double>> get stream => _controller.stream;
}
