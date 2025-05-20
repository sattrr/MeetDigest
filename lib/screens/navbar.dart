import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';
import 'record_screen.dart';
import 'settings_screen.dart';
import 'package:meetdigest/themes/app_palette.dart';

class Navbar extends StatefulWidget {
  final int initialIndex;
  const Navbar({super.key, this.initialIndex = 0});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SettingsScreen(),
  ];

  void _onRecordPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecordScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonAnimator: NoFloatingActionButtonAnimator(),
      
      appBar: AppBar(
        title: const Text('MeetDigest'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SafeArea(
        bottom: false,
        child: _pages[_currentIndex],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: const Offset(0, 38),
              child: FloatingActionButton(
                onPressed: _onRecordPressed,
                backgroundColor: Colors.red,
                elevation: 0,
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/svgs/mic.svg',
                    width: 29,
                    height: 29,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 38),
            Text(
              'Rekam',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppPalette.colorSecondary,
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: AppPalette.white,
        elevation: 8.0,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                iconPath: 'assets/svgs/Home.svg',
                label: 'Beranda',
                isSelected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              const SizedBox(width: 38),
              _buildNavItem(
                iconPath: 'assets/svgs/Settings.svg',
                label: 'Pengaturan',
                isSelected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? AppPalette.colorPrimary : AppPalette.colorSecondary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppPalette.colorPrimary : AppPalette.colorSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoFloatingActionButtonAnimator extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({
    required Offset begin,
    required Offset end,
    required double progress,
  }) {
    return begin;
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return AlwaysStoppedAnimation(0);
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return AlwaysStoppedAnimation(1);
  }
}