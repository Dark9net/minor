import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home System',
      theme: ThemeData(primarySwatch: Colors.deepOrange,
      scaffoldBackgroundColor: Colors.black,),
      home: ScrollableTitlePage(),
    );
  }
}
class ScrollableTitlePage extends StatefulWidget {
  @override
  _ScrollableTitlePageState createState() => _ScrollableTitlePageState();
}
//changing colors on pressing buttons
class _ScrollableTitlePageState extends State<ScrollableTitlePage> {
  Map<String, bool> buttonClickedMap={
    'Room 1':false,
    'Room 2' : false,
    'Room 3':false,
    'Room 4':false,
    'gas_status':false,
    'Door Status':false,
  };
  final String serverAddress = 'https://blynk.cloud/external/api/';
  final String token = 'nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb';
  // final String door_url = '';//virtual pin V2 is assigned for door status
  // final String door_vpin = 'V2';
  // final String door_status = 'Door Status';
  bool room1 = false;
  bool room2 =false;
  bool room3 = false;
  bool room4 = false;
  bool doors = false;

  double temp= 0.00; //default temperature value
  double humi_dity = 1.00;//default humidity value appears on the start screen
  double moisture = 0.00; //default moisture value on the screen at app startup

//function for button color change states
  void change_button_color(String buttonname) {
    setState(() {
      buttonClickedMap[buttonname] = !buttonClickedMap[buttonname]!;
    });
  }
  Future<void> update_buttons(String pin, String value) async {
    String url = 'https://blynk.cloud/external/api/update?token=$token&$pin=$value';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Pin $pin updated with value $value');
        print('Failed to update pin $pin with value $value. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur
      print('Exception while updating pin: $e');
    }
  }
  void updateButtonColors() {
    setState(() {
      buttonClickedMap['Room 1'] = room1;
      buttonClickedMap['Room 2'] = room2;
      buttonClickedMap['Room 3'] = room3;
      buttonClickedMap['Room 4'] = room4;
      buttonClickedMap['Door Status'] = doors;
      // Update other room buttons here
    });
  }
  void toggleButtonState(String pin, bool currentState) async {
    final newValue = currentState ? '0' : '1';
    await update_buttons(pin, newValue);
    updateButtonColors();
  }

