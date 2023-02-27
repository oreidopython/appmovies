import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:treinowmovies/servicos/db.dart';
import 'TelaLogin.dart';

class Senha extends StatefulWidget {
  const Senha({Key? key}) : super(key: key);

  @override
  State<Senha> createState() => _Senha();
}

class _Senha extends State<Senha> {
  final _controllerEmail = TextEditingController();
  String? _erroremail = null;
  String? senha = null;

  recuperarsenha(email) async{
    final result = await DatabaseHelper().select('clientes',email,'email');
    setState(() {
      senha = result[0]['senha'];
    });
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
                  Text('Digite seu Email para recuperar sua senha',style:
                  TextStyle(fontSize: 15, color: Colors.white),),
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
                  senha == null? Text("") : Text("Sua senha é: $senha",style:
                  TextStyle(fontSize: 15, color: Colors.white)),
                  SizedBox(
                    height: 10,
                  ),
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
                        if (isValid==false){
                          setState(() {
                            _erroremail='Digite um E-mail valido';
                          });
                        }
                        else{
                          recuperarsenha(_controllerEmail.text);

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
                          "RECUPERAR",
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
