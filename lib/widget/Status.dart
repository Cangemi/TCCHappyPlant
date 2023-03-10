import 'dart:async';

import 'package:flutter/material.dart';

class Status extends StatefulWidget {
  Status({
    super.key,
    required double value,
    required Color color,
    required String label,
    required String text1,
    required String text2,
    required String text3,
    required Function onTap,
  })  : _value = value,
        _color = color,
        _label = label,
        _text1 = text1,
        _text2 = text2,
        _text3 = text3,
        _onTap = onTap;

  final double _value;
  final Color _color;
  final String _label;
  final String _text1;
  final String _text2;
  final String _text3;
  final Function _onTap;

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            widget._label,
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
                color: Color(0xff081510),
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget._text1,
              style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 12,
                  color: Color(0xff081510),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              widget._text2,
              style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 12,
                  color: Color(0xff081510),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              widget._text3,
              style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 12,
                  color: Color(0xff081510),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Stack(
          children: [
            SliderTheme(
              key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
              data: const SliderThemeData(
                trackHeight: 16,
                thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 9.1, elevation: 0, pressedElevation: 0),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
              ),
              child: Slider(
                value: widget._value,
                min: 0,
                max: 100,
                onChanged: (value) {},
                activeColor: widget._color,
                inactiveColor: const Color(0xFFF4F4F4),
              ),
            ),
            GestureDetector(
              onTap: () {
                widget._onTap();
              },
              child: Container(
                width: double.infinity,
                height: 20,
                color: Colors.transparent,
              ),
            )
          ],
        )
      ]),
    );
  }
}
