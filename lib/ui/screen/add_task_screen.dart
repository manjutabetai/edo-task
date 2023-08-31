import 'package:edo_task/controller/task_controller.dart';
import 'package:edo_task/model/task';
import 'package:edo_task/ui/theme.dart';
import 'package:edo_task/ui/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());

  // db 保存 //
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int _selectedRemind = 0;

  int _selectedRepeat = 0;

  int _selectedColor = 0;

  // ---------- //

  final List<Widget> _remindList = [
    Row(
      children: [
        const Icon(Icons.alarm_sharp),
        Text(
          'なし',
          style: MyTextStyle.main
              .copyWith(color: Get.isDarkMode ? MyColor.white : MyColor.dark),
        )
      ],
    ),
    Row(
      children: [
        const Icon(Icons.alarm_sharp),
        Text(
          '前日(朝9:00)',
          style: MyTextStyle.main
              .copyWith(color: Get.isDarkMode ? MyColor.white : MyColor.dark),
        )
      ],
    ),
    Row(
      children: [
        const Icon(Icons.alarm_sharp),
        Text('前々日(朝9:00)',
            style: MyTextStyle.main
                .copyWith(color: Get.isDarkMode ? MyColor.white : MyColor.dark))
      ],
    ),
    Row(
      children: [
        const Icon(Icons.alarm_sharp),
        Text('カスタム',
            style: MyTextStyle.main
                .copyWith(color: Get.isDarkMode ? MyColor.white : MyColor.dark))
      ],
    ),
  ];
  final List<String> _repeatList = ["なし", "毎日", "毎週", "毎月", "毎年"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            _appBar(),
            const SizedBox(
              height: 32,
            ),
            // * task field
            MyInputField(
              title: 'task',
              hint: 'task',
              isStar: true,
              controller: _titleController,
            ),

            // * date field
            MyInputField(
              title: 'Date',
              hint: DateFormat.Md().format(_selectedDate),
              widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(Icons.calendar_view_month_outlined)),
            ),

            // * memo
            MyInputField(
              title: 'Memo',
              hint: "Memoを入力",
              controller: _memoController,
            ),

            // * remind
            MyInputField(
              title: 'remind',
              hint: _getRemindLabel(_selectedRemind),
              widget: DropdownButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                iconSize: 32,
                style: MyTextStyle.main,
                underline: Container(height: 0),
                items: _remindList
                    .asMap()
                    .map((index, value) {
                      return MapEntry(
                        index,
                        DropdownMenuItem(
                          value: index.toString(),
                          child: value,
                        ),
                      );
                    })
                    .values
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    print(value);

                    _selectedRemind = int.parse(value.toString());
                  });
                },
              ),
            ),
            // * リピート
            MyInputField(
              title: 'Repeat',
              hint: _getRepeatLabel(_selectedRepeat),
              widget: DropdownButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                iconSize: 32,
                style: MyTextStyle.main,
                underline: Container(height: 0),
                items: _repeatList
                    .asMap()
                    .map((index, value) {
                      return MapEntry(
                          index,
                          DropdownMenuItem(
                              value: index,
                              child: Text(
                                value,
                                style: MyTextStyle.main.copyWith(
                                    color: Get.isDarkMode
                                        ? MyColor.white
                                        : MyColor.dark),
                              )));
                    })
                    .values
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRepeat = int.parse(value.toString());
                  });
                },
              ),
            ),

            // * color
            // Color
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 16.0),
              child: _colorPallet(),
            ),

            _addButton(),
          ]),
        ),
      ),
    );
  }

  Align _addButton() {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () => _addTask(),
        child: Container(
            alignment: Alignment.center,
            width: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: MyColor.blue,
                borderRadius: BorderRadius.circular(12),
                border: Border.all()),
            child: Text(
              '+ Add',
              style: MyTextStyle.main
                  .copyWith(fontWeight: FontWeight.w700, color: MyColor.white),
            )),
      ),
    );
  }

  void _addTask() {
    if (_titleController.text.isNotEmpty) {
      _addTaskToDB();

      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar('エラー', 'タスクが入力されていません！',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: MyColor.red,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  String _getRemindLabel(int value) {
    switch (value) {
      case 0:
        return 'なし';
      case 1:
        return '前日(朝9:00)';
      case 2:
        return '前々日(朝9:00)';
      case 3:
        return 'カスタム';
      default:
        return 'なし'; // デフォルト値の設定
    }
  }

  String _getRepeatLabel(int value) {
    switch (value) {
      case 0:
        return 'なし';
      case 1:
        return '毎日';
      case 2:
        return '毎週';
      case 3:
        return '毎月';
      case 4:
        return '毎年';
      default:
        return 'なし'; // デフォルト値の設定
    }
  }

  _addTaskToDB() async {
    Task task = Task(
      color: _selectedColor,
      date: DateFormat.yMd().format(_selectedDate),
      memo: _memoController.text,
      title: _titleController.text,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      isCompleted: 0,
    );
    int id = await _taskController.addTask(task: task);
  }

  Column _colorPallet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Color",
          style: MyTextStyle.main,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? MyColor.yellow
                        : index == 1
                            ? MyColor.green
                            : MyColor.red,
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : Container()),
              ),
            );
          }),
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2024));
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {}
  }

  Row _appBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const Text(
          'Add Task',
          style: MyTextStyle.heading,
        )
      ],
    );
  }
}
