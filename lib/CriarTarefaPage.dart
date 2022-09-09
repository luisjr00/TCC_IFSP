// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/tarefas.page.dart';
import 'package:validatorless/validatorless.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CriarTarefa extends StatefulWidget {
  var token;
  CriarTarefa({Key? key, required this.token}) : super(key: key);

  @override
  State<CriarTarefa> createState() => _CriarTarefaState(token);
}

class _CriarTarefaState extends State<CriarTarefa> {
  var token;
  _CriarTarefaState(this.token);

  void _criaTarefa(Tarefa tarefa) async {
    var response = await realizaPostTarefa(tarefa);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TarefasPage(token: token),
        ),
      );
    } else {
      var mensagem = json['errors']['Descricao'][0].toString();
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

  Future<http.Response> realizaPostTarefa(Tarefa tarefa) async {
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var cadastroJson = jsonEncode({
      "descricao": tarefa.descricao,
      "dataInicio": tarefa.dataInicio,
      "dataFinal": tarefa.dataFim
    });

    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa");
    var response = await http.post(url, headers: headers, body: cadastroJson);

    return response;
  }

  final TextEditingController controladorCampoDescricao =
      TextEditingController();
  final TextEditingController controladorCampoDataInicio =
      TextEditingController();
  final TextEditingController controladorCampoDataFim = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar tarefa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CampoPreenchimento(
                controlador: controladorCampoDescricao,
                rotulo: 'Descrição',
                dica: 'Ex. Dar comida para o rex'),
            CampoPreenchimento(
                controlador: controladorCampoDataInicio,
                rotulo: 'Date inicio',
                dica: 'Ex. dd/mm/aaaa - difinição padrao (dia atual)'),
            CampoPreenchimento(
                controlador: controladorCampoDataFim,
                rotulo: 'Data final',
                dica: 'Ex. dd/mm/aaaa - difinição padrao (5 dias)'),
            const SizedBox(
              height: 25,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 15,
              ),
              child: Text(
                'CRIAR',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                var tarefa = Tarefa(
                    controladorCampoDescricao.text,
                    controladorCampoDataInicio.text,
                    controladorCampoDataFim.text);
                _criaTarefa(tarefa);
              },
            )
          ],
        ),
      ),
    );
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

class Tarefa {
  final String descricao;
  final String dataInicio;
  final String dataFim;
  int? responsavelId;
  int? idosoId;
  int? id;

  Tarefa(this.descricao, this.dataInicio, this.dataFim);
}
