import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:happy_plant/view/Login.dart';
import 'package:intl/intl.dart';

import '../widget/CustomTextField.dart';

class Register extends StatefulWidget {
  final CollectionReference plants;
  final CollectionReference devices;
  final CollectionReference users;
  const Register(
      {super.key,
      required this.plants,
      required this.devices,
      required this.users});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nome = TextEditingController();
  TextEditingController data = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController confirmacaoSenha = TextEditingController();
  Color colorAlertError = Color(0xffC72929);
  Color noError = Colors.transparent;
  String _alert = "As senhas estão diferentes";
  bool _alertFlag = false;

  var form = GlobalKey<FormState>();

  void createAccount(String nome, String data, String email, String senha,
      String confirmacaoSenha) {
    if (nome.isEmpty ||
        data.isEmpty ||
        email.isEmpty ||
        senha.isEmpty ||
        confirmacaoSenha.isEmpty) {
      setState(() {
        _alertFlag = true;
        _alert = "Preencha todos os campos";
      });
    } else {
      if (confirmacaoSenha != senha) {
        _alert = "A senha está incorreta";
      } else {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: senha)
            .then((res) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid.toString())
              .set({
            'uid': res.user!.uid.toString(),
            'nome': nome,
            'nascimento': data,
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login(
                      plants: widget.plants,
                      devices: widget.devices,
                      users: widget.users)));
        }).catchError((e) {
          switch (e.code) {
            case 'email-already-in-use':
              setState(() {
                _alert = "Esse Email já foi cadastrado";
              });
              break;
            case 'invalid-email':
              setState(() {
                _alert = "O formato do email é inválido";
                _alertFlag = true;
              });
              break;
            case 'weak-password':
              setState(() {
                _alert = "A senha deve conter 6 ou mais caracteres";
                _alertFlag = true;
              });
              break;
          }
        });
      }
    }
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
              "Crie sua conta",
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
                  textEditingController: nome,
                  label: "Nome",
                  controller: (TextEditingController value) => nome = value,
                  hint: "José Fernando da Silva",
                  password: false,
                ),
                CustomTextField(
                  textEditingController: data,
                  label: "Data de nascimento",
                  controller: (TextEditingController value) => data = value,
                  hint: "DD/MM/AAAA",
                  password: false,
                  mask: 2,
                  textInputType: TextInputType.number,
                ),
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
                CustomTextField(
                  textEditingController: confirmacaoSenha,
                  label: "Confirmar senha",
                  controller: (TextEditingController value) =>
                      confirmacaoSenha = value,
                  hint: "********",
                  password: true,
                ),
              ],
            )),
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
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(Color(0xff00804F)),
                    padding: const MaterialStatePropertyAll(
                        EdgeInsets.fromLTRB(115.5, 24, 115.5, 24)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
                onPressed: () {
                  createAccount(nome.text, data.text, email.text, senha.text,
                      confirmacaoSenha.text);
                },
                child: const Text(
                  "CRIAR CONTA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 2,
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                  ),
                )),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Já possui uma conta?",
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
                          builder: (context) => Login(
                              plants: widget.plants,
                              devices: widget.devices,
                              users: widget.users)));
                },
                child: const Text(
                  "Faça o Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    color: Color(0xff255A46),
                    fontWeight: FontWeight.w700,
                  ),
                )),
            const SizedBox(
              height: 60,
            ),
            RichText(
              text: TextSpan(
                text: 'Criando a conta você concorda com os ',
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 12,
                  color: Color(0xff255A46),
                  fontWeight: FontWeight.w400,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Termos de uso',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      color: Color(0xff255A46),
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'e com as ',
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 12,
                  color: Color(0xff255A46),
                  fontWeight: FontWeight.w400,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Politicas de privacidade.',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      color: Color(0xff255A46),
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
