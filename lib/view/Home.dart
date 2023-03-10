import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_plant/models/Users.dart';
import 'package:happy_plant/view/AddDevices.dart';
import 'package:happy_plant/view/PlantScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Devices.dart';
import '../models/Plants.dart';
import 'Login.dart';

class Home extends StatefulWidget {
  final CollectionReference plants;
  final CollectionReference devices;
  final CollectionReference users;
  const Home(
      {super.key,
      required this.plants,
      required this.devices,
      required this.users});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Plants> pList = [];

  String _token = "";
  late Query<Object?> _device;
  late DocumentSnapshot _user;
  late Users user;
  getPlants() async {
    QuerySnapshot qS = await widget.plants.get();
    for (DocumentSnapshot p in qS.docs) {
      Plants plants = Plants.fromJson(p.data() as Map<String, dynamic>, p.id);
      pList.add(plants);
    }
    _user = await widget.users.doc(_token).get();
    user = Users.fromJson(_user.data() as Map<String, dynamic>, _user.id);
  }

  saveValue() async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    final tokenSave = await SharedPreferences.getInstance();
    await tokenSave.setString("token", uid);
    String? token = await tokenSave.getString("token");
    setState(() {
      _token = token!;
    });
  }

  @override
  void initState() {
    super.initState();
    saveValue();
    getPlants();
  }

  @override
  Widget build(BuildContext context) {
    _device = widget.devices.where("uid", isEqualTo: _token);
    var height = MediaQuery.of(context).size.height;
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
            onPressed: () {},
            icon: const Icon(
              Icons.person_outline_outlined,
              color: Color(0xff081510),
              size: 40,
            )),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 30),
            child: IconButton(
                onPressed: () async {
                  final tokenSave = await SharedPreferences.getInstance();
                  await tokenSave.setString("token", '');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                icon: const Icon(
                  Icons.logout,
                  color: Color(0xff081510),
                  size: 40,
                )),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _device.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final dados = snapshot.requireData;
            if (dados.size <= 0) {
              return const Center(
                  child: Text(
                "Cadastre uma planta",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  color: Color(0xff255A46),
                  fontWeight: FontWeight.w700,
                ),
              ));
            } else {
              return Container(
                margin: const EdgeInsets.only(right: 24, left: 24, top: 61),
                child: ListView.builder(
                  itemCount: dados.size,
                  itemBuilder: (context, index) {
                    return cards(dados.docs[index]);
                  },
                ),
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
                child: Text(
              "Ocorreu um erro ao buscar os dados.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                color: Color(0xff255A46),
                fontWeight: FontWeight.w700,
              ),
            ));
          } else {
            _device = widget.devices.where("uid", isEqualTo: _token);
            return const Center(
                child: CircularProgressIndicator(color: Color(0xff255A46)));
          }
        },
      ),
      floatingActionButton: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  const MaterialStatePropertyAll(Color(0xff00804F)),
              padding: const MaterialStatePropertyAll(
                EdgeInsets.fromLTRB(70.5, 24, 70.5, 24),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: height * 0.2,
                          right: 24,
                          left: 24,
                          bottom: height * 0.2),
                      constraints: const BoxConstraints.expand(),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: AddDevices(
                        list: pList,
                        onClose: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                });
          },
          child: const Text(
            "Adicionar nova Planta",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 16,
              color: Color(0xffffffff),
              fontWeight: FontWeight.w700,
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Dismissible cards(item) {
    String image = "";
    Color color = const Color(0xffC72929);
    Devices d = Devices.fromJson(item.data() as Map<String, dynamic>, item.id);
    Plants selected = pList.firstWhere((plant) {
      return plant.nome.toLowerCase() == d.especie;
    });

    if (d.umidade < selected.minAgua || d.umidade > selected.maxAgua) {
      image = 'images/unhappy.gif';
      color = const Color(0xffC72929);
    } else if (d.luz < selected.minLuz || d.luz > selected.maxLuz) {
      image = 'images/unhappy.gif';
      color = const Color(0xffC72929);
    } else if (d.temperatura < selected.minTemperatura ||
        d.temperatura > selected.maxTemperatura) {
      image = 'images/unhappy.gif';
      color = const Color(0xffC72929);
    } else {
      image = 'images/happy.gif';
      color = const Color(0xff007F4F);
    }
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (e) {
        widget.devices.doc(d.id).delete();
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(16, 16, 18.5, 16),
        decoration: BoxDecoration(
            color: const Color(0xff007F4F),
            borderRadius: BorderRadius.circular(10)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            )
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(16, 16, 18.5, 16),
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color(0xffF0FFF9),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlantScreen(
                              plant: selected,
                              device: _device,
                              userName: user.nome,
                              mac: d.mac,
                            )));
              },
              child: Row(
                children: [
                  SizedBox(
                      height: 60,
                      width: 60,
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Image(
                            image: AssetImage(image),
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 20 * 0.6,
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.only(left: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.nome,
                          style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 24,
                              color: Color(0xff081510),
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${d.especie} - ${d.local}",
                          style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 10,
                              color: Color(0xff081510),
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Switch(
                  value: d.irrigacao,
                  onChanged: (bool newValue) {
                    setState(() {
                      widget.devices.doc(d.id).update({'irrigacao': newValue});
                      // _value = newValue;
                    });
                  },
                  activeColor: const Color(0xff93ECCA),
                ),
                const Text(
                  "Irrigação",
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      color: Color(0xff081510),
                      fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
