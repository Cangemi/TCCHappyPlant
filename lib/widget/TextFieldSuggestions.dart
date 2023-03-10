import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldSuggestions extends StatefulWidget {
  final List<String> list;
  final Function returnedValue;
  final Function onTap;
  final double height;
  final String labelText;
  final Color textSuggetionsColor;
  final Color suggetionsBackgroundColor;
  final Color outlineInputBorderColor;
  const TextFieldSuggestions(
      {Key? key,
      required this.list,
      required this.labelText,
      required this.textSuggetionsColor,
      required this.suggetionsBackgroundColor,
      required this.outlineInputBorderColor,
      required this.returnedValue,
      required this.onTap,
      required this.height})
      : super(key: key);

  @override
  _TextFieldSuggestionsState createState() => _TextFieldSuggestionsState();
}

class _TextFieldSuggestionsState extends State<TextFieldSuggestions> {
  int flag = 0;
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    flag = 0;
  }

  @override
  void dispose() {
    super.dispose();
    //widget.list.clear();
    flag = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (flag == 0) {
      height = widget.height;
    }

    // double height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 24, bottom: 20, right: 24),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue value) {
          widget.returnedValue(value.text.toLowerCase());
          // When the field is empty
          if (value.text.isEmpty) {
            return [];
          }
          // The logic to find out which ones should appear
          return widget.list
              .where((suggestion) => suggestion.contains(value.text));
        },
        // onSelected: (value) {
        //   setState(() {
        //     //_selectedAnimal = value;
        //   });
        // },
        fieldViewBuilder: (BuildContext context, textEditingController,
            FocusNode focusNode, VoidCallback onFieldSubmitted) {
          return Container(
            padding: const EdgeInsets.only(left: 10, top: 0, bottom: 0),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff255A46)),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: textEditingController,
              focusNode: focusNode,
              textCapitalization: TextCapitalization.sentences,
              //scrollPadding: const EdgeInsets.only(bottom: 200),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.labelText,
                hintStyle: const TextStyle(
                  color: Color(0xff255A46),
                  fontFamily: 'Quicksand',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                fillColor: widget.outlineInputBorderColor,
              ),
              onSubmitted: (String value) {
                if (value.isNotEmpty) {
                  onFieldSubmitted();
                  widget
                      .returnedValue(textEditingController.text.toLowerCase());
                }
                setState(() {
                  flag = 1;
                  height = 0;
                });
                FocusScope.of(context).unfocus();
              },
              onChanged: (text) {
                setState(() {
                  flag = 0;
                });
              },
              onTap: () {
                widget.onTap();
              },
            ),
          );
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          return Container(
            margin: const EdgeInsets.only(right: 93),
            child: Align(
              alignment: Alignment.topCenter,
              child: Material(
                elevation: 2,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: Colors.white,
                child: SizedBox(
                  height: options.length == 1
                      ? 85
                      : options.length == 2
                          ? 150
                          : 200,
                  child: ListView.builder(
                      // shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            onSelected(option);
                            widget.returnedValue(option.toLowerCase());
                            FocusScope.of(context).unfocus();
                            setState(() {
                              flag = 1;
                              height = 0;
                            });
                          },
                          child: ListTile(
                            title: Text(
                              option,
                              maxLines: 3,
                              style: const TextStyle(
                                  color: Color(0xff255A46),
                                  fontFamily: 'Quicksand',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
