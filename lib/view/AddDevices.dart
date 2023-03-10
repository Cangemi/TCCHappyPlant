import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_plant/models/Devices.dart';
import 'package:happy_plant/widget/TextFieldSuggestions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Plants.dart';
import '../widget/CustomTextField.dart';

class AddDevices extends StatefulWidget {
  final Function onClose;
  final List<Plants> list;
  const AddDevices({super.key, required this.onClose, required this.list});
  @override
  State<AddDevices> createState() => _AddDevicesState();
}

class _AddDevicesState extends State<AddDevices> {
  TextEditingController nome = TextEditingController();
  TextEditingController local = TextEditingController();
  TextEditingController mac = TextEditingController();

  String _plant = '';
  late List<String> _list;

  Color colorAlertError = Color(0xffC72929);
  Color noError = Colors.transparent;
  String _alert = "preencha todos os campos";
  bool _alertFlag = false;

  late final tokenSave;

  getToken() async {
    tokenSave = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _list = widget.list.map((plants) => plants.nome).toList();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, bottom: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: ListView(
            children: [
              TextFieldSuggestions(
                  list: _list,
                  labelText: "Tipo da planta",
                  textSuggetionsColor: const Color(0xff081510),
                  suggetionsBackgroundColor: Colors.white,
                  outlineInputBorderColor: const Color(0xff081510),
                  returnedValue: (String value) => _plant = value,
                  onTap: () {},
                  height: 200),
              CustomTextField(
                textEditingController: nome,
                label: "Nome da sua planta",
                controller: (TextEditingController value) => nome = value,
                hint: "Nome da planta",
                password: false,
              ),
              CustomTextField(
                textEditingController: local,
                label: "Local da sua planta",
                controller: (TextEditingController value) => local = value,
                hint: "Ex. Sala",
                password: false,
              ),
              CustomTextField(
                textEditingController: mac,
                label: "Numero MAC",
                controller: (TextEditingController value) => mac = value,
                hint: "MAC",
                password: false,
              ),
              Container(
                margin: const EdgeInsets.only(left: 24),
                child: Row(
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color: _alertFlag ? colorAlertError : noError,
                      size: 12,
                    ),
                    Text(
                      _alert,
                      style: TextStyle(
                          color: _alertFlag ? colorAlertError : noError,
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xff00804F)),
                      padding: const MaterialStatePropertyAll(
                          EdgeInsets.fromLTRB(20, 10, 20, 10)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)))),
                  onPressed: () {
                    if (nome.text.isEmpty ||
                        local.text.isEmpty ||
                        mac.text.isEmpty ||
                        _plant.isEmpty) {
                      setState(() {
                        _alertFlag = true;
                      });
                    } else {
                      Plants selected = widget.list.firstWhere((plant) {
                        return plant.nome.toLowerCase() == _plant;
                      });
                      String? token = tokenSave.getString("token");
                      FirebaseFirestore.instance
                          .collection('devices')
                          .doc()
                          .set({
                        'uid': token,
                        'nome': nome.text,
                        'local': local.text,
                        'especie': _plant,
                        'mac': mac.text,
                        'tempoSemIrrigacao': selected.tempoSemIrrigacao,
                        'temperatura': 0,
                        'umidade': 0,
                        'luz': 0,
                        'awaits': 0,
                        'irrigacao': false
                      });
                      widget.onClose();
                    }
                  },
                  child: const Text(
                    "Adicionar planta",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 16,
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xffffffff)),
                      padding: const MaterialStatePropertyAll(
                          EdgeInsets.fromLTRB(20, 10, 20, 10)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              side: const BorderSide(color: Color(0xff081510)),
                              borderRadius: BorderRadius.circular(30)))),
                  onPressed: () {
                    widget.onClose();
                  },
                  child: const Text(
                    "Cancelar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 16,
                      color: Color(0xff081510),
                      fontWeight: FontWeight.w500,
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
