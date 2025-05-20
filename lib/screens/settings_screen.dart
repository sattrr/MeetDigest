import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final List<Map<String, String>> settings = const [
    {
      'title': 'Account',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur',
      'icon': 'assets/svgs/user.svg',
    },
    {
      'title': 'Notifications',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur',
      'icon': 'assets/svgs/bell.svg',
    },
    {
      'title': 'Privacy & Security',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur',
      'icon': 'assets/svgs/lock.svg',
    },
    {
      'title': 'Help and Support',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur',
      'icon': 'assets/svgs/headphones.svg',
    },
    {
      'title': 'About',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur',
      'icon': 'assets/svgs/help.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Pengaturan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: settings.length,
            itemBuilder: (context, index) {
              final item = settings[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      item['icon']!,
                      width: 28,
                      height: 28,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle']!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}