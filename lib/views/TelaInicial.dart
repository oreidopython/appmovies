import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treinowmovies/repositorios/repositorio_filmes_populares.dart';
import 'package:treinowmovies/Widgets/populares_filmes.dart';
import 'package:treinowmovies/repositorios/repositorio_pesquisar.dart';
import '../Widgets/favoritos_filmes.dart';
import '../Widgets/logout.dart';
import '../Widgets/pesquisar_filmes.dart';
import '../repositorios/repositorio_favoritos.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final procurarController = TextEditingController();
  String filme = '';
  int page = 1;
  int page_pes = 1;
  String? id = '';

  _recuperar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("id_cliente");
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperar();
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("App Movies"),
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Logout()));
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
        ),
        body: Container(
          width: query.size.width,
          height: query.size.height,
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: TextField(
                    controller: procurarController,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(fontSize: 20, color: Color(0xFFfc7c0c)),
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          child: Icon(Icons.search, color: Colors.white),
                          onTap: () {
                            setState(() {
                              filme = procurarController.text;
                            });
                          },
                        ),
                        contentPadding: EdgeInsets.all(5),
                        labelText: "Procurar filme",
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.02),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                ),
              ),
              SizedBox(height: 5),
              filme == ''
                  ? Text('')
                  : Column(
                      children: [
                        SizedBox(
                            height: 30,
                            child: Text(
                              "FILMES ENCONTRADOS",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            )),
                        FutureBuilder(
                            future: RepositorioPesquisar()
                                .getMovies(filme, page_pes),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                final List movieData = snapshot.data.movies;
                                movieData.removeWhere((element) =>
                                    element['poster_path'] == null);
                                movieData.removeWhere((element) =>
                                element['backdrop_path'] == null);
                                if (movieData == []) {
                                  return Text("Filme não encontrado");
                                } else {
                                  return PesquisarWidget(movieData);
                                }
                              }
                            }),
                        SizedBox(
                          width: 200,
                          height: 55,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                setState(() {
                                  filme = '';
                                  procurarController.text = '';
                                });
                              },
                              child: Text(
                                "LIMPAR PESQUISA",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        Text("PAGINAS", style: TextStyle(fontSize: 20)),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            page_pes == 1
                                ? Text("")
                                : GestureDetector(
                                    child: Text((page_pes - 1).toString(),
                                        style: TextStyle(fontSize: 20)),
                                    onTap: () {
                                      setState(() {
                                        page_pes = page_pes - 1;
                                      });
                                    },
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                                color: Colors.blue,
                                child: Text(
                                  (page_pes).toString(),
                                  style: TextStyle(fontSize: 20),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              child: Text(
                                (page_pes + 1).toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              onTap: () {
                                setState(() {
                                  page_pes = page_pes + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
              SizedBox(
                  height: 30,
                  child: Text(
                    "FILMES POPULARES",
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  )),
              FutureBuilder(
                  future: RepositorioFilmesPopulares().getMovies(page),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final List movieData = snapshot.data.movies;
                      movieData.removeWhere((element) =>
                      element['poster_path'] == null);
                      movieData.removeWhere((element) =>
                      element['backdrop_path'] == null);
                      return PopularesWigets(snapshot.data.movies);
                    }
                  }),
              SizedBox(
                height: 5,
              ),
              Text("PAGINAS", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  page == 1
                      ? Text("")
                      : GestureDetector(
                          child: Text((page - 1).toString(),
                              style: TextStyle(fontSize: 20)),
                          onTap: () {
                            setState(() {
                              page = page - 1;
                            });
                          },
                        ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      color: Colors.blue,
                      child: Text(
                        (page).toString(),
                        style: TextStyle(fontSize: 20),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    child: Text(
                      (page + 1).toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      setState(() {
                        page = page + 1;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("FAVORITOS", style: TextStyle(fontSize: 25)),
              FutureBuilder(
                  future: RepositorioFavoritos().selectlogin(id),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return FavoritosFilmes(snapshot.data);
                    }
                  }),
            ],
          )),
        ));
  }
}
