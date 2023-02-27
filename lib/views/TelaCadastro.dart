import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:treinowmovies/servicos/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TelaLogin.dart';



class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _Cadastro();
}

class _Cadastro extends State<Cadastro> {
  final _controllerEmail = TextEditingController();
  final _controllerSenha = TextEditingController();
  String? _erroremail = null;
  String? _errorsenha = null;
  bool _showpassword = false;

  _addCliente(table,row) async {
    final id = await DatabaseHelper().insert(table,row);
    salvar(id)async{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("id_cliente", id.toString());
    }
    salvar(id);
    return id.toInt();
  }


  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("App Movies"),
        ),
        body: Container(
            width: query.size.width,
            height: query.size.height,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Image.asset("images/logo.png",
                        width: 300, height: 100),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: double.infinity,
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.03),
                              spreadRadius: 10,
                              blurRadius: 3,
                              // changes position of shadow
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 5, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _controllerEmail,
                              keyboardType: TextInputType.emailAddress,
                              autofocus: true,
                              style: TextStyle(fontSize: 20, color: Colors.white),
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.person),
                                contentPadding: EdgeInsets.all(5),
                                errorText:_erroremail,
                                labelText: "E-MAIL",
                                filled: true,
                                fillColor: Colors.black,
                                border: InputBorder.none,
                              ),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: double.infinity,
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.03),
                              spreadRadius: 10,
                              blurRadius: 3,
                              // changes position of shadow
                            ),
                          ]),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 15, bottom: 5, right: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  obscureText:
                                  _showpassword == false ? true : false,
                                  controller: _controllerSenha,
                                  keyboardType: TextInputType.text,
                                  style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        child: Icon(_showpassword == false
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onTap: () {
                                          setState(() {
                                            _showpassword = !_showpassword;
                                          });
                                        },
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                      labelText: "SENHA",
                                      filled: true,
                                      errorText:_errorsenha,
                                      fillColor: Colors.black,
                                      border: InputBorder.none),
                                ),
                              ]))),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      final bool isValid = EmailValidator.validate(_controllerEmail.text);
                      if(_controllerEmail.text.isEmpty){
                        setState(() {
                          _erroremail='Preencha o email';
                        });
                      }else {
                        setState(() {
                          _erroremail='';
                        });
                        if(_controllerSenha.text.isEmpty){
                          setState(() {
                            _errorsenha='Preencha a senha';
                          });
                        }
                        else {
                          setState(() {
                            _errorsenha='';
                          });
                          if (isValid==false){
                            setState(() {
                              _erroremail='Digite um E-mail valido';
                            });
                          }
                          else{
                            Map<String, dynamic> row = {
                              DatabaseHelper.columnEmail: _controllerEmail.text,
                              DatabaseHelper.columnSenha: _controllerSenha.text
                            };
                            final id_cliente = _addCliente('clientes', row).toString();

                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (context) => Login()));
                                      },
                                      child: Text("Tela Principal"),
                                    )
                                  ],
                                  title: Text("Cadastro Realizado"),
                                  contentPadding: EdgeInsets.all(20),
                                  content: Text("Tudo certo! faça seu login na tela principal."),
                                ));
                          }
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                        child: Text(
                          "CADASTRAR",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ]))));
  }
}
