import 'package:flutter/material.dart';
import 'package:treinowmovies/Widgets/detalhes_filmes.dart';

class PopularesWigets extends StatelessWidget {
  final List movieData;
  PopularesWigets(this.movieData);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movieData.length,
          itemBuilder: (context, index) {
            final String posterPath = movieData[index]['poster_path'];
            return GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                  return Detalhes(movieData[index]);
                }));
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
