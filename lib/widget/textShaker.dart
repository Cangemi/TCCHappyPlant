import 'package:flutter/material.dart';
import 'dart:math';

class TextShaker extends StatefulWidget {
  final String text;
  final Color textColor;
  const TextShaker({super.key, required this.text, required this.textColor});

  @override
  State<TextShaker> createState() => _TextShakerState();
}

class _TextShakerState extends State<TextShaker>
    with SingleTickerProviderStateMixin {
  double space = 0;
  int flag = 0;

  void changeSpace() async {
    await Future.delayed(const Duration(milliseconds: 50), () {
      if (space == 0) {
        setState(() {
          space = 5;
        });
      } else {
        setState(() {
          space = 0;
        });
      }
    });
    flag++;
  }

  @override
  Widget build(BuildContext context) {
    if (flag <= 5) {
      changeSpace();
    } else {
      flag = 0;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      padding: EdgeInsets.only(left: space),
      child: Row(
        children: [
          Icon(
            Icons.cancel_outlined,
            color: widget.textColor,
            size: 12,
          ),
          Text(
            widget.text,
            style: TextStyle(
                color: widget.textColor,
                fontFamily: 'Quicksand',
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
