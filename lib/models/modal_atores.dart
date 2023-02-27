class Atores {
  final List atores;
  Atores({required this.atores});

  factory Atores.fromJson(Map<String, dynamic> json) {
    return Atores(
      atores: json['cast'],
    );
  }
}