class Users {
  String? id;
  String uid;
  String nome;
  String nascimento;

  Users({
    this.id,
    required this.uid,
    required this.nome,
    required this.nascimento,
  });

  factory Users.fromJson(Map<String, dynamic> map, String id) {
    return Users(
      id: id,
      uid: map['uid'],
      nome: map['nome'],
      nascimento: map['nascimento'],
    );
  }
}
