// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/tarefas.page.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CriarTarefa extends StatefulWidget {
  var token;
  var tarefa = null;
  CriarTarefa({Key? key, required this.token, this.tarefa}) : super(key: key);

  @override
  State<CriarTarefa> createState() => _CriarTarefaState(token, tarefa);
}

class _CriarTarefaState extends State<CriarTarefa> {
  var token;
  var tarefaUpd = null;
  _CriarTarefaState(this.token, this.tarefaUpd);

  void _criaTarefa(Tarefa tarefa) async {
    var response = await realizaPostTarefa(tarefa);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 201) {
      var snackBar = SnackBar(
        content: const Text('Tarefa criada com sucesso!'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

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

  void _atualizaTarefa(Tarefa tarefa, String id) async {
    var response = await realizaPutTarefa(tarefa, id);

    if (response.statusCode == 204) {
      var snackBar = SnackBar(
        content: const Text('Tarefa atualizada com sucesso!'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TarefasPage(token: token),
        ),
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
            content: const Text("Erro ao atualizar tarefa"),
            actions: [
              okButton,
            ],
          );
        },
      );
    }
  }

  Future<http.Response> realizaPutTarefa(Tarefa tarefa, String id) async {
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var cadastroJson = jsonEncode({
      "descricao": tarefa.descricao,
      "dataInicio": tarefa.dataInicio,
      "dataFinal": tarefa.dataFim
    });

    var url =
        Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa/$id");
    var response = await http.put(url, headers: headers, body: cadastroJson);

    return response;
  }

  final TextEditingController controladorCampoDescricao =
      TextEditingController();
  final TextEditingController controladorCampoDataInicio =
      TextEditingController();
  final TextEditingController controladorCampoDataFim = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (tarefaUpd != null) {
      controladorCampoDescricao.text = tarefaUpd['descricao'].toString();
      controladorCampoDataInicio.text = tarefaUpd['dataInicio'].toString();
      controladorCampoDataFim.text = tarefaUpd['dataFinal'].toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar tarefa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CampoPreenchimento(
                controlador: controladorCampoDescricao,
                rotulo: 'Descrição',
                dica: 'Ex. Dar comida para o rex'),
            CampoData(
              controlador: controladorCampoDataInicio,
              rotulo: 'Data inicio',
            ),
            CampoData(
              controlador: controladorCampoDataFim,
              rotulo: 'Data final',
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 8.0, 16.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 15,
                    ),
                    child: const Text(
                      'CANCELAR',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 16.0, 60.0, 16.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      elevation: 15,
                    ),
                    child: const Text(
                      'LIMPAR',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      controladorCampoDescricao.text = '';
                      controladorCampoDataInicio.text = '';
                      controladorCampoDataFim.text = '';
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(60.0, 16.0, 16.0, 16.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 15,
                    ),
                    child: const Text(
                      'SALVAR',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      var tarefa = Tarefa(
                          controladorCampoDescricao.text,
                          controladorCampoDataInicio.text,
                          controladorCampoDataFim.text);

                      if (tarefaUpd != null) {
                        _atualizaTarefa(tarefa, tarefaUpd['id'].toString());
                      } else {
                        _criaTarefa(tarefa);
                      }
                    },
                  ),
                ),
              ],
            ),
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

class CampoData extends StatefulWidget {
  final TextEditingController controlador;
  final String rotulo;

  const CampoData({Key? key, required this.controlador, required this.rotulo})
      : super(key: key);

  @override
  State<CampoData> createState() => _CampoDataState(controlador, rotulo);
}

class _CampoDataState extends State<CampoData> {
  final TextEditingController controlador;
  final String rotulo;

  _CampoDataState(this.controlador, this.rotulo);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.calendar_month),
        labelText: rotulo,
        labelStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple(
        [
          Validatorless.required("Campo requerido"),
        ],
      ),
      onTap: () async {
        DateTime? pickeddate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          locale: const Locale("pt", "BR"),
        );

        if (pickeddate != null) {
          setState(() {
            controlador.text = DateFormat('dd/MM/yyyy').format(pickeddate);
          });
        }
      },
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
