import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_plant/models/Devices.dart';
import 'package:happy_plant/widget/TextFieldSuggestions.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Plants.dart';
import '../widget/CustomTextField.dart';
import '../widget/textShaker.dart';

class UpdateDevice extends StatefulWidget {
  final Devices device;
  final Function onClose;
  final List<Plants> list;
  const UpdateDevice(
      {super.key,
      required this.onClose,
      required this.list,
      required this.device});
  @override
  State<UpdateDevice> createState() => _UpdateDeviceState();
}

class _UpdateDeviceState extends State<UpdateDevice> {
  TextEditingController nome = TextEditingController();
  TextEditingController local = TextEditingController();
  TextEditingController mac = TextEditingController();

  String _nome = "";
  String _local = "";
  String _mac = "";
  String _otherPlant = "";

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
    _nome = widget.device.nome;
    _local = widget.device.local;
    _mac = widget.device.mac;
    _otherPlant = widget.device.especie;
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
                  labelText: _otherPlant,
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
                hint: _nome,
                password: false,
              ),
              CustomTextField(
                textEditingController: local,
                label: "Local da sua planta",
                controller: (TextEditingController value) => local = value,
                hint: _local,
                password: false,
              ),
              CustomTextField(
                textEditingController: mac,
                label: "Numero MAC",
                controller: (TextEditingController value) => mac = value,
                hint: _mac,
                password: false,
                mask: 3,
              ),
              Container(
                margin: const EdgeInsets.only(left: 24),
                child: TextShaker(
                  text: _alert,
                  textColor: _alertFlag ? colorAlertError : noError,
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
                    Plants selected = widget.list.firstWhere((plant) {
                      return plant.nome.toLowerCase() ==
                          (_plant.isEmpty ? _otherPlant : _plant);
                    });
                    String? token = tokenSave.getString("token");
                    FirebaseFirestore.instance
                        .collection('devices')
                        .where('uid', isEqualTo: token)
                        .get()
                        .then((querySnapshot) {
                      querySnapshot.docs.forEach((doc) {
                        doc.reference.update({
                          'uid': token,
                          'nome': nome.text.isEmpty ? _nome : nome.text,
                          'local': local.text.isEmpty ? _local : local.text,
                          'especie': _plant.isEmpty ? _otherPlant : _plant,
                          'mac': mac.text.isEmpty ? _mac : mac.text,
                          'tempoSemIrrigacao': selected.tempoSemIrrigacao,
                          'minAgua': selected.doubleMinAgua.toString(),
                          'temperatura': "0",
                          'umidade': "0",
                          'luz': "0",
                          'awaits': "0",
                          'irrigacao': false,
                          'time': DateTime.now()
                        }).then((_) {
                          print('Documento atualizado com sucesso!');
                        }).catchError((error) {
                          print('Erro ao atualizar o documento: $error');
                        });
                      });
                    });

                    widget.onClose();
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
