import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function controller;
  final String label;
  final String hint;
  final bool password;
  final TextInputType? textInputType;
  final int? mask;
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.label,
      required this.hint,
      required this.password,
      required this.textEditingController,
      this.textInputType,
      this.mask})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool password;
  IconData view = Icons.remove_red_eye_outlined;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    password = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    //TextEditingController textEditingController = TextEditingController();
    final maskPhone = MaskTextInputFormatter(
        mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')});
    final maskDate = MaskTextInputFormatter(
        mask: " ##/##/####", filter: {"#": RegExp(r'[0-9]')});
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              widget.label,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0Xff081510),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff255A46)),
              borderRadius: BorderRadius.circular(15)),
          margin:
              const EdgeInsets.only(top: 5, left: 24, bottom: 20, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: TextFormField(
                onTap: () {
                  widget.controller(widget.textEditingController);
                },
                inputFormatters: widget.mask == 1
                    ? [maskPhone]
                    : widget.mask == 2
                        ? [maskDate]
                        : [],
                keyboardType: widget.textInputType ?? TextInputType.text,
                obscureText: password,
                style: const TextStyle(
                    color: Color(0xff255A46),
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w400),
                cursorColor: const Color(0xff255A46),
                controller: widget.textEditingController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(left: 10, top: 0, bottom: 0),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff255A46),
                  ),
                  focusedBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                ),
              )),
              widget.label == "Senha"
                  ? IconButton(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(bottom: 3, right: 20),
                      onPressed: () {
                        if (password == true) {
                          setState(() {
                            password = false;
                            view = Icons.remove_red_eye_sharp;
                          });
                        } else {
                          setState(() {
                            password = true;
                            view = Icons.remove_red_eye_outlined;
                          });
                        }
                      },
                      icon: Icon(
                        view,
                        weight: 400,
                        size: 32,
                        color: const Color(0xff255A46),
                      ),
                    )
                  : Container()
            ],
          ),
        )
      ],
    );
  }
}
