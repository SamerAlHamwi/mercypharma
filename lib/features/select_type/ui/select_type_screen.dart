

import 'package:flutter/material.dart';
import 'package:mercypharma/core/constant/app_colors.dart';

import '../../game_screen/ui/game_screen.dart';

class SelectTypeScreen extends StatelessWidget {
  const SelectTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "اختيار نوع اللعبة",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.gradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTypeButton(
              context: context,
              title: "🧴 جلدية",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MemoryGamePage(
                        images: [
                          'assets/images/dermatological/1.png',
                          'assets/images/dermatological/2.png',
                          'assets/images/dermatological/3.png',
                          'assets/images/dermatological/4.png',
                          'assets/images/dermatological/5.png',
                          'assets/images/dermatological/6.png',
                          'assets/images/dermatological/7.png',
                          'assets/images/dermatological/8.png',
                          'assets/images/dermatological/9.png',
                        ],
                      type: 1,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            _buildTypeButton(
              context: context,
              title: "🧠 نفسية",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MemoryGamePage(
                      images: [
                        'assets/images/psychiatric/1.png',
                        'assets/images/psychiatric/2.png',
                        'assets/images/psychiatric/3.png',
                        'assets/images/psychiatric/4.png',
                        'assets/images/psychiatric/5.png',
                        'assets/images/psychiatric/6.png',
                      ],
                      type: 2,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white.withValues(alpha: 0.12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
