// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cadastro.page1.dart';
import 'package:flutter_application_1/tarefas.page.dart';
import 'package:http/http.dart' as http;

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
  bool _mostrarSenha = true;

  Future<http.Response> buscaLoginApi(String login, String senha) async {
    var headers = {'Content-Type': 'Application/json'};

    var loginJson = jsonEncode({'Username': login, 'Password': senha});
    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/login");
    var response = await http.post(url, headers: headers, body: loginJson);
    return response;
  }

  final TextEditingController _controladorCampoEmail = TextEditingController();
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
          MaterialPageRoute(builder: (context) => TarefasPage(token: token)),
        );
      } else {
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

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 128,
              height: 128,
              child: Image.asset("assets/texte_cube.jpg"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _controladorCampoEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _controladorCampoSenha,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "Senha",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_mostrarSenha == false
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _mostrarSenha = !_mostrarSenha;
                    });
                  },
                ),
                //hintText: "*******",
                labelStyle: const TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              obscureText: _mostrarSenha,
              style: const TextStyle(fontSize: 16),
              // validator: Validatorless.multiple([
              //   Validatorless.required("Campo requerido"),
              //   Validatorless.min(6, "Senha precisa ter no mínimo 6 caracteres")
              // ]),
            ),
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  "Esqueceu a senha ?",
                  textAlign: TextAlign.right,
                ),
                onPressed:
                    () {}, /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordPage(),
                      ),
                    );
                */
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 60,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.3, 1],
                  colors: [
                    Colors.blue[900]!,
                    Colors.blue,
                  ],
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: SizedBox.expand(
                child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => {
                          login = Login(_controladorCampoEmail.text,
                              _controladorCampoSenha.text),
                          realizaLogin(login),
                        } // chamar o metodo que vai conexão com a api e validar o login
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
    );
  }
}
