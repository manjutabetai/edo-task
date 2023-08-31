import 'package:edo_task/ui/theme.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: MyColor.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label,
              style: MyTextStyle.main.copyWith(color: MyColor.white))),
    );
  }
}
