import 'package:flutter/material.dart';
import 'package:treinowmovies/Widgets/similar_filmes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositorios/repositorio_atores.dart';
import '../repositorios/repositorio_similares.dart';
import '../servicos/db.dart';
import '../views/TelaInicial.dart';
import 'atores.dart';


class Detalhes extends StatefulWidget {
  final Map movieData;
  Detalhes(this.movieData);

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  bool colorfavorito = false;
  String? id_cliente = '';
  String? email ='';

  _recuperar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id_cliente = prefs.getString("id_cliente");
      email = prefs.getString("id_cliente");
      final valor = prefs.getString(widget.movieData['id'].toString());
      if(valor == 'true'){
        colorfavorito=true;
      }
      else {
        colorfavorito = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperar();
  }

  _addFilme(table) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnEmail: email,
      DatabaseHelper.columnIDCliente: id_cliente.toString(),
      DatabaseHelper.columnIDFILME: widget.movieData['id'],
      DatabaseHelper.columnPATHFOTO: widget.movieData['poster_path'],
      DatabaseHelper.titlePath: widget.movieData['backdrop_path'],
      DatabaseHelper.movieName: widget.movieData['title'],
      DatabaseHelper.movieOverview: widget.movieData['overview'],
      DatabaseHelper.media_voto:'vote_average',
      DatabaseHelper.movieId:widget.movieData['vote_average']
    };
    final id = await DatabaseHelper().insert(table,row);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.movieData['id'].toString(), 'true');
    return id;
  }

  _removeFilme() async{
    final id = await DatabaseHelper().deleteItem('favoritos',widget.movieData['id'],'id_filme');
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(widget.movieData['id'].toString());
    return id;
  }



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String _titlePath = widget.movieData['backdrop_path'];
    final String movieName = widget.movieData['title'];
    final String movieOverview = widget.movieData['overview'];
    final int movieId = widget.movieData['id'];
    final double media_voto = widget.movieData['vote_average'];
    final int voto = (media_voto * 10).toInt();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Infomações do filme"),
            SizedBox(
              width: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Inicio")
                ],
              ),
            )
          ],
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child:
                Image.network('http://image.tmdb.org/t/p/w780/$_titlePath'),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width * 0.90,
                child: Text(
                  '$movieName',
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width * 0.90,
                child: Text('$movieOverview',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text("Avaliação:", style: TextStyle(fontSize: 20)),
                        SizedBox(
                          height: 5,
                        ),
                        Text("$voto%", style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                      onTap: () {
                        colorfavorito ?  _removeFilme() : _addFilme('favoritos');
                        setState(() {
                          colorfavorito ? colorfavorito = false : colorfavorito = true;
                        });

                      },
                      child: Column(
                        children: [
                          Text("Marcar como Favorito:",
                              style: TextStyle(fontSize: 20)),
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            color: colorfavorito ? Colors.red : Colors.white,
                            Icons.favorite,
                            size: 25,
                          ),
                        ],
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text("ATORES", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: AtoresRepositorios().getAtores(movieId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final List atoresData = snapshot.data.atores;
                      atoresData.removeWhere(
                              (element) => element['profile_path'] == null);
                      if (atoresData == []) {
                        return Text("Atores não encontrado");
                      } else {
                        return AtoresWidget(atoresData);
                      }
                    }
                  }),
              Text("FILMES SIMILARES", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: RepositorioSimilares().getMovies(movieId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final List movieData = snapshot.data.movies;
                      movieData.removeWhere(
                              (element) => element['poster_path'] == null);
                      if (movieData == []) {
                        return Text("Filme não encontrado");
                      } else {
                        return SimilarWigets(movieData);
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}


