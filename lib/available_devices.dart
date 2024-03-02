import 'package:flutter/material.dart';

class available_devices extends StatefulWidget {
  const available_devices({Key? key});

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<available_devices> {
  // var arrNames = ['Iphone 13','Samsung Galaxy S23 Ultra' , 'Redmi note 12',  'Realme Nazaro 60',];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wifi Provisioning'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                hintText: 'WiFi SSID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                hintText: 'WiFi Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                // Navigate to another page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const available_devices()),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 45,
                width: 105,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(


                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  'CONNECT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),


            // const Divider(thickness:1) ,
            // const Text('Connected Devices'),
            // const Divider(thickness:1) ,



            // Expanded(
            //   child: ListView.separated(
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         leading: Text('${index+1}'),
            //         title: Text(arrNames[index]),
            //         subtitle: const Text('---'),
            //         trailing: const Icon(Icons.delete),
            //       );
            //     },
            //     itemCount: arrNames.length,
            //     separatorBuilder: (context, index) {
            //       return const Divider(height: 20, thickness: 1);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
