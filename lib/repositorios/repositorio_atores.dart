import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:treinowmovies/models/modal_atores.dart';

class AtoresRepositorios {
  Future<Atores?> getAtores(id) async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/$id/casts?api_key=af2d06ca667a7ba4f06bfa6687598cfa");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = response.body;
      var decodedRes = jsonDecode(result);
      return Atores.fromJson(decodedRes);
    } else {
      return null;
    }
  }
}