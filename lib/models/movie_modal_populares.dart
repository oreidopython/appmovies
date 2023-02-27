
class MovieList {
  final List movies;
  MovieList({required this.movies});

  factory MovieList.fromJson(Map<String, dynamic> json) {
    return MovieList(
      movies: json['results'],
    );
  }
}