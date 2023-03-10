class Plants {
  String? id;
  String nome;
  String tempoSemIrrigacao;
  late double doubleTempoSemIrrigacao;
  String minAgua;
  late double doubleMinAgua;
  String maxAgua;
  late double doubleMaxAgua;
  String minLuz;
  late double doubleMinLuz;
  String maxLuz;
  late double doubleMaxLuz;
  String minTemperatura;
  late double doubleMinTemperatura;
  String maxTemperatura;
  late double doubleMaxTemperatura;
  List script;

  Plants(
      {this.id,
      required this.nome,
      required this.tempoSemIrrigacao,
      required this.minAgua,
      required this.maxAgua,
      required this.minLuz,
      required this.maxLuz,
      required this.minTemperatura,
      required this.maxTemperatura,
      required this.script}) {
    doubleTempoSemIrrigacao = double.tryParse(tempoSemIrrigacao) ?? 0.0;
    doubleMinAgua = double.tryParse(minAgua) ?? 0.0;
    doubleMaxAgua = double.tryParse(maxAgua) ?? 0.0;
    doubleMinLuz = double.tryParse(minLuz) ?? 0.0;
    doubleMaxLuz = double.tryParse(maxLuz) ?? 0.0;
    doubleMinTemperatura = double.tryParse(minTemperatura) ?? 0.0;
    doubleMaxTemperatura = double.tryParse(maxTemperatura) ?? 0.0;
  }

  factory Plants.fromJson(Map<String, dynamic> map, String id) {
    return Plants(
        id: id,
        nome: map['nome'],
        tempoSemIrrigacao: map['tempoSemIrrigacao'] as String,
        minAgua: map['minAgua'] as String,
        maxAgua: map['maxAgua'] as String,
        minLuz: map['minLuz'] as String,
        maxLuz: map['maxLuz'] as String,
        minTemperatura: map['minTemperatura'] as String,
        maxTemperatura: map['maxTemperatura'] as String,
        script: map['script']);
  }
}
