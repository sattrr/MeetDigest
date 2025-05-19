import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'main_page.dart';
import 'package:meetdigest/themes/app_palette.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _showOnboarding = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showOnboarding) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SvgPicture.asset(
            'assets/svgs/MeetDigest.svg',
            width: 200,
            height: 200,
          ),
        ),
      );
    } else {
      return OnboardingScreen();
    }
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    _OnboardingPage(
      title: 'Bingung sering meeting?',
      description: 'Simpulkan rapatmu!',
      svgAsset: 'assets/svgs/VideoCall.svg',
    ),
    _OnboardingPage(
      title: 'Meeting tapi banyak kerjaan?',
      description: 'Simpulkan rapatmu!',
      svgAsset: 'assets/svgs/Finances.svg',
    ),
    _OnboardingPage(
      title: 'MeetDigest Solusinya!',
      description: 'Simpulkan rapatmu!',
      svgAsset: 'assets/svgs/Workflow.svg',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToMainPage();
    }
  }

  void _goToMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainPage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: _pages,
          ),
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    bool isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppPalette.colorPrimary
                            : AppPalette.colorSecondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                      _currentPage == _pages.length - 1 ? 'Mulai' : 'Lanjut'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.colorPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String svgAsset;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.svgAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svgAsset, width: 375, height: 450),
          SizedBox(height: 32),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}