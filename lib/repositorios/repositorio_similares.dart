import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:treinowmovies/models/movie_modal_populares.dart';

class RepositorioSimilares {
  Future<MovieList?> getMovies(id) async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/$id/similar?api_key=af2d06ca667a7ba4f06bfa6687598cfa&language=pt-BR");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = response.body;
      var decodedRes = jsonDecode(result);
      return MovieList.fromJson(decodedRes);
    } else {
      return null;
    }
  }
}