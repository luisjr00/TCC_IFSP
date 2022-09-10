// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/RealizaResetPage.dart';
import 'package:validatorless/validatorless.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SolitaResetSenha extends StatefulWidget {
  const SolitaResetSenha({Key? key}) : super(key: key);

  @override
  State<SolitaResetSenha> createState() => _SolitaResetSenha();
}

class _SolitaResetSenha extends State<SolitaResetSenha> {
  final TextEditingController controladorCampoEmail = TextEditingController();

  int _gerarNumero() {
    int numero = 0;
    Random numeroAleatorio = new Random();
    numero = numeroAleatorio.nextInt(1000);
    return numero;
  }

  void _solicitaReset(DadosResetSenha reset) async {
    reset.codigoVerificacao = _gerarNumero();
    var response = await _realizaReset(reset);
    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      String token = json[0]['message'].toString();
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RealizaReset(
              codigoVerificacao: reset.codigoVerificacao,
              email: reset.email,
              token: token),
        ),
      );
    } else {
      var mensagem = json[0]['message'];
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

  Future<http.Response> _realizaReset(DadosResetSenha reset) async {
    var headers = {
      'Content-Type': 'Application/json',
    };
    var resetJson = jsonEncode(
        {"email": reset.email, "CodigoVerificacao": reset.codigoVerificacao});
    var url =
        Uri.parse("https://app-tcc-amai-producao.herokuapp.com/solicita-reset");
    var response = await http.post(url, headers: headers, body: resetJson);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recuparar Senha'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CampoPreenchimento(
                controlador: controladorCampoEmail,
                rotulo: 'Email',
                dica: 'example@example.com',
                icone: Icons.email,
              ),
              const SizedBox(
                height: 25,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 15,
                ),
                child: const Text(
                  'SOLICITAR RESET SENHA',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  var reset = DadosResetSenha();
                  reset.email = controladorCampoEmail.text;
                  _solicitaReset(reset);
                },
              ),
            ],
          ),
        ));
  }
}

class CampoPreenchimento extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String? dica;
  final IconData? icone;

  const CampoPreenchimento(
      {super.key,
      required this.controlador,
      required this.rotulo,
      this.dica,
      this.icone});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icone),
        labelText: rotulo,
        hintText: dica != null ? dica : null,
        labelStyle: const TextStyle(
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

class DadosResetSenha {
  late String email;
  late int codigoVerificacao;
}
