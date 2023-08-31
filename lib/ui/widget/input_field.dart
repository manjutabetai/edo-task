import 'package:edo_task/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final bool isStar;

  const MyInputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.isStar = false,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: MyTextStyle.main,
              ),
              if (isStar)
                const Icon(
                  Icons.star_rate_rounded,
                  size: 16,
                  color: MyColor.red,
                )
            ],
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 4.0),
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode ? MyColor.grey : MyColor.dark,
                    controller: controller,
                    style: MyTextStyle.main,
                    decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: MyTextStyle.main,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.scaffoldBackgroundColor)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.scaffoldBackgroundColor))),
                  ),
                ),
                if (widget != null)
                  Container(
                    child: widget,
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
