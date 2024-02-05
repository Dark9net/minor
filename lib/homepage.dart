import 'package:flutter/material.dart';


class Homepage extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart watch App')),
      body: Center(
        child: ElevatedButton(
          onPressed: ()  => openPage(context),
          child: const Text('Press me'),
        ),
      ),
    );
  }
  openPage(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage()));
  }
}
