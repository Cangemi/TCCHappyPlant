import 'package:cloud_firestore/cloud_firestore.dart';

class Devices {
  String? id;
  String uid;
  String nome;
  String especie;
  String local;
  String mac;
  String umidade;
  late double doubleUmidade;
  String temperatura;
  late double doubleTemperatura;
  String luz;
  late double doubleLuz;
  String tempoSemIrrigacao;
  late double doubleTempoSemIrrigacao;
  String awaits;
  late int intAwaits;
  bool irrigacao;
  DateTime time;

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
      required this.awaits,
      required this.time}) {
    doubleTempoSemIrrigacao = double.tryParse(tempoSemIrrigacao) ?? 0.0;
    doubleUmidade = double.tryParse(umidade) ?? 0.0;
    doubleTemperatura = double.tryParse(temperatura) ?? 0.0;
    doubleLuz = double.tryParse(luz) ?? 0.0;
    intAwaits = int.tryParse(awaits) ?? 0;
  }

  factory Devices.fromJson(Map<String, dynamic> map, String id) {
    Timestamp timestamp = map['time'];
    DateTime dateTime = timestamp.toDate();
    return Devices(
        id: id,
        nome: map['nome'],
        tempoSemIrrigacao: map['tempoSemIrrigacao'] as String,
        especie: map['especie'] as String,
        local: map['local'] as String,
        luz: map['luz'] as String,
        mac: map['mac'] as String,
        temperatura: map['temperatura'] as String,
        uid: map['uid'] as String,
        umidade: map['umidade'] as String,
        awaits: map['awaits'] as String,
        irrigacao: map['irrigacao'],
        time: dateTime);
  }
}
