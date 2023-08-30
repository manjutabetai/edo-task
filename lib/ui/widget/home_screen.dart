import 'package:edo_task/service/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Tasks',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // * テーマ切り替え
                IconButton(
                    onPressed: () {
                      ThemeService().switchTheme();
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.lightbulb,
                      size: 28,
                    )),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_outlined,
                    size: 32,
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.sliders,
                      size: 32,
                    ))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
