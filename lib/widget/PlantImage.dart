import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/Devices.dart';
import '../models/Plants.dart';

class PlantImage extends StatefulWidget {
  final Query<Object?> device;
  final Plants plant;
  final double width;
  final double height;
  final double margin;
  final double size;
  const PlantImage(
      {super.key,
      required this.device,
      required this.plant,
      required this.width,
      required this.height,
      required this.margin,
      required this.size});

  @override
  State<PlantImage> createState() => _PlantImageState();
}

class _PlantImageState extends State<PlantImage> {
  DateTime now = DateTime.now();

  bool wifi = false;
  String _image = "";
  IconData _icon = Icons.check_rounded;
  Color color = const Color(0xffC72929);

  setUpTimedFetch(DateTime before) {
    Timer.periodic(const Duration(milliseconds: 10000), (timer) {
      now = DateTime.now();
      if ((now.difference(before)).inSeconds > 20) {
        setState(() {
          wifi = false;
        });
      } else {
        setState(() {
          wifi = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.device.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final dados = snapshot.requireData;
            Devices d = Devices.fromJson(
                dados.docs[0].data() as Map<String, dynamic>, dados.docs[0].id);
            setUpTimedFetch(d.time);
            if ((now.difference(d.time)).inSeconds < 40) {
              if (now.hour < 21) {
                if (d.doubleUmidade < widget.plant.doubleMinAgua ||
                    d.doubleUmidade > widget.plant.doubleMaxAgua) {
                  _image = 'images/unhappy.gif';
                  color = const Color(0xffC72929);
                  _icon = Icons.warning;
                } else if (d.doubleLuz < widget.plant.doubleMinLuz ||
                    d.doubleLuz > widget.plant.doubleMaxLuz) {
                  _image = 'images/unhappy.gif';
                  color = const Color(0xffC72929);
                  _icon = Icons.warning;
                } else if (d.doubleTemperatura <
                        widget.plant.doubleMinTemperatura ||
                    d.doubleTemperatura > widget.plant.doubleMaxTemperatura) {
                  _image = 'images/unhappy.gif';
                  color = const Color(0xffC72929);
                  _icon = Icons.warning;
                } else {
                  _image = 'images/happy.gif';
                  color = const Color(0xff007F4F);
                  _icon = Icons.check_rounded;
                }
              } else {
                _image = 'images/happy.gif';
                color = const Color(0xff007F4F);
                _icon = Icons.check_rounded;
              }
            } else {
              _image = 'images/unhappy.gif';
              color = const Color(0xffC72929);
              _icon = Icons.wifi_off;
            }
            return Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Center(
                  child: Image(
                    image: AssetImage(_image),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: widget.margin),
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _icon,
                    color: Colors.white,
                    size: widget.size * 0.6,
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
