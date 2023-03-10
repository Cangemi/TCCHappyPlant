import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'view/Home.dart';

import 'view/IntroScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CollectionReference plants = FirebaseFirestore.instance.collection('plants');
  CollectionReference devices =
      FirebaseFirestore.instance.collection('devices');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final tokenSave = await SharedPreferences.getInstance();
  String? token = tokenSave.getString("token");

  runApp(MaterialApp(
    home: token == null || token == ''
        ? const IntroScreen()
        : Home(
            plants: plants,
            devices: devices,
            users: users,
          ),
  ));
}
