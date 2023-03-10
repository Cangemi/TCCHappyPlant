import 'package:flutter/material.dart';

import 'Login.dart';
import 'Register.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0Xffffffff),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            const Text(
              "Happy Plants",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 40,
                  color: Color(0xff255A46),
                  fontWeight: FontWeight.w700),
            ),
            const Image(
              image: AssetImage("images/girl.jpg"),
            ),
            const Text(
              "Saúde para\nsuas plantinhas",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 24,
                color: Color(0xff255A46),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 8,
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Register()));
                },
                child: const Text(
                  "INICIAR",
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
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
            )
          ],
        )),
      ),
    );
  }
}
