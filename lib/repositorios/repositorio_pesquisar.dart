import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:treinowmovies/models/movie_modal_populares.dart';

class RepositorioPesquisar {
  Future<MovieList?> getMovies(String nome_filme, int page) async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/search/movie?api_key=af2d06ca667a7ba4f06bfa6687598cfa&language=pt-BR&query=$nome_filme&include_adult=false&page=$page");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = response.body;
      var decodedRes = jsonDecode(result);
      return MovieList.fromJson(decodedRes);
    } else {
      throw Exception('Filme não encontrado');
    }
  }
}
