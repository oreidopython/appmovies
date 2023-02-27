import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/TelaLogin.dart';

class Logout extends StatefulWidget {
  @override
  _Logout createState() => _Logout();
}
class _Logout extends State<Logout> {

  Future<void>  logout_tela() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('id_cliente');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    super.initState();
    logout_tela();
  }
  @override
  Widget build(BuildContext context)  {
    return Scaffold();
  }

}

