import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final List<String> settings = [
    'Profil',
    'Notifikasi',
    'Privasi & Keamanan',
    'Bantuan dan Dukungan',
    'Tentang Kami'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pengaturan")),
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(settings[index]),
          onTap: () {
            // TODO: Implement action
          },
        ),
      ),
    );
  }
}