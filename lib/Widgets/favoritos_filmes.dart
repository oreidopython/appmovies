import 'package:flutter/material.dart';
import '../models/filme_modal.dart';
import '../repositorios/repositorio_filme.dart';
import 'detalhes_filmes.dart';

class FavoritosFilmes extends StatefulWidget {
  final List<Map> movieData;
  FavoritosFilmes(this.movieData);

  @override
  State<FavoritosFilmes> createState() => _FavoritosFilmesState();
}

class _FavoritosFilmesState extends State<FavoritosFilmes> {

  Future<Filme?> pegardados (index)async{
    final movieData1 = await RepositorioFilme().getMovie(widget.movieData[index]['id_filme'].toString());
    Map info_filme = Map();
    info_filme = {'backdrop_path':movieData1!.backdropPath,'title':movieData1.title,'overview':movieData1.overview,'id':movieData1.id,'vote_average':movieData1.voteAverage };
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Detalhes(info_filme)));

  }





  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      child: widget.movieData.isEmpty ? Text("Escolha seus filmes favoritos!!!") : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.movieData.length,
          itemBuilder: (context,index){
            final String posterPath = widget.movieData[index]['path_foto'];
            return GestureDetector(
              onTap: () {
                pegardados(index);

              },
              child: Container(
                child: Card(
                  child: Image.network(
                      "http://image.tmdb.org/t/p/w780/$posterPath"),
                ),
              ),
            );
          }),
    );
  }
}


