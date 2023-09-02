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
import 'dart:ui' as ui;

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

                  return Stack(
                    children: [
                      ClipRect(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: ShapeDecoration(
                              // color: _getTaskColor(task.color ?? 0),
                              gradient: RadialGradient(
                                radius: 1.6,
                                center: Alignment.topLeft,
                                colors: [
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      task.title ?? '',
                                      style: MyTextStyle.medium.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.edit_note_rounded,
                                          size: 32,
                                        ))
                                  ],
                                ),

                                // * memo
                                // if (task.memo != '')
                                //   Container(
                                //     margin: const EdgeInsets.only(left: 20),
                                //     child: Text(
                                //       task.memo ?? '',
                                //       style: MyTextStyle.main,
                                //     ),
                                //   ),
                                // const SizedBox(
                                //   height: 12,
                                // ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.alarm_sharp,
                                      color: MyColor.blue,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(_getRemindLabel(task.remind ?? 0)),
                                  ],
                                ),
                                const SizedBox(
                                  width: 32,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.repeat,
                                      color: MyColor.blue,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(_getRepeatLabel(task.remind ?? 0)),
                                    const SizedBox(width: 20),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // * isCompleted
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 150,
                          decoration: const BoxDecoration(
                              color: MyColor.blue,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(12),
                                  topLeft: Radius.circular(12))),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: Text(
                            task.isCompleted == 0 ? 'TODO' : '完了',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  );
                });
          })),

          // add button
          MyButton(
            label: '+ add new task',
            onTap: () => Get.to(const AddTaskScreen()),
          ),
        ]),
      ),
    );
  }

  _getTaskColor(int value) {
    return {
          0: MyColor.yellow,
          1: MyColor.green,
          2: MyColor.red,
        }[value] ??
        MyColor.yellow;
  }

  String _getRepeatLabel(int value) {
    return {
          0: 'なし',
          1: '毎日',
          2: '毎週',
          3: '毎月',
          4: '毎年',
        }[value] ??
        'なし';
  }

  String _getRemindLabel(int value) {
    return {
          0: 'なし',
          1: '前日(朝9:00)',
          2: '前々日(朝9:00)',
          3: 'カスタム',
        }[value] ??
        'なし';
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
