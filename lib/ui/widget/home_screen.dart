import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:edo_task/service/theme_service.dart';
import 'package:edo_task/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
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
            _appBar(),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: DatePicker(
                  DateTime.now(),
                  locale: "ja_JP",
                  height: 100,
                  width: 70,
                  selectionColor: MyColor.blue,
                  initialSelectedDate: DateTime.now(),
                  selectedTextColor: MyColor.white,
                  dateTextStyle: MyTextStyle.medium,
                  dayTextStyle: MyTextStyle.medium,
                  monthTextStyle: MyTextStyle.medium,
                  onDateChange: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                )),
          ]),
        ),
      ),
    );
  }

  Row _appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text(
          'Tasks',
          style: MyTextStyle.heading,
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
    );
  }
}
