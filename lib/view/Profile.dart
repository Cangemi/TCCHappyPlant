import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:happy_plant/view/Login.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/CustomTextField.dart';
import '../widget/textShaker.dart';

class Profile extends StatefulWidget {
  final CollectionReference plants;
  final CollectionReference devices;
  final CollectionReference users;
  const Profile({
    super.key,
    required this.plants,
    required this.devices,
    required this.users,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nome = TextEditingController();
  TextEditingController data = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController confirmacaoSenha = TextEditingController();
  Color colorAlertError = Color(0xffC72929);
  Color noError = Colors.transparent;
  String _alert = "As senhas estão diferentes";
  bool _alertFlag = false;

  String _nome = "";
  String _data = "";
  String _token = "";
  String _email = "";

  var form = GlobalKey<FormState>();

  getUserData() async {
    // var uid = FirebaseAuth.instance.currentUser!.uid.toString();
    final tokenSave = await SharedPreferences.getInstance();
    String? token = await tokenSave.getString("token");
    _token = token!;
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: token)
        .get()
        .then((q) {
      setState(() {
        if (q.docs.isNotEmpty) {
          _nome = q.docs[0].data()['nome'];
          _data = q.docs[0].data()['nascimento'];
          _email = FirebaseAuth.instance.currentUser!.email.toString();
        } else {
          _nome = "Erro";
        }
      });
    });
  }

  void updateAccount() async {
    FirebaseFirestore.instance.collection('users').doc(_token).set({
      'uid': _token,
      'nome': nome.text.isEmpty ? _nome : nome.text,
      'nascimento': data.text.isEmpty ? _data : data.text,
    });
    if (email.text.isNotEmpty) {
      await FirebaseAuth.instance.currentUser
          ?.updateEmail(email.text)
          .then((res) {})
          .catchError((e) {
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
        }
      });
    }
  }

  message(String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      shape: const Border(top: BorderSide(color: Color(0xff00804F), width: 3)),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 16,
            color: Color(0xff081510),
            fontWeight: FontWeight.w700),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0Xffffffff),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0Xffffffff),
        centerTitle: true,
        title: const Text(
          "Happy Plants",
          style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 24,
              color: Color(0xff255A46),
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff081510),
              size: 20,
            )),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 30),
            child: IconButton(
                onPressed: () async {
                  final tokenSave = await SharedPreferences.getInstance();
                  await tokenSave.setString("token", '');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login(
                                plants: widget.plants,
                                devices: widget.devices,
                                users: widget.users,
                              )));
                },
                icon: const Icon(
                  Icons.logout,
                  color: Color(0xff081510),
                  size: 40,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            Text(
              "Olá, $_nome",
              style: const TextStyle(
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
                  hint: _nome,
                  password: false,
                ),
                CustomTextField(
                  textEditingController: data,
                  label: "Data de nascimento",
                  controller: (TextEditingController value) => data = value,
                  hint: _data,
                  password: false,
                  mask: 2,
                  textInputType: TextInputType.number,
                ),
                CustomTextField(
                  textInputType: TextInputType.emailAddress,
                  textEditingController: email,
                  label: "E-mail",
                  controller: (TextEditingController value) => email = value,
                  hint: _email,
                  password: false,
                ),
              ],
            )),
            Container(
              margin: const EdgeInsets.only(left: 24),
              child: TextShaker(
                text: _alert,
                textColor: _alertFlag ? colorAlertError : noError,
              ),
            ),
            const SizedBox(
              height: 25,
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
                  updateAccount();
                  message("Dados atualizados!");
                },
                child: const Text(
                  "ATUALIZAR",
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
              height: 10,
            ),
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(
                          email: email.text.isEmpty ? _email : email.text)
                      .then((res) {
                    message("Email enviado.");
                  }).catchError((e) {
                    switch (e.code) {
                      case "invalid-email":
                        setState(() {
                          _alert = "Endereço de e-mail inválido";
                          _alertFlag = true;
                        });
                        break;
                      case "user-not-found":
                        setState(() {
                          _alert =
                              "Nenhum usuário encontrado com esse endereço de e-mail";
                          _alertFlag = true;
                        });
                        break;
                      default:
                        setState(() {
                          _alert = "Ocorreu um erro ao tentar enviar o e-mail.";
                          _alertFlag = true;
                        });
                        break;
                    }
                  });
                  message("Email para alteração de senha enviado!");
                },
                child: const Text(
                  "Trocar Senha",
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
