import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rekam")),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(child: Icon(Icons.mic, size: 80)),
          SizedBox(height: 10),
          Text("00:00:00:00", style: TextStyle(fontSize: 24)),

          Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Kembali")),

              ElevatedButton(onPressed: () {
                // TODO: Stop rekaman
              }, child: Text("Stop")),

              ElevatedButton(onPressed: () {
                // TODO: Pause rekaman
              }, child: Text("Pause")),
            ],
          ),

          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/summary');
            },
            child: Text("Proses"),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}