// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CampoPreenchimento.dart';
import 'package:flutter_application_1/components/CamposSenha.dart';
import 'package:flutter_application_1/screens/HomePage.dart';
import 'package:http/http.dart' as http;
import 'SolicitaResetSenhaPage.dart';
import 'cadastro.page1.dart';

class Login {
  final String email;
  final String senha;

  Login(this.email, this.senha);

  @override
  String toString() {
    return 'Email = $email, Senha = $senha';
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final loading = ValueNotifier<bool>(false);

  Future<http.Response> buscaLoginApi(String login, String senha) async {
    var headers = {'Content-Type': 'Application/json'};

    var loginJson = jsonEncode({'Username': login, 'Password': senha});
    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/login");
    var response = await http.post(url, headers: headers, body: loginJson);
    return response;
  }

  final TextEditingController _controladorCampoUsername =
      TextEditingController();
  final TextEditingController _controladorCampoSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Login login;

    void realizaLogin(Login login) async {
      var response = await buscaLoginApi(login.email, login.senha);
      if (response.statusCode == 200) {
        var json = jsonDecode(utf8.decode(response.bodyBytes));
        String token = json[0]['message'];
        //ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(token: token)),
        );
      } else {
        loading.value = !loading.value;
        Widget okButton = FlatButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("ALERTA"),
              content: const Text("Login invalido"),
              actions: [
                okButton,
              ],
            );
          },
        );
      }
    }

    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset("assets/texte_cube.jpg"),
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: CampoPreenchimento(
                  controlador: _controladorCampoUsername,
                  rotulo: 'Username',
                  icone: Icons.person,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: CamposSenha(
                    controlador: _controladorCampoSenha, rotulo: 'Senha'),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                height: 40,
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: const Text(
                    "Esqueceu a senha ?",
                    textAlign: TextAlign.right,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SolitaResetSenha(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.3, 1],
                      colors: [
                        Colors.blue[900]!,
                        Colors.blue,
                      ],
                    ),
                  ),
                  child: SizedBox.expand(
                    child: TextButton(
                        child: AnimatedBuilder(
                            animation: loading,
                            builder: (context, _) {
                              return loading.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Login",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    );
                            }),
                        onPressed: () => {
                              loading.value = !loading.value,
                              login = Login(_controladorCampoUsername.text,
                                  _controladorCampoSenha.text),
                              realizaLogin(login),
                            } // chamar o metodo que vai conexão com a api e validar o login
                        ),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              SizedBox(
                height: 40,
                // ignore: prefer_const_constructors
                child: Row(
                  //onPressed: () {},              CadastroPage
                  //child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Não tem acesso? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CadastroPage1(),
                          ),
                        );
                      },
                      // ignore: prefer_const_constructors
                      child: Text(
                        "Cadastre-se",
                        //textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
