// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/AlertaMensagem.dart';
import '../components/CampoPreenchimento.dart';
import 'RealizaResetPage.dart';

class SolitaResetSenha extends StatefulWidget {
  const SolitaResetSenha({Key? key}) : super(key: key);

  @override
  State<SolitaResetSenha> createState() => _SolitaResetSenha();
}

class _SolitaResetSenha extends State<SolitaResetSenha> {
  final TextEditingController controladorCampoEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    controladorCampoEmail.dispose();
    super.dispose();
  }

  int _gerarNumero() {
    int numero = 0;
    Random numeroAleatorio = Random();
    numero = numeroAleatorio.nextInt(1000);
    return numero;
  }

  void _solicitaReset(DadosResetSenha reset) async {
    reset.codigoVerificacao = _gerarNumero();
    var response = await _realizaReset(reset);
    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      String token = json[0]['message'].toString();
      var snackBar = const SnackBar(
        content: Text('Email com o codigo de verificação enviado!'),
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

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

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recuparar Senha'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CampoPreenchimentoEmail(
                    controlador: controladorCampoEmail,
                    rotulo: 'Email',
                    dica: 'example@example.com',
                    icone: Icons.email,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  carregando
                      ? const CircularProgressIndicator()
                      : TextButton(
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
                            var formValid =
                                _formKey.currentState?.validate() ?? false;
                            if (formValid) {
                              setState(() {
                                carregando = true;
                              });
                              var reset = DadosResetSenha();
                              reset.email = controladorCampoEmail.text;
                              _solicitaReset(reset);
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
        ));
  }
}

class DadosResetSenha {
  late String email;
  late int codigoVerificacao;
}
