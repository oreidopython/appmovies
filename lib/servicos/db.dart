import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static const columnEmail = 'email';
  static const columnSenha = 'senha';

  static const columnIDCliente = 'id_client';
  static const columnIDFILME = 'id_filme';
  static const columnPATHFOTO = 'path_foto';

  static const titlePath = 'backdrop_path';
  static const movieName = 'title';
  static const movieOverview = 'overview';
  static const media_voto = 'vote_average';
  static const movieId = 'id';


  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE clientes(
         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,            
            $columnEmail TEXT NOT NULL,
            $columnSenha TEXT NOT NULL
      )
      """);
    await database.execute("""CREATE TABLE favoritos(
            $columnIDCliente INTEGER NOT NULL,            
            $columnEmail TEXT NOT NULL,
            $columnIDFILME INTEGER NOT NULL,
            $columnPATHFOTO TEXT NOT NULL,
            $titlePath TEXT NOT NULL,
            $movieName TEXT NOT NULL,
            $movieOverview TEXT NOT NULL,
            $media_voto TEXT NOT NULL,
            $movieId TEXT NOT NULL            
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'Treinowmovies.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }


  insert(table,Map<String, dynamic> row) async {
    final db = await DatabaseHelper.db();
    final id = await db.insert(table, row);
    return id.toInt();
  }

  Future<List<Map<String, dynamic>>> select(table,email,coluna) async {
    final db = await DatabaseHelper.db();
    final id = await db.query(table, where: "$coluna = ?", whereArgs: [email], limit: 30);
    return id;
  }


  Future<int> deleteItem(table,id_filme,coluna) async {
    final db = await DatabaseHelper.db();
    final id = await db.delete(table, where: "$coluna = ?", whereArgs: [id_filme]);
    return id;
  }


}