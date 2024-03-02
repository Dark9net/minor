import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:minor/loginpage.dart';
import 'package:minor/Dining_Room.dart';
import 'package:minor/Green_House.dart';
import 'package:minor/kitchen.dart';
import 'package:minor/hall.dart';
import 'package:minor/Google_alexa.dart';
import 'package:minor/statistics.dart';
import 'package:minor/available_devices.dart';
import 'package:minor/settings.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:minor/profile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}



class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 2; // Index of the selected tab

  static const List<Widget> _pages = [
    available_devices(),
    Google_alexa(),
    DashboardWidget(),
    Statistics(),
    Settings(),

    //more pages here
  ];

  //Refresh page Here
  Future<void> _refresh() async{
    await Future.delayed(const Duration(seconds: 1));
    // await fetchDoorStatus();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: DrawerContent(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            // child: Text(
            //   'Welcome to Smart Home',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 55.0,
        items: const <Widget>[
          Icon(Icons.devices, size: 30),
          Icon(Icons.keyboard_voice, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.bar_chart, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        color: Colors.lightBlueAccent,
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          handleNavigation(index);
        },
      ),
    );
  }



  void handleNavigation(int index) {
    switch (index) {
      case 0:
      // Handle Home tab tap
        break;
      case 1:
      // Handle Devices tab tap
        break;
      case 2:
      // Handle Alexa tab tap
        break;
      case 3:
      // Handle Statistic tab tap
        break;
      case 4:
      // Handle settings tab tap
        break;
    }
  }
}

class DrawerContent extends StatelessWidget {
  const DrawerContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(0), // Set margin to 0
                child: Image.asset(
                  'lib/icons/smart.jpg',
                  width: double.infinity, // Take full width available
                  height: 136, // Adjust the height as needed
                ),
              ),
            ],
          ),
        ),
        ListTile(
          title: const Text('Profile'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyInfo(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Conected Devices'),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const DevicesPage(),
            //   ),
            // );
          },
        ),
        ListTile(
          title: const Text('Notifications'),
          // onTap: () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const Notifications(),
          //     ),
          //   );
          // },
        ),
        ListTile(
          title: const Text('LogOut'),
          onTap: () {
            _showConfirmationDialog(context);
          },
        ),
      ],
    );
  }
}
Future<void> _showConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: const Text('Confirm Logout'),
          ),
        ],
      );
    },
  );
}

class SmartDeviceBox extends StatefulWidget {
  final String smartDeviceName;
  final String iconPath;
  final bool powerOn;
  final void Function(bool)? onChanged;

