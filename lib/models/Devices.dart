import 'package:cloud_firestore/cloud_firestore.dart';

class Devices {
  String? id;
  String uid;
  String nome;
  String especie;
  String local;
  String mac;
  int umidade;
  int temperatura;
  int luz;
  int tempoSemIrrigacao;
  int awaits;
  bool irrigacao;

  Devices(
      {this.id,
      required this.uid,
      required this.nome,
      required this.especie,
      required this.local,
      required this.mac,
      required this.umidade,
      required this.temperatura,
      required this.luz,
      required this.tempoSemIrrigacao,
      required this.irrigacao,
      required this.awaits});

  factory Devices.fromJson(Map<String, dynamic> map, String id) {
    return Devices(
        id: id,
        nome: map['nome'],
        tempoSemIrrigacao: map['tempoSemIrrigacao'],
        especie: map['especie'],
        local: map['local'],
        luz: map['luz'],
        mac: map['mac'],
        temperatura: map['temperatura'],
        uid: map['uid'],
        umidade: map['umidade'],
        irrigacao: map['irrigacao'],
        awaits: map['awaits']);
  }
}
