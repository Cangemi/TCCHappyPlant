import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Devices.dart';
import '../models/Plants.dart';
import '../models/Users.dart';
import '../widget/SpeechBalloon.dart';
import '../widget/Status.dart';
import 'Login.dart';

class PlantScreen extends StatefulWidget {
  final Plants plant;
  final Query<Object?> device;
  final String userName;
  final String mac;
  final CollectionReference plants;
  final CollectionReference devices;
  final CollectionReference users;
  final String image;
  const PlantScreen({
    super.key,
    required this.plant,
    required this.device,
    required this.userName,
    required this.mac,
    required this.plants,
    required this.devices,
    required this.users,
    required this.image,
  });

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  DateTime now = DateTime.now();

  late List _list;

  bool _value = false;

  double _valueWater = 20;
  Color _waterColor = Color(0xffC72929);
  double _valueTemperature = 50;
  Color _temperatureColor = Color(0xffFDCC1C);
  double _valueLight = 100;
  Color _lightColor = Color(0xff255A46);

  final random = Random();

  late Query<Object?> _device;

  int flag = 0;
  int statusFlag = 0;

  late String _image;

  Color color = const Color(0xffC72929);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    _device = widget.device.where("mac", isEqualTo: widget.mac);
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0Xffffffff),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0Xffffffff),
        centerTitle: true,
        title: const Text(
          "Saúde da planta",
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
      body: StreamBuilder(
          stream: _device.snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<int> moodList = [];
              List<int> badMood = [];
              List<int> goodMood = [];
              final dados = snapshot.requireData;
              Devices d = Devices.fromJson(
                  dados.docs[0].data() as Map<String, dynamic>,
                  dados.docs[0].id);
              if ((d.doubleUmidade < widget.plant.doubleMinAgua ||
                      d.doubleUmidade > widget.plant.doubleMaxAgua) &&
                  d.intAwaits == 0) {
                if (now.hour < 18) {
                  _image = 'images/unhappy.gif';
                  color = const Color(0xffC72929);
                  _waterColor = const Color(0xffC72929);
                  statusFlag = 0;
                  if (d.doubleUmidade < widget.plant.doubleMinAgua) {
                    badMood.add(3);
                  } else {
                    badMood.add(4);
                  }
                } else {
                  statusFlag++;
                }
              } else if ((d.doubleUmidade < widget.plant.doubleMinAgua + 20 ||
                      d.doubleUmidade > widget.plant.doubleMaxAgua - 20) &&
                  d.intAwaits == 1) {
                _waterColor = const Color(0xffFDCC1C);
                statusFlag++;
                if (now.hour < 18) {
                  goodMood = [5];
                }
              } else {
                _waterColor = const Color(0xff007F4F);
                statusFlag++;
                if (now.hour < 18) {
                  goodMood = [6];
                }
              }

              if (d.doubleTemperatura < widget.plant.doubleMinTemperatura ||
                  d.doubleTemperatura > widget.plant.doubleMaxTemperatura) {
                if (now.hour < 18) {
                  _image = 'images/unhappy.gif';
                  color = const Color(0xffC72929);
                  _temperatureColor = const Color(0xffC72929);
                  statusFlag = 0;
                  if (d.doubleTemperatura < widget.plant.doubleMinTemperatura) {
                    badMood.add(7);
                  } else {
                    badMood.add(9);
                  }
                } else {
                  statusFlag++;
                }
              } else if (d.doubleTemperatura <
                      widget.plant.doubleMinTemperatura + 2 ||
                  d.doubleTemperatura > widget.plant.doubleMaxTemperatura - 2) {
                _temperatureColor = const Color(0xffFDCC1C);
                statusFlag++;
                if (now.hour < 18) {
                  goodMood = [8];
                }
              } else {
                _temperatureColor = const Color(0xff007F4F);
                statusFlag++;
                if (now.hour < 18) {
                  goodMood = [8];
                }
              }

              if (d.doubleLuz < widget.plant.doubleMinLuz ||
                  d.doubleLuz > widget.plant.doubleMaxLuz) {
                if (now.hour < 18) {
                  _image = 'images/unhappy.gif';
                  color = const Color(0xffC72929);
                  _lightColor = const Color(0xffC72929);
                  statusFlag = 0;
                  if (d.doubleLuz < widget.plant.doubleMinLuz) {
                    badMood.add(10);
                  } else {
                    badMood.add(12);
                  }
                } else {
                  statusFlag++;
                }
              } else if (d.doubleLuz < widget.plant.doubleMinLuz + 20 ||
                  d.doubleLuz > widget.plant.doubleMaxLuz - 20) {
                _lightColor = const Color(0xffFDCC1C);
                statusFlag++;
                if (now.hour < 18) {
                  goodMood = [11];
                }
              } else {
                _lightColor = const Color(0xff007F4F);
                statusFlag++;
                if (now.hour < 18) {
                  goodMood = [11];
                }
              }
              print(statusFlag);
              if (statusFlag == 3) {
                _image = 'images/happy.gif';
                color = const Color(0xff007F4F);
                statusFlag = 0;
                moodList = goodMood;
                if (now.hour < 18) {
                  moodList.add(0);
                } else {
                  moodList.add(1);
                }
              } else {
                moodList = badMood;
                statusFlag = 0;
              }
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(right: 24, left: 24, top: 23),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        d.nome,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 24,
                          color: Color(0xff081510),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  height: 252,
                                  width: double.infinity,
                                  child: Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (flag == 0) {
                                              if (moodList.contains(2)) {
                                                moodList.remove(2);
                                              }
                                              int i = random
                                                  .nextInt(moodList.length);
                                              setState(() {
                                                _list = widget.plant
                                                        .script[moodList[i]][
                                                    random
                                                        .nextInt(widget
                                                            .plant
                                                            .script[moodList[i]]
                                                            .length)
                                                        .toString()];
                                                flag = 1;
                                              });
                                            }
                                          },
                                          child: Image(
                                            image: AssetImage(_image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 70),
                                        width: 54,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 54 * 0.6,
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                          flag == 0
                              ? Container()
                              : Positioned(
                                  width: _width * 0.87,
                                  top: 225,
                                  child: Center(
                                      child: SpeechBalloon(
                                    name: widget.userName,
                                    text: _list,
                                    callBack: () {
                                      setState(() {
                                        flag = 0;
                                      });
                                    },
                                  )))
                        ],
                      ),
                      const Text(
                        "Status da sua plantinha",
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 24,
                            color: Color(0xff255A46),
                            fontWeight: FontWeight.w700),
                      ),
                      Status(
                        value: d.doubleUmidade,
                        color: _waterColor,
                        text1: "Seco",
                        text2: "Úmido",
                        text3: "Inundado",
                        label: "Nível de água",
                        onTap: () {
                          if (flag == 0) {
                            if (!moodList.contains(2)) {
                              moodList.add(2);
                            }
                            int i = random.nextInt(moodList.length);
                            setState(() {
                              _list = widget.plant.script[moodList[i]][random
                                  .nextInt(
                                      widget.plant.script[moodList[i]].length)
                                  .toString()];
                              flag = 1;
                            });
                          }
                        },
                      ),
                      Status(
                        value: d.doubleTemperatura,
                        color: _temperatureColor,
                        text1: "Frio",
                        text2: "Normal",
                        text3: "Quente",
                        label: "Nível de calor",
                        onTap: () {
                          if (flag == 0) {
                            if (!moodList.contains(2)) {
                              moodList.add(2);
                            }
                            int i = random.nextInt(moodList.length);
                            setState(() {
                              _list = widget.plant.script[moodList[i]][random
                                  .nextInt(
                                      widget.plant.script[moodList[i]].length)
                                  .toString()];
                              flag = 1;
                            });
                          }
                        },
                      ),
                      Status(
                        value: d.doubleLuz,
                        color: _lightColor,
                        text1: "Pouca luz",
                        text2: "Normal",
                        text3: "Muita luz",
                        label: "Nível de luz solar",
                        onTap: () {
                          if (flag == 0) {
                            if (!moodList.contains(2)) {
                              moodList.add(2);
                            }
                            int i = random.nextInt(moodList.length);
                            setState(() {
                              _list = widget.plant.script[moodList[i]][random
                                  .nextInt(
                                      widget.plant.script[moodList[i]].length)
                                  .toString()];
                              flag = 1;
                            });
                          }
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 18, bottom: 52),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Irrigação automática",
                              style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 12,
                                  color: Color(0xff255A46),
                                  fontWeight: FontWeight.w700),
                            ),
                            Switch(
                              value: d.irrigacao,
                              onChanged: (bool newValue) {
                                setState(() {
                                  widget.devices
                                      .doc(d.id)
                                      .update({'irrigacao': newValue});
                                });
                              },
                              activeColor: const Color(0xff93ECCA),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
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
              _device = widget.device.where("mac", isEqualTo: widget.mac);
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xff255A46)));
            }
          }),
    );
  }
}
