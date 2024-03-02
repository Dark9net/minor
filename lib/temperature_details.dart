import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TemperatureDetails extends StatelessWidget {
  Future<List<int>> fetchData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/IOT/sensors/12'));

    if (response.statusCode == 200) {
      List<int> dataList = response.body.split(',').map(int.parse).toList();
      return dataList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Details'),
      ),
      body: Center(
        child: FutureBuilder<List<int>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Display a loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Once the data is loaded, display it
              List<int> dataList = snapshot.data!;
              return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Data ${index + 1}: ${dataList[index]}'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
