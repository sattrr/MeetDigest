import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'navbar.dart';
import 'package:meetdigest/themes/app_palette.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
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
            width: 250,
            height: 250,
          ),
        ),
      );
    } else {
      return const OnboardingScreen();
    }
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToMainPage();
    }
  }

  void _goToMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Navbar()),
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
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _OnboardingPage(
                  title: 'Bingung sering meeting?',
                  description: 'Simpulkan rapatmu!',
                  svgAsset: 'assets/svgs/VideoCall.svg',
                  pageIndex: 0,
                  currentPage: _currentPage,
                ),
                _OnboardingPage(
                  title: 'Meeting tapi banyak kerjaan?',
                  description: 'Simpulkan rapatmu!',
                  svgAsset: 'assets/svgs/Finances.svg',
                  pageIndex: 1,
                  currentPage: _currentPage,
                ),
                _OnboardingPage(
                  title: 'MeetDigest Solusinya!',
                  description: 'Simpulkan rapatmu!',
                  svgAsset: 'assets/svgs/Workflow.svg',
                  pageIndex: 2,
                  currentPage: _currentPage,
                ),
              ],
            ),

            Positioned(
              top: 16,
              right: 18,
              child: TextButton(
                onPressed: _goToMainPage,
                child: const Text(
                  'Lewati',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Mulai' : 'Lanjut',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String svgAsset;
  final int pageIndex;
  final int currentPage;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.svgAsset,
    required this.pageIndex,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 86),
            SvgPicture.asset(svgAsset, width: 375, height: 400),
            const SizedBox(height: 72),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final isActive = index == currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
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

            const SizedBox(height: 28),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                children: pageIndex == 2
                    ? [
                        TextSpan(
                          text: 'MeetDigest',
                          style: TextStyle(color: AppPalette.colorPrimary),
                        ),
                        const TextSpan(text: ' Solusinya!'),
                      ]
                    : [
                        TextSpan(text: title),
                      ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}