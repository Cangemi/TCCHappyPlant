import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:happy_plant/widget/textShaker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  nextpage() {
    saveValue(FirebaseAuth.instance.currentUser!.uid.toString());
    getId();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => Home(
                plants: widget.plants,
                devices: widget.devices,
                users: widget.users,
                token: token,
              )),
      (Route<dynamic> route) => false,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    await googleSignIn.signOut();

    // Tente fazer login com uma conta do Google.
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    // Obtenha as credenciais de autenticação do Google.
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    // Crie as credenciais de autenticação do Firebase.
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    // Verifique se o e-mail do usuário já existe no Firebase.
    final List firebaseUser = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(googleSignInAccount!.email);
    if (firebaseUser.isNotEmpty) {
      // Faça login no Firebase com as credenciais do Google.
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      nextpage();
      return userCredential;
    } else {
      // O usuário não existe no Firebase, trate o erro aqui.
      setState(() {
        _alert = "Usuario não esta cadastrado.";
        _alertFlag = true;
      });
      return null;
    }
  }

  getId() async {
    final tokenSave = await SharedPreferences.getInstance();
    setState(() {
      token = tokenSave.getString("token")!;
    });
  }

  saveValue(String uid) async {
    final tokenSave = await SharedPreferences.getInstance();
    await tokenSave.setString("token", uid);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0Xffffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
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
                      child: TextShaker(
                        text: _alert,
                        textColor: _alertFlag ? colorAlertError : noError,
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          if (email.text.isNotEmpty) {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email.text)
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
                                    _alert =
                                        "Ocorreu um erro ao tentar enviar o e-mail.";
                                    _alertFlag = true;
                                  });
                                  break;
                              }
                            });
                          } else {
                            setState(() {
                              _alert = "Insira um email";
                              _alertFlag = true;
                            });
                          }
                        },
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
                height: 25,
              ),
              SizedBox(
                width: 370,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Color(0xff00804F)),
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.only(top: 24, bottom: 24)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                    onPressed: () {
                      if (email.text.isNotEmpty && senha.text.isNotEmpty) {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email.text, password: senha.text)
                            .then((res) {
                          nextpage();
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
                            case 'unknown':
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
              IconButton(
                  const Color(0xff4285F4),
                  "Entrar com o google",
                  MyIcons.google,
                  () => () async {
                        try {
                          final UserCredential? userCredential =
                              await signInWithGoogle();
                        } catch (e) {
                          // Erro ao fazer login com o Google, trate o erro aqui.
                          print(e.toString());
                        }
                      }),
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
