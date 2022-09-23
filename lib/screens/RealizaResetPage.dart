// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:flutter_application_1/components/CamposSenha.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/CampoPreenchimento.dart';
import 'login.page.dart';

class RealizaReset extends StatefulWidget {
  String token;
  int codigoVerificacao;
  String email;
  RealizaReset(
      {Key? key,
      required this.token,
      required this.codigoVerificacao,
      required this.email})
      : super(key: key);

  @override
  State<RealizaReset> createState() => _RealizaResetState();
}

class _RealizaResetState extends State<RealizaReset> {
  final _controladorCampoSenha = TextEditingController();

  final _controladorCampoConfSenha = TextEditingController();

  final _controladorCampoCodigoConfirmacao = TextEditingController();

  void _confirmaResetSenha(camposReset reset, BuildContext context) async {
    var response = await _realizaReset(reset);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      var mensagem = json[0]['message'].toString();

      var snackBar = SnackBar(
        content: Text(mensagem),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } else {
      var mensagem = "Falha ao redefinir senha";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> _realizaReset(camposReset reset) async {
    var headers = {
      'Content-Type': 'Application/json',
    };
    var resetJson = jsonEncode({
      "email": reset.email,
      "Password": reset.Password,
      "RePassword": reset.RePassword,
      "Token": reset.token,
    });
    var url =
        Uri.parse("https://app-tcc-amai-producao.herokuapp.com/efetua-reset");
    var response = await http.post(url, headers: headers, body: resetJson);
    return response;
  }

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confirmar nova senha'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CampoPreenchimento(
                  controlador: _controladorCampoCodigoConfirmacao,
                  rotulo: "Codigo de Confirmação",
                  icone: Icons.pin),
              const SizedBox(
                height: 10,
              ),
              CamposSenha(
                controlador: _controladorCampoSenha,
                rotulo: 'Senha',
              ),
              const SizedBox(
                height: 10,
              ),
              CamposSenha(
                  controlador: _controladorCampoConfSenha,
                  rotulo: 'Confirmar Senha'),
              const SizedBox(
                height: 10,
              ),
              carregando
                  ? CircularProgressIndicator()
                  : TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 15,
                      ),
                      child: const Text(
                        'CONFIRMAR RESET SENHA',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          carregando = true;
                        });
                        var reset = camposReset(
                            widget.email,
                            _controladorCampoSenha.text,
                            _controladorCampoConfSenha.text,
                            widget.token);
                        if (widget.codigoVerificacao.toString() ==
                            _controladorCampoCodigoConfirmacao.text) {
                          _confirmaResetSenha(reset, context);
                        } else {
                          var mensagem = "Falha ao redefinir senha";
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertaMensagem(mensagem: mensagem);
                            },
                          );
                          setState(() {
                            carregando = false;
                          });
                        }
                      },
                    ),
            ],
          )),
        ),
      ),
    );
  }
}

class camposReset {
  final String email;
  final String Password;
  final String RePassword;
  final String token;

  camposReset(this.email, this.Password, this.RePassword, this.token);
}
