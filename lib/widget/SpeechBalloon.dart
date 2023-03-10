import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SpeechBalloon extends StatelessWidget {
  const SpeechBalloon(
      {super.key,
      required List text,
      required Function callBack,
      required String name})
      : _text = text,
        _name = name,
        _callBack = callBack;

  final List _text;
  final String _name;
  final Function _callBack;

  @override
  Widget build(BuildContext context) {
    List<AnimatedText> text = [];
    for (var item in _text) {
      text.add(TyperAnimatedText(item.replaceAll("\$_name", _name),
          textAlign: TextAlign.center));
    }
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 110),
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(color: Colors.black, width: 1),
            shape: BoxShape.rectangle,
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 12,
                color: Color(0xff255A46),
                fontWeight: FontWeight.w500),
            child: AnimatedTextKit(
              key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
              pause: const Duration(milliseconds: 2000),
              totalRepeatCount: 1,
              isRepeatingAnimation: false,
              animatedTexts: text,
              onFinished: () {
                _callBack();
              },
              onTap: () {},
            ),
          ),
        ),
        Positioned.fill(
          top: -1.9,
          //left: 4.0 * (_text.length >= 34 ? 42.5 : _text.length),
          child: Align(
            alignment: Alignment.topCenter,
            child: CustomPaint(
              size: const Size(13, 13),
              painter: _TrianglePainter(),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  _TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height);
    //..close();

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
