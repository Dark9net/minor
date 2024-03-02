import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:minor/temperature_details.dart';
import 'package:minor/humidity_details.dart';
import 'package:minor/moisture_details.dart';

class GreenHouse extends StatefulWidget {
  const GreenHouse({Key? key}) : super(key: key);

  @override
  _GreenHouseState createState() => _GreenHouseState();
}

class _GreenHouseState extends State<GreenHouse> {
  final String serverAddress = 'https://blynk.cloud/external/api/';
  final String token = 'nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb';
  double temperature = 0;
  double humidity = 0;
  double soil_moisture = 0;
  bool displayingTemperature = false;
  bool humidity_display = false;
  bool moisture_display = false;

  @override
  void initState() {
    super.initState();
    // Start fetching temperature data from Blynk server
    Timer.periodic(Duration(seconds: 5), (timer) {
      fetchTemperature().then((value1) {
        setState(() {
          temperature = value1;
        });
      });
      fetchHumidity().then((value2) {
        setState(() {
          humidity = value2;
        });
      });
      fetchmoisture().then((value3) {
        setState(() {
          soil_moisture = value3;
        });
      });
    });
  }
  //https://blynk.cloud/external/api/get?token=nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb&v5

  Future<double> fetchTemperature() async {
    final response = await http.get(Uri.parse('https://blynk.cloud/external/api/get?token=$token&v6'));
    if (response.statusCode == 200) {
      final temperatureData = response.body;
      final temperature = double.tryParse(temperatureData);
      if (temperature != null) {
        return temperature;
      } else {
        throw Exception('Failed to parse temperature data');
      }
    } else {
      throw Exception('Failed to load temperature data');
    }
  }
  Future<double> fetchHumidity() async {
    final response = await http.get(Uri.parse('https://blynk.cloud/external/api/get?token=$token&v5'));
    if (response.statusCode == 200) {
      final humidityData = response.body;
      final humidity = double.tryParse(humidityData);
      if (humidity != null) {
        return humidity;
      } else {
        throw Exception('Failed to parse humidity data');
      }
    } else {
      throw Exception('Failed to load humidity data');
    }
  }

  Future<double> fetchmoisture() async {
    final response = await http.get(Uri.parse('https://blynk.cloud/external/api/get?token=$token&v7'));
    if (response.statusCode == 200) {
      final moistureData = response.body;
      final soil_moisture = double.tryParse(moistureData);
      if (soil_moisture != null) {
        return soil_moisture;
      } else {
        throw Exception('Failed to parse humidity data');
      }
    } else {
      throw Exception('Failed to load humidity data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Greenhouse Status'),
          backgroundColor: Colors.green, // Set the app bar color here
          // You can customize the title text style if needed
          titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          ),
        ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Center(
              child: Container(
                width: 230, // Adjust the width as needed
                height: 230, // Adjust the height as needed
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: -20,
                      maximum: 80,
                      ranges: <GaugeRange>[
                        GaugeRange(
                          startValue: -20,
                          endValue: -19,
                          color: Colors.black,
                        ),
                        GaugeRange(
                          startValue: -19,
                          endValue: 0,
                          color: Colors.yellowAccent,
                        ),
                        GaugeRange(
                          startValue: 0,
                          endValue: 10,
                          color: Colors.orange,
                        ),
                        GaugeRange(
                          startValue: 10,
                          endValue: 50,
                          color: Colors.green,
                        ),
                        GaugeRange(
                          startValue: 50,
                          endValue: 80,
                          color: Colors.red,
                        ),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value: displayingTemperature ? temperature : temperature, // Set value based on condition
                          enableAnimation: true,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(
                            '$temperature°C',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), // Adjust the font size as needed
                          ),
                          angle: 90,
                          positionFactor: 0.5,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10), // Add some space between the gauge and the button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TemperatureDetails()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Background color
                onPrimary: Colors.white, // Text color
                elevation: 3, // Elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Button border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Button padding
              ),
              child: Text('Show Temperature Details'),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                width: 230, // Adjust the width as needed
                height: 230, // Adjust the height as needed
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      ranges: <GaugeRange>[
                        GaugeRange(
                          startValue: 0,
                          endValue: 1,
                          color: Colors.black,
                        ),
                        GaugeRange(
                          startValue: 0,
                          endValue: 20,
                          color: Colors.blue,
                        ),
                        GaugeRange(
                          startValue: 20,
                          endValue: 50,
                          color: Colors.yellowAccent,
                        ),
                        GaugeRange(
                          startValue: 50,
                          endValue: 80,
                          color: Colors.green,
                        ),
                        GaugeRange(
                          startValue: 80,
                          endValue: 100,
                          color: Colors.red,
                        ),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value: humidity_display ? humidity : humidity, // Set value based on condition
                          enableAnimation: true,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(
                            '$humidity %',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), // Adjust the font size as needed
                          ),
                          angle: 90,
                          positionFactor: 0.5,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10), // Add some space between the gauge and the button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => humidity_details()), // Navigate to TemperatureDetails page
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Background color
                onPrimary: Colors.white, // Text color
                elevation: 3, // Elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Button border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Button padding
              ),
              child: Text('Show Humidity Details'),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                width: 230, // Adjust the width as needed
                height: 230, // Adjust the height as needed
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      ranges: <GaugeRange>[
                        GaugeRange(
                          startValue: 0,
                          endValue: 1,
                          color: Colors.black,
                        ),
                        GaugeRange(
                          startValue: 1,
                          endValue: 20,
                          color: Colors.blue,
                        ),
                        GaugeRange(
                          startValue: 20,
                          endValue: 50,
                          color: Colors.yellowAccent,
                        ),
                        GaugeRange(
                          startValue: 50,
                          endValue: 80,
                          color: Colors.orange,
                        ),
                        GaugeRange(
                          startValue: 80,
                          endValue: 100,
                          color: Colors.green,
                        ),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value: moisture_display ? soil_moisture : soil_moisture, // Set value based on condition
                          enableAnimation: true,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(
                            '$soil_moisture %',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), // Adjust the font size as needed
                          ),
                          angle: 90,
                          positionFactor: 0.5,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10), // Add some space between the gauge and the button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => moisture_details()), // Navigate to TemperatureDetails page
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Background color
                onPrimary: Colors.white, // Text color
                elevation: 3, // Elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Button border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Button padding
              ),
              child: Text('Show Soil Moisture Details'),
            ),
          ],
        ),
      ),
    );
  }
}
