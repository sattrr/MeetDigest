import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Beranda")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // TODO: Implement file picker
            },
            child: Text("Upload Audio File"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => ListTile(
                title: Text("Catatan ${index + 1}"),
                subtitle: Text("Ringkasan teks singkat..."),
                onTap: () {
                  // TODO: Navigasi ke summary
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}