  SmartDeviceBox({
    Key? key,
    required this.smartDeviceName,
    required this.iconPath,
    required this.powerOn,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SmartDeviceBoxState createState() => _SmartDeviceBoxState();
}

class _SmartDeviceBoxState extends State<SmartDeviceBox> {
  Map<String, bool> buttonClickedMap = {
    'Room 1': false,
    'Room 2': false,
    'Room 3': false,
    'Room 4': false,
    'Gas Status': false,
    'Door Status': false,
  };

  final String serverAddress = 'https://blynk.cloud/external/api/';
  final String token = 'nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb';
  String doorStatusText = 'Door Status'; // Initial text to be displayed on the button
  final String door_vpin = 'V8';
  String gasStatusText = 'Gas Status'; //Gas status initially when app connects
  final String gas_vpin = 'V6';
  bool room1 = false;
  bool room2 =false;
  bool room3 = false;
  bool room4 = false;
  bool doors = false;
  bool gas = false;
  double temperature = -20.00; //default temperature value
  double humidity = 0.00;
  late bool _powerOn;

  @override
  void initState() {
    super.initState();
    _powerOn = widget.powerOn;
  }

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
      }
      else {
        print('Failed to update pin $pin with value $value. Error: ${response.statusCode}');
      }
    } catch (e) {
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
      buttonClickedMap['Gas Status'] = gas;
    });
  }
  ////////////////////////////////////Door Status///////////////////////////////////////////////
  // Assigning door status here
  void updateDoorStatusText(int receivedvalue) {
    setState(() {
      if (receivedvalue == 0) {
        doorStatusText = 'Door Closed'; // Change text if the value is 0
      } else if (receivedvalue == 1) {
        doorStatusText = 'Door Opened'; // Change text if the value is 1
      } else {
        doorStatusText = 'Unknown Status'; // Handle other values if needed
      }
    });
  }
  Future<void> fetchDoorStatus() async {
    final String door_url = 'https://blynk.cloud/external/api/get?token=$token&$door_vpin';
    try {
      final response = await http.get(Uri.parse(door_url));
      if (response.statusCode == 200) {
        int receivedValue = int.parse(response.body);
        updateDoorStatusText(receivedValue);
      } else {
        print('Failed to fetch door status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching door status: $e');
    }
  }
/////////////////////////////////Door Condition Updated Here///////////////////////////////////

/////////////////Room status and button controls//////////////////////
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
        update_buttons('v3', '1').then((_) {
          setState(() {
            buttonClickedMap['Room 3'] = false;
          });
        });
      } else {
        update_buttons('v3', '0').then((_) {
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
  void door_control() {
    setState(() {
      if (doors) {
        update_buttons('v8', '0').then((_) {
          setState(() {
            buttonClickedMap['Door Status'] = false;
          });
        });
      } else {
        update_buttons('v8', '1').then((_) {
          setState(() {
            buttonClickedMap['Door Status'] = true;
          });
        });
      }
      doors = !doors; // Toggle the button state
    });
  }

  /////////////////Room status and button controls//////////////////////
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: _powerOn ? Colors.grey[900] : Color.fromARGB(44, 164, 167, 189),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // icon
              Image.asset(
                widget.iconPath,
                height: 70,
                color: _powerOn ? Colors.white : Colors.grey.shade700,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        widget.smartDeviceName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: _powerOn ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Switch(
                    value: _powerOn,
                    onChanged: (value) {
                      setState(() {
                        _powerOn = value;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      }
                      if (widget.smartDeviceName == 'Bulb 1') {
                        change_button_color('Room 1');
                        control_led_room1();
                      } else if (widget.smartDeviceName == 'AC') {
                        change_button_color('Room 2');
                        control_led_room2();
                      }
                      else if (widget.smartDeviceName == 'Projector'){
                        change_button_color('Room 3');
                        control_led_room3();
                      }
                      else if (widget.smartDeviceName == 'Fan'){
                        change_button_color('Room 4');
                        control_led_room4();
                      }
                    },
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

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  Map<String, bool> buttonClickedMap = {
    'Room 1': false,
    'Room 2': false,
    'Room 3': false,
    'Room 4': false,
    'Gas Status': false,
    'Door Status': false,
  };

  List mySmartDevices = [
    // [ smartDeviceName, iconPath , powerStatus ]
    ["Bulb 1", "lib/icons/light-bulb.png", false],
    ["AC", "lib/icons/air-conditioner.png", false],
    ["Projector", "lib/icons/project.png", false],
    ["Fan", "lib/icons/fan.png", false],
    ["Temperature","lib/icons/temp.png",false],
    ["Humidity","lib/icons/humidity.png",false],
  ];

  String? username;
  final String serverAddress = 'https://blynk.cloud/external/api/';
  final String token = 'nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb';
  String doorStatusText = 'Door Status'; // Initial text to be displayed on the button
  final String door_vpin = 'V8';
  String gasStatusText = 'Gas Status'; //Gas status initially when app connects
  final String gas_vpin = 'V9';
  bool room1 = false;
  bool room2 =false;
  bool room3 = false;
  bool room4 = false;
  bool doors = false;
  bool gas = false;
  double temperature = -20.00; //default temperature value
  double humidity = 0.00;//default humidity value appears on the start screen
  bool isbuttonpressed = false;
// https://blynk.cloud/external/api/update?token=nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb&V9
//   defining virtual datastream pins here
//   v0 = relay1
//   v1 = relay2
//   v2 = relay3
//   v3 = relay4
//   v4 = door
//   v5 = gas
//   v6 = servo
//   v7 = humidity
//   v8 = temperature
//   v9 = soil mooisture
//   v10 =

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
      }
      else {
        print('Failed to update pin $pin with value $value. Error: ${response.statusCode}');
      }
    } catch (e) {
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
      buttonClickedMap['Gas Status'] = gas;
    });
  }

  /////////////////Room status and button controls//////////////////////
  void door_control() {
    setState(() {
      if (doors) {
        update_buttons('v8', '0').then((_) {
          setState(() {
            buttonClickedMap['Door Status'] = false;
          });
        });
      } else {
        update_buttons('v8', '1').then((_) {
          setState(() {
            buttonClickedMap['Door Status'] = true;
          });
        });
      }
      doors = !doors; // Toggle the button state
    });
  }

  ////using v1,v2,v3 and v4 for room1,room2,room3 and room4////////////
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer){
      fetchDoorStatus();
      fetch_button_states();
      fetchgasStatus();
      updateButtonColors();
      fetch_button_states();

      fetchTemperature().then((value1) {
        setState(() {
          temperature = value1;
        });
      });
      fetchhumidity().then((value2) {
        setState(() {
          humidity = value2;
        });
      });

    });
    fetchUsername();
    //fetching gas status from server
  }

  Future<void> fetch_button_states() async {
    final v1State = await getButtonState('v1');
    final v2State = await getButtonState('v2');
    final v3State = await getButtonState('v3');
    final v4State = await getButtonState('v4');
    final v5State = await getButtonState('v8');
    final v6State = await getButtonState('v9');
    setState(() {
      room1 = v1State == '1';
      room2 = v2State == '1';
      room3 = v3State == '1';
      room4 = v4State == '1';
      doors = v5State == '1';
      gas = v6State == '1';

      // Set other room states here
      updateButtonColors();
    });
  }
  Future<String> getButtonState(String pin) async {
    final response = await http.get(Uri.parse('https://blynk.cloud/external/api/get?token=nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb&$pin'),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get $pin state');
    }
  }

////////////////////////////////////Door Status///////////////////////////////////////////////
  // ASsigning door status here
  void updateDoorStatusText(int receivedvalue) {
      setState(() {
        if (receivedvalue == 0) {
          doorStatusText = 'Door Closed'; // Change text if the value is 0
        } else if (receivedvalue == 1) {
          doorStatusText = 'Door Opened'; // Change text if the value is 1
        } else {
          doorStatusText = 'Unknown Status'; // Handle other values if needed
        }
      });
    }
    Future<void> fetchDoorStatus() async {
      final String door_url = 'https://blynk.cloud/external/api/get?token=$token&$door_vpin';
      try {
        final response = await http.get(Uri.parse(door_url));
        if (response.statusCode == 200) {
          int receivedValue = int.parse(response.body);
          updateDoorStatusText(receivedValue);
        } else {
          print('Failed to fetch door status. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception while fetching door status: $e');
      }
    }
/////////////////////////////////Door Condition Updated Here///////////////////////////////////

/////////////////////////////////Gas Status /////////////////////////////////////////////
  void updategasStatusText(int receivedvalue1) {
    setState(() {
      if (receivedvalue1 == 0) {
        gasStatusText = 'No Leakage'; // Change text if the value is 0
      } else if (receivedvalue1 == 1) {
        gasStatusText = 'Gas Leaked'; // Change text if the value is 1
      } else {
        gasStatusText = 'Unknown Status'; // Handle other values if needed
      }
    });
  }
  Future<void> fetchgasStatus() async {
    final String gas_url = 'https://blynk.cloud/external/api/get?token=$token&v9';
    try {
      final response = await http.get(Uri.parse(gas_url));

      if (response.statusCode == 200) {
        int receivedvalue1 = int.parse(response.body);
        updategasStatusText(receivedvalue1);
      } else {
        print('Failed to fetch gas status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching gas status: $e');
    }
  }
  ///////////////////////////////Gas Status//////////////////////////////////////////////

  Future<void> fetchUsername() async {
    final url = Uri.parse('http://127.0.0.1:8000/auth/jwt/create/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          username = responseData['username'];
        });
        print('no user fetched');
      } else {
        print('Failed to fetch username: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching username: $error');
    }
  }

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
  Future<double> fetchhumidity() async {
    final response = await http.get(Uri.parse('https://blynk.cloud/external/api/get?token=$token&v5'));
    if (response.statusCode == 200) {
      final humidityData = response.body;
      final humidity = double.tryParse(humidityData); // Changed temperature to humidity
      if (humidity != null) {
        return humidity;
      } else {
        throw Exception('Failed to parse humidity data'); // Changed temperature to humidity
      }
    } else {
      throw Exception('Failed to load humidity data'); // Changed temperature to humidity
    }
  }

  // New buttons are here power buttons functions are:
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });
    if (index == 0) {
      if (!isbuttonpressed) {
        updateButtons('v1', '1');
      } else {
        updateButtons('v1', '0');
      }
      isbuttonpressed = !isbuttonpressed;
    }
  }
  // Function to send data to the Blynk cloud server
  Future<void> updateButtons(String pin, String value) async {
    final String token = 'nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb';
    final String url = 'https://blynk.cloud/external/api/update?token=$token&$pin=$value';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Pin $pin updated with value $value');
      } else {
        print('Failed to update pin $pin with value $value. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while updating pin: $e');
    }
  }

  // New buttons are here power buttons functions are:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(), // You can add an empty SizedBox to the left if you need space
                    // Image.asset(
                    //   'lib/icons/icon.jpeg',
                    //   height: 60,
                    //   width: 60,
                    // ),
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                        // Add functionality for account icon
                      },
                      child: Image.asset(
                        'lib/icons/icon.jpeg',
                        height: 60,
                        width: 60,
                    ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome to smart Home,",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.lightBlueAccent, letterSpacing: 0,fontSize: 20),
                ),
              ),
              ],
            ),
          ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 23,vertical:0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username ?? 'AVISHEK',
                      style: GoogleFonts.agdasima(
                        textStyle: TextStyle(color: Colors.black, letterSpacing: 2,fontSize: 60),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'lib/icons/temperature.png',
                      width: 30.0,
                      height: 60.0,
                    ),
                    SizedBox(width: 10.0), // Add some space between the icons
                    Padding(
                      padding: EdgeInsets.only(top: 21.0), // Add vertical padding to the text
                      child: Text(
                        '$temperature °C',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Image.asset(
                      'lib/icons/humidity.png',
                      width: 30.0,
                      height: 60.0,
                    ),
                    SizedBox(width: 3.0),
                    Padding(
                      padding: EdgeInsets.only(top:21.0),
                      child: Text(
                      '$humidity %',
                      style: TextStyle(fontSize: 15.0),
                    ),
                   ),
                  ],
                ),
              ),



              const SizedBox(height: 10),
          const Divider(thickness: 0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(height: 10),
                const Divider(thickness: 0.5),
                const SizedBox(),
                SizedBox(
                  width: 130,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                      //code
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 6),
                        Icon(Icons.living_outlined, color: Colors.black12),
                        SizedBox(width: 3),
                        Text('LivingRoom', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 125,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Dining_Room(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 6),
                        Icon(Icons.living_outlined, color: Colors.black12),
                        SizedBox(width: 3),
                        Text('Dining Room', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              //////Move to another page which represents Hall buttons//
                const SizedBox(width: 12),
                SizedBox(
                  width: 90,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Hall(),
                          ),
                        );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 6),
                        Icon(Icons.meeting_room_outlined, color: Colors.black12),
                        SizedBox(width: 3),
                        Text('Hall', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 110,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const kitchen(),
                          ),
                        );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 6),
                        Icon(Icons.kitchen_outlined, color: Colors.black12),
                        SizedBox(width: 3),
                        Text('Kitchen', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                SizedBox(
                  width: 135,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GreenHouse(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 6),
                        Icon(Icons.warehouse_outlined, color: Colors.black12),
                        SizedBox(width: 3),
                        Text('Green House', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 35,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const GreenHouse(),
                      //   ),
                      // );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 1),
                        Icon(Icons.add_circle_outline, color: Colors.black12),
                        SizedBox(width: 1),
                        // Text('Green House', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(thickness: 0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 135),
            child: Text(
              "Smart Devices",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey.shade800,
              ),
            ),
          ),


          const SizedBox(height: 10), //spacing between scrollable row and the buttons

          // SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                padding: EdgeInsets.symmetric(horizontal: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.1,
                ),
                itemBuilder: (context, index) {
                  return SmartDeviceBox(
                    smartDeviceName: mySmartDevices[index][0],
                    iconPath: mySmartDevices[index][1],
                    powerOn: mySmartDevices[index][2],
                    onChanged: (value) => powerSwitchChanged(value, index),
                  );
                },
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      change_button_color('Door Status');
                      door_control();
                      // updateDoorStatusText();
                      fetchDoorStatus();
                      // Implement onPressed logic for the additional button
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      shadowColor: Colors.white70,
                      primary: buttonClickedMap['Door Status']! ? Colors.white70: Colors.white10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.door_sliding,
                            size: 45,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            doorStatusText,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      change_button_color('Gas Status');
                      // gas_status();
                      fetchgasStatus();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      shadowColor: Colors.white70,
                      primary: buttonClickedMap['Gas Status']! ? Colors.white60: Colors.white10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.gas_meter_outlined,
                            size: 45,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            gasStatusText,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
