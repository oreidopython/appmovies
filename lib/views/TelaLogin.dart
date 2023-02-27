import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../servicos/db.dart';
import 'TelaCadastro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TelaInicial.dart';
import 'TelaSenha.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _controllerEmail = TextEditingController();
  final _controllerSenha = TextEditingController();
  bool _showpassword = false;
  String? _erroremail = null;
  String? _errorsenha = null;
  String? id_cliente = null;


  _recuperar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id_cliente = prefs.getString("id_cliente");
    });
    _autologin();
  }

  void _selectlogin(email) async {
    final result = await DatabaseHelper().select('clientes', email,'email');
    if(result.isEmpty){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("VOLTAR"),
              )
            ],
            title: Text("ERRO NO LOGIN!"),
            contentPadding: EdgeInsets.all(20),
            content: Text("SEU LOGIN NÃO FOI ENCONTRADO, FAÇA SEU CADASTRO."),
          ));
    }else{
      final id_cliente = result[0]['id'];
      final senha = result[0]['senha'];
      if(senha==_controllerSenha.text){
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("id_cliente", id_cliente.toString());
        await prefs.setString("email", _controllerEmail.text);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Home()));
      }else{
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("VOLTAR"),
                )
              ],
              title: Text("CONFIRA A SENHA"),
              contentPadding: EdgeInsets.all(20),
              content: Text("AS SENHA NÃO CONFERE, CASO NÃO LEMBRE CLIQUE EM ESQUECEU SUA SENHA."),
            ));

      }
    }


  }

  _autologin(){
    if(id_cliente==null){
    }
    else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Home()));
    }
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
                          autofocus: false,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.all(5),
                            labelText: "E-MAIL",
                            errorText:_erroremail,
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
                                  errorText:_errorsenha,
                                  filled: true,
                                  fillColor: Colors.black,
                                  border: InputBorder.none),
                            ),
                          ]))),
              SizedBox(
                height: 20,
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
                        final id_cliente = _selectlogin(_controllerEmail.text);
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
                      "LOGIN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 26.0, right: 26.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        child: Text(
                          "Esqueceu sua senha?",
                          style:
                              TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Senha()));
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Não tem conta? ",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        GestureDetector(
                          child: Text(
                            "Cadastra-se",
                            style: TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Cadastro()));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ]))));
  }
}
