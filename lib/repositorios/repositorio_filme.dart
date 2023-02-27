import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/filme_modal.dart';

class RepositorioFilme {
  Future<Filme?> getMovie(String id_filme) async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/$id_filme?api_key=af2d06ca667a7ba4f06bfa6687598cfa&language=pt-BR");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = response.body;
      var decodedRes = jsonDecode(result);
      return Filme.fromJson(decodedRes);
    } else {
      throw Exception('Filme não encontrado');
    }
  }
}