  void control_led_room1() {
    setState(() {
      if (room1) {
        update_buttons('v1', '0').then((_) {
          setState(() {
            buttonClickedMap['Room 1'] = false;
          });
        });
      } else {
        update_buttons('v1', '1').then((_) {
          setState(() {
            buttonClickedMap['Room 1'] = true;
          });
        });
      }
      room1 = !room1; // Toggle the button state
    });
  }
  void control_led_room2() {
    setState(() {
      if (room2) {
        update_buttons('v2', '0').then((_) {
          setState(() {
            buttonClickedMap['Room 2'] = false;
          });
        });
      } else {
        update_buttons('v2', '1').then((_) {
          setState(() {
            buttonClickedMap['Room 2'] = true;
          });
        });
      }
      room2 = !room2; // Toggle the button state
    });
  }
  void control_led_room3() {
    setState(() {
      if (room3) {
        update_buttons('v3', '0').then((_) {
          setState(() {
            buttonClickedMap['Room 3'] = false;
          });
        });
      } else {
        update_buttons('v3', '1').then((_) {
          setState(() {
            buttonClickedMap['Room 3'] = true;
          });
        });
      }
      room3 = !room3; // Toggle the button state
    });
  }
  void control_led_room4() {
    setState(() {
      if (room4) {
        update_buttons('v4', '0').then((_) {
          setState(() {
            buttonClickedMap['Room 4'] = false;
          });
        });
      } else {
        update_buttons('v4', '1').then((_) {
          setState(() {
            buttonClickedMap['Room 4'] = true;
          });
        });
      }
      room4 = !room4; // Toggle the button state
    });
  }
  void control_door() {
    setState(() {
      if (doors) {
        update_buttons('v5', '0').then((_) {
          setState(() {
            buttonClickedMap['Door Status'] = false;
          });
        });
      } else {
        update_buttons('v5', '1').then((_) {
          setState(() {
            buttonClickedMap['Door Status'] = true;
          });
        });
      }
      doors = !doors; // Toggle the button state
    });
  }
  // temperature updation code//
  void update_temperature() async {
    // final String authToken = 'nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb';
    final String temp_vpin = 'v6'; //temperature virtual pin

    String apiUrl = 'https://blynk.cloud/external/api/get?token=$token&$temp_vpin';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Successfully fetched data
        setState(() {
          temp = double.parse(response.body);
        });
      } else {
        // Failed to fetch data
        setState(() {
          print('status code: ${response.statusCode}');
        });
      }
    } catch (e) {
      // Handle any exceptions that occur
      setState(() {
        print('Exception $e');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetch_button_states();

    // Fetch temperature initially
    update_temperature(); //setting the temperature when app starts
    // fetchDoorStatus(); //setting the door status when app opens
  }
  Future<void> fetch_button_states() async {
    final v1State = await getButtonState('v1');
    final v2State = await getButtonState('v2');
    final v3State = await getButtonState('v3');
    final v4State = await getButtonState('v4');
    final v5State = await getButtonState('v5');
    setState(() {
      room1 = v1State == '1';
      room2 = v2State == '1';
      room3 = v3State == '1';
      room4 = v4State == '1';
      doors = v5State == '1';
      // Set other room states here
      updateButtonColors();
    });
  }
  Future<String> getButtonState(String pin) async {
    final response = await http.get(
      Uri.parse('https://blynk.cloud/external/api/get?token=nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb&$pin'),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get $pin state');
    }
  }
  // temperature updation code ends here//

  // humidity updation code starts from here//
  void update_humidity() async {
    final String hum_vpin = 'v5'; //humidity virtual pin

    String hum_url = 'https://blynk.cloud/external/api/get?token=$token&$hum_vpin';

    try {
      final response = await http.get(Uri.parse(hum_url));

      if (response.statusCode == 200) {
        // Successfully fetched data
        setState(() {
          humi_dity = double.parse(response.body);
        });
      } else {
        // Failed to fetch data
        setState(() {
          print('status code: ${response.statusCode}');
        });
      }
    } catch (e) {
      // Handle any exceptions that occur
      setState(() {
        print('Exception $e');
      });
    }
  }
  // humidity updation code ends here//

  void update_soil_moisture() async {
    final String soil_vpin = 'v7'; //humidity virtual pin
    String soil_url = 'https://blynk.cloud/external/api/get?token=$token&$soil_vpin';

    try {
      final response = await http.get(Uri.parse(soil_url));

      if (response.statusCode == 200) {
        // Successfully fetched data
        setState(() {
          moisture = double.parse(response.body);
        });
      } else {
        // Failed to fetch data
        setState(() {
          print('status code: ${response.statusCode}');
        });
      }
    } catch (e) {
      // Handle any exceptions that occur
      setState(() {
        print('Exception $e');
      });
    }
  }
  // App Bar is shown here

  //ASsigning door status here
  // String doorStatusText = 'Door Status'; // Initial text to be displayed on the button

  // Future<void> door_movement_control(String door_vpin2, String door_value) async {
  //   String door_control_url = 'https://blynk.cloud/external/api/update?token=$token&$door_vpin2=$door_value';
  //
  //   try {
  //     final response = await http.get(Uri.parse(door_control_url));
  //
  //     if (response.statusCode == 200) {
  //       // Pin value updated successfully
  //       print('Pin $door_vpin2 updated with value $door_value');
  //     } else {
  //       // Failed to update pin value
  //       print('Failed to update pin $door_vpin2 with value $door_value. Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Handle any exceptions that occur
  //     print('Exception while updating pin: $e');
  //   }
  // }
  // void door_activity(int receivedvalue){
  //   setState(() {
  //     if (room1) {
  //       update_buttons('v3', '0');//v3 pin is assigned to perform door operations
  //     } else {
  //       update_buttons('v3', '1');
  //     }
  //
  //   });
  // }
  // void updateDoorStatusText(int receivedvalue) {
  //   setState(() {
  //     if (receivedvalue == 0) {
  //       doorStatusText = 'Door Opened'; // Change text if the value is 0
  //     } else if (receivedvalue == 1) {
  //       doorStatusText = 'Door Closed'; // Change text if the value is 1
  //     } else {
  //       doorStatusText = 'Unknown Status'; // Handle other values if needed
  //     }
  //   });
  // }
  //
  // Future<void> fetchDoorStatus() async {
  //   final String door_url = 'https://blynk.cloud/external/api/get?token=$token&$door_vpin';
  //
  //   try {
  //     final response = await http.get(Uri.parse(door_url));
  //
  //     if (response.statusCode == 200) {
  //       int receivedValue = int.parse(response.body);
  //       updateDoorStatusText(receivedValue);
  //     } else {
  //       print('Failed to fetch door status. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception while fetching door status: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: AppBar(
          title: Text('Smart Home',
          style: TextStyle(fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey),
          ),
          backgroundColor:Colors.black87 ,
          leading: IconButton(
            icon: Icon(Icons.menu_open,
            size: 20,
            color: Colors.blueGrey),
            onPressed: () {
    // Function for drawer menu bar
    },
          ),
        ),
      ),
      // Button for room 1
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 90,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        change_button_color('Room 1');
                        control_led_room1();
                        // Function call for room 1
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.blue,
                        primary: buttonClickedMap['Room 1']! ? Colors.tealAccent: Colors.white10,
                      ),
                      child: Text('Room 1',
                      style: TextStyle(fontSize: 11,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      color:Colors.blueGrey),
                      ),
                    ),
                  ),
                  // Button for Room 2
                  SizedBox(
                    width: 90,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        change_button_color('Room 2');
                        control_led_room2();
                        // Function call for room 2
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.blue,
                        primary: buttonClickedMap['Room 2']! ? Colors.tealAccent: Colors.white10,
                      ),
                      child: Text('Room 2',
                      style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                      ),
                    ),
                  ),
                ],
              ),
              // Button for Room 3
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 90,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        change_button_color('Room 3');
                        control_led_room3();
                        // Function call for room 3
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.blue,
                        primary: buttonClickedMap['Room 3']! ? Colors.tealAccent: Colors.white10,
                      ),
                      child: Text('Room 3',
                      style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      ),
                      ),
                    ),
                  ),
                  // Button for Room 4
                  SizedBox(
                    width: 90,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        change_button_color('Room 4');
                        control_led_room4();
                        // Function call for room 4
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.blue,
                        primary: buttonClickedMap['Room 4']! ? Colors.tealAccent: Colors.white10,
                      ),
                      child: Text('Room 4',
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ],
              ),
          // Button for gas status
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 90,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    change_button_color('gas_status');

                    // Function call for room 3
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.blue,
                    primary: buttonClickedMap['gas_status']! ? Colors.cyan: Colors.white10,
                  ),
                  child: Text('Gas Status',
                    style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
              // Button for Door Status
              SizedBox(
                width: 90,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    change_button_color('Door Status');
                    control_door();
                    // door_activity();
                    // Function call for door
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.blue,
                    primary: buttonClickedMap['Door Status']! ? Colors.cyan: Colors.white10,
                  ),
                  child: Text('Door',
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Colors.blueGrey),
                  ),
                ),
              ),
            ],
          ),
              // Temperature here
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        update_temperature();
                        // Function call for temperature
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.blueGrey,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        backgroundColor: Colors.white12,
                      ),
                      child: Text(
                        'Temperature : $temp °C',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                  // Humidity here
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        update_humidity();
                        // Function call for humidity
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white12,
                        shadowColor: Colors.blueGrey,
                      ),
                      child: Text('Humidity : $humi_dity %',
                      style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  // Soil Moisture Here
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        update_soil_moisture();
                        // Function call for soil moisture
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white12,
                        shadowColor: Colors.blueGrey,
                      ),
                      child: Text('Soil Moisture : $moisture %',
                        style: TextStyle(fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
