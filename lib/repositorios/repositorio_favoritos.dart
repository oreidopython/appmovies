import '../servicos/db.dart';

class RepositorioFavoritos {
  selectlogin(id) async {
    List<Map> result = await DatabaseHelper().select("favoritos", id, 'id_client');
    return result;
    }

}