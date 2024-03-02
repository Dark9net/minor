import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class kitchen extends StatefulWidget {
  const kitchen({Key? key}) : super(key: key);

  @override
  _kitchenState createState() => _kitchenState();//changes _hallstate to kitchenstate
}

class _kitchenState extends State<kitchen> {
  List mySmartDevices = [
    ["Bulb 1", "lib/icons/light-bulb.png", false],
    ["Bulb 2", "lib/icons/air-conditioner.png", false],
    ["Bulb 3", "lib/icons/project.png", false],
    ["Bulb 4", "lib/icons/fan.png", false],
  ];

  final String serverAddress = 'https://blynk.cloud/external/api/';
  final String token = 'nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb';
  String gasStatusText = 'gas Status';
  final String gas_vpin = 'V9';
  bool room1 = false;
  bool room2 =false;
  bool room3 = false;
  bool room4 = false;
  bool gas = false;
  bool isbuttonpressed = false;

  Map<String, bool> buttonClickedMap = {
    'Room 1': false,
    'Room 2': false,
    'Room 3': false,
    'Room 4': false,
    'gas Status': false,
  };
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

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer){
      fetchgasStatus();
      fetch_button_states();
      updateButtonColors();
      fetch_button_states();
    });
  }

  Future<void> fetch_button_states() async {
    final v1State = await getButtonState('v1');
    final v2State = await getButtonState('v2');
    final v3State = await getButtonState('v3');
    final v4State = await getButtonState('v4');
    final v5State = await getButtonState('v8');
    setState(() {
      room1 = v1State == '1';
      room2 = v2State == '1';
      room3 = v3State == '1';
      room4 = v4State == '1';
      gas = v5State == '1';
      updateButtonColors();
    });
  }

  Future<String> getButtonState(String pin) async {
    final response = await http.get(Uri.parse('https://blynk.cloud/external/api/get?token=nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb&$pin'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get $pin state');
    }
  }

  void updateButtonColors() {
    setState(() {
      buttonClickedMap['Room 1'] = room1;
      buttonClickedMap['Room 2'] = room2;
      buttonClickedMap['Room 3'] = room3;
      buttonClickedMap['Room 4'] = room4;
      buttonClickedMap['gas Status'] = gas;
    });
  }

  void updategasStatusText(int receivedvalue) {
    setState(() {
      if (receivedvalue == 0) {
        gasStatusText = 'Neutral';
      } else if (receivedvalue == 1) {
        gasStatusText = 'Gas Leaked';
      } else {
        gasStatusText = 'Unknown Status';
      }
    });
  }

  Future<void> fetchgasStatus() async {
    final String gas_url = 'https://blynk.cloud/external/api/get?token=$token&$gas_vpin';
    try {
      final response = await http.get(Uri.parse(gas_url));
      if (response.statusCode == 200) {
        int receivedValue = int.parse(response.body);
        updategasStatusText(receivedValue);
      } else {
        print('Failed to fetch gas status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching gas status: $e');
    }
  }


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kitchen'),
        backgroundColor: Colors.lightBlueAccent, // Set the app bar color here
      ),
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
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
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

              const SizedBox(height: 10),

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
                            change_button_color('gas Status');
                            // updategasStatusText();
                            fetchgasStatus();
                            // Implement onPressed logic for the additional button
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            shadowColor: Colors.white70,
                            primary: buttonClickedMap['gas Status']! ? Colors.white70: Colors.white70,
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
    'gas Status': false,
  };
  final String serverAddress = 'https://blynk.cloud/external/api/';
  final String token = 'nk24hJbhlmcJv9x6n8E49fH-Nx7sMrRb';
  bool room1 = false;
  bool room2 =false;
  bool room3 = false;
  bool room4 = false;
  bool gas = false;
  late bool _powerOn;

  @override
  void initState() {
    super.initState();
    _powerOn = widget.powerOn;
  }


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
                      } else if (widget.smartDeviceName == 'Bulb 2') {
                        change_button_color('Room 2');
                        control_led_room2();
                      }
                      else if (widget.smartDeviceName == 'Bulb 3'){
                        change_button_color('Room 3');
                        control_led_room3();
                      }
                      else if (widget.smartDeviceName == 'Bulb 4'){
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