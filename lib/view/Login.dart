import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../my_icons_icons.dart';
import '../widget/CustomTextField.dart';
import 'Home.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  final CollectionReference plants;
  final CollectionReference devices;
  final CollectionReference users;
  const Login(
      {super.key,
      required this.plants,
      required this.devices,
      required this.users});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  var form = GlobalKey<FormState>();
  String token = "";

  Color colorAlertError = Color(0xffC72929);
  Color noError = Colors.transparent;
  String _alert = "Dados incorretos";
  bool _alertFlag = false;

  getId() async {
    final tokenSave = await SharedPreferences.getInstance();
    setState(() {
      token = tokenSave.getString("token")!;
    });
  }

  saveValue() async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    final tokenSave = await SharedPreferences.getInstance();
    await tokenSave.setString("token", uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0Xffffffff),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            const Text(
              "Happy Plants",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 24,
                  color: Color(0xff255A46),
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 44,
            ),
            Form(
                child: Column(
              key: form,
              children: [
                CustomTextField(
                  textInputType: TextInputType.emailAddress,
                  textEditingController: email,
                  label: "E-mail",
                  controller: (TextEditingController value) => email = value,
                  hint: "josefernando21@gmail.com",
                  password: false,
                ),
                CustomTextField(
                  textEditingController: senha,
                  label: "Senha",
                  controller: (TextEditingController value) => senha = value,
                  hint: "********",
                  password: true,
                ),
              ],
            )),
            Container(
              margin: const EdgeInsets.only(right: 24, left: 24),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
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
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Esqueceu a senha?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: 'Quicksand',
                            fontSize: 12,
                            color: Color(0xff081510),
                            fontWeight: FontWeight.w700),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 370,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xff00804F)),
                      padding: const MaterialStatePropertyAll(
                          EdgeInsets.only(top: 24, bottom: 24)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)))),
                  onPressed: () {
                    if (email.text.isNotEmpty && senha.text.isNotEmpty) {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: senha.text)
                          .then((res) {
                        saveValue();
                        getId();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      plants: widget.plants,
                                      devices: widget.devices,
                                      users: widget.users,
                                      token: token,
                                    )));
                      }).catchError((e) {
                        switch (e.code) {
                          case 'invalid-email':
                            setState(() {
                              _alert = "Dados incorretos";
                              _alertFlag = true;
                            });
                            break;
                          case 'user-not-found':
                            setState(() {
                              _alert = "Usuário não encontrado";
                              _alertFlag = true;
                            });
                            break;
                          case 'wrong-password':
                            setState(() {
                              _alert = "Dados incorretos";
                              _alertFlag = true;
                            });
                            break;
                        }
                      });
                    } else {
                      setState(() {
                        _alert = "Preencha todos os campos";
                        _alertFlag = true;
                      });
                    }
                  },
                  child: const Text(
                    "ENTRAR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 2,
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "ou",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 12,
                color: Color(0xff255A46),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            IconButton(const Color(0xff4267B2), "Entrar com o facebook",
                MyIcons.facebook, () {}),
            const SizedBox(
              height: 10,
            ),
            IconButton(const Color(0xff4285F4), "Entrar com o google",
                MyIcons.google, () {}),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Não possui uma conta?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
                color: Color(0xff255A46),
                fontWeight: FontWeight.w400,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Register(
                              plants: widget.plants,
                              devices: widget.devices,
                              users: widget.users)));
                },
                child: const Text(
                  "Faça seu Cadastro",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    color: Color(0xff255A46),
                    fontWeight: FontWeight.w700,
                  ),
                )),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox IconButton(
      Color color, String text, IconData icon, Function function) {
    return SizedBox(
      width: 370,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(color),
              padding: const MaterialStatePropertyAll(
                  EdgeInsets.only(top: 24, bottom: 24)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
          onPressed: function(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          )),
    );
  }
}
