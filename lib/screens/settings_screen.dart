import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetdigest/themes/app_palette.dart';

class SettingsScreen extends StatelessWidget {
  final List<String> settings = [
    'Profil',
    'Notifikasi',
    'Privasi & Keamanan',
    'Bantuan dan Dukungan',
    'Tentang Kami'
  ];

  final List<String> icons = [
    'assets/svgs/user.svg',
    'assets/svgs/bell.svg',
    'assets/svgs/lock.svg',
    'assets/svgs/headphones.svg',
    'assets/svgs/help.svg',
  ];

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MeetDigest"),
      ),
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) => ListTile(
          leading: SvgPicture.asset(
            icons[index],
            width: 24,
            height: 24,
            color: AppPalette.colorSecondary,
          ),
          title: Text(settings[index]),
          onTap: () {
            // TODO: Implement action
          },
        ),
      ),
    );
  }
}