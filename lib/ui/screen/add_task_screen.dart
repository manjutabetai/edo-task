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
  DateTime _selectedDate = DateTime.now();
  int _selectedRemind = 3;
  String _selectedRepeat = "なし";

  int _selectedColor = 0;

  final List<Widget> _remindList = [
    const Row(
      children: [Icon(Icons.alarm_sharp), Text('なし')],
    ),
    const Row(
      children: [Icon(Icons.alarm_sharp), Text('前日(朝9:00)')],
    ),
    const Row(
      children: [Icon(Icons.alarm_sharp), Text('前々日(朝9:00)')],
    ),
    const Row(
      children: [Icon(Icons.alarm_sharp), Text('カスタム')],
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
            const MyInputField(title: 'task', hint: 'task', isStar: true),

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
            const MyInputField(title: 'Memo', hint: "Memoを入力"),

            // * remind
            MyInputField(
              title: 'remind',
              hint: '通知',
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
                    _selectedRemind = int.parse(value!);
                  });
                },
              ),
            ),
            // * リピート
            MyInputField(
              title: 'Repeat',
              hint: "リピート",
              widget: DropdownButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                iconSize: 32,
                style: MyTextStyle.main,
                underline: Container(height: 0),
                items: _repeatList.map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRepeat = value!;
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
            Align(
              alignment: Alignment.topRight,
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
                    style:
                        MyTextStyle.main.copyWith(fontWeight: FontWeight.w700),
                  )),
            ),
          ]),
        ),
      ),
    );
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
