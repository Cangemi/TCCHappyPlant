class Plants {
  String? id;
  String nome;
  int tempoSemIrrigacao;
  int minAgua;
  int maxAgua;
  int minLuz;
  int maxLuz;
  int minTemperatura;
  int maxTemperatura;
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
      required this.script});

  factory Plants.fromJson(Map<String, dynamic> map, String id) {
    return Plants(
        id: id,
        nome: map['nome'],
        tempoSemIrrigacao: map['tempoSemIrrigacao'],
        minAgua: map['minAgua'],
        maxAgua: map['maxAgua'],
        minLuz: map['minLuz'],
        maxLuz: map['maxLuz'],
        minTemperatura: map['minTemperatura'],
        maxTemperatura: map['maxTemperatura'],
        script: map['script']);
  }
}
