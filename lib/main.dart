import 'package:flutter/material.dart';
import 'package:treinowmovies/views/TelaLogin.dart';
import 'package:treinowmovies/views/TelaInicial.dart';
import 'package:flutter/widgets.dart';
import 'package:treinowmovies/servicos/db.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home:Login(),
    );
  }
}
