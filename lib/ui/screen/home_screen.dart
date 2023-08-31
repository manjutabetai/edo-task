import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:edo_task/controller/task_controller.dart';
import 'package:edo_task/model/task';
import 'package:edo_task/service/notification_services.dart';
import 'package:edo_task/service/theme_service.dart';
import 'package:edo_task/ui/screen/add_task_screen.dart';
import 'package:edo_task/ui/theme.dart';
import 'package:edo_task/ui/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  var notifyService;
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyService = NotifyService();
    notifyService.initializeNotification();
    notifyService.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          _appBar(),
          _calender(),
          Expanded(child: Obx(() {
            return ListView.builder(
                itemCount: _taskController.taskList.length,
                itemBuilder: (_, index) {
                  Task task = _taskController.taskList[index];
                  print(task.title);
                  return Text(task.title.toString());
                });
          })),
          // add button
          MyButton(
            label: '+ add new task',
            onTap: () => Get.to(const AddTaskScreen()),
          )
        ]),
      ),
    );
  }

  Container _calender() {
    return Container(
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
        ));
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
        IconButton(
            onPressed: () {
              NotifyService()
                  .displayNotification(title: '通知だよ', body: '毎日暑いのーー');
            },
            icon: const FaIcon(
              FontAwesomeIcons.seedling,
              size: 28,
            )),
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
