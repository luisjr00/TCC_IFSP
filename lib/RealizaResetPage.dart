// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:validatorless/validatorless.dart';
import 'dart:convert';

import 'login.page.dart';

class RealizaReset extends StatelessWidget {
  String token;
  int codigoVerificacao;
  String email;
  RealizaReset(
      {Key? key,
      required this.token,
      required this.codigoVerificacao,
      required this.email})
      : super(key: key);

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
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } else {
      var mensagem = "Falha ao redefinir senha";
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
            content: Text(mensagem),
            actions: [
              okButton,
            ],
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar nova senha'),
      ),
      body: Center(
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
          CamposSenhas(
            controlador: _controladorCampoSenha,
            rotulo: 'Senha',
          ),
          const SizedBox(
            height: 10,
          ),
          CamposSenhas(
              controlador: _controladorCampoConfSenha,
              rotulo: 'Confirmar Senha'),
          const SizedBox(
            height: 10,
          ),
          TextButton(
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
              var reset = camposReset(email, _controladorCampoSenha.text,
                  _controladorCampoConfSenha.text, token);
              if (codigoVerificacao.toString() ==
                  _controladorCampoCodigoConfirmacao.text) {
                _confirmaResetSenha(reset, context);
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
                      content: const Text("Falha ao redefinir senha"),
                      actions: [
                        okButton,
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      )),
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

class CampoPreenchimento extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String? dica;
  final IconData icone;

  const CampoPreenchimento(
      {super.key,
      required this.controlador,
      required this.rotulo,
      this.dica,
      required this.icone});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icone),
        labelText: rotulo,
        hintText: dica != null ? dica : null,
        labelStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple([
        Validatorless.required("Campo requerido"),
      ]),
    );
  }
}

class CamposSenhas extends StatefulWidget {
  final TextEditingController controlador;
  final String rotulo;
  const CamposSenhas(
      {Key? key, required this.controlador, required this.rotulo})
      : super(key: key);

  @override
  State<CamposSenhas> createState() => _CamposSenhasState(controlador, rotulo);
}

class _CamposSenhasState extends State<CamposSenhas> {
  bool _mostrarSenha = false;
  final TextEditingController controlador;
  final String rotulo;

  _CamposSenhasState(this.controlador, this.rotulo);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(1.0),
        labelText: rotulo,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
              _mostrarSenha == false ? Icons.visibility_off : Icons.visibility),
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
          fontSize: 20,
        ),
      ),
      obscureText: _mostrarSenha == false ? true : false,
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple([
        Validatorless.required("Campo requerido"),
        Validatorless.min(6, "Senha precisa ter no mínimo 6 caracteres")
      ]),
    );
  }
}
