// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:flutter_application_1/screens/tarefas.page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/CampoData.dart';
import '../components/CampoHora.dart';
import '../components/CampoPreenchimento.dart';

class CriarTarefa extends StatefulWidget {
  var token;
  var tarefa = null;
  CriarTarefa({Key? key, required this.token, this.tarefa}) : super(key: key);

  @override
  State<CriarTarefa> createState() => _CriarTarefaState();
}

class _CriarTarefaState extends State<CriarTarefa> {
  final _formKey = GlobalKey<FormState>();

  void _criaTarefa(Tarefa tarefa) async {
    var response = await realizaPostTarefa(tarefa);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 201) {
      var snackBar = const SnackBar(
        content: Text('Tarefa criada com sucesso!'),
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TarefasPage(token: widget.token),
        ),
      );
    } else {
      var mensagem = json['errors']['Descricao'][0].toString();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> realizaPostTarefa(Tarefa tarefa) async {
    var token = widget.token;
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var cadastroJson = jsonEncode({
      "descricao": tarefa.descricao,
      "horaAlerta": tarefa.horaAlerta,
      "dataAlerta": tarefa.dataAlerta,
    });

    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa");
    var response = await http.post(url, headers: headers, body: cadastroJson);

    return response;
  }

  void _atualizaTarefa(Tarefa tarefa, String id) async {
    var response = await realizaPutTarefa(tarefa, id);

    if (response.statusCode == 204) {
      var snackBar = const SnackBar(
        content: Text('Tarefa atualizada com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TarefasPage(token: widget.token),
        ),
      );
    } else {
      var mensagem = "Erro ao atualizar tarefa";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> realizaPutTarefa(Tarefa tarefa, String id) async {
    var token = widget.token;
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var cadastroJson = jsonEncode(
      {
        "descricao": tarefa.descricao,
        "horaAlerta": tarefa.horaAlerta,
        "DataAlerta": tarefa.dataAlerta,
      },
    );

    var url =
        Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa/$id");
    var response = await http.put(url, headers: headers, body: cadastroJson);

    return response;
  }

  final TextEditingController controladorCampoDescricao =
      TextEditingController();
  final TextEditingController controladorCampoHoraAlerta =
      TextEditingController();
  final TextEditingController controladorCampoDataAlerta =
      TextEditingController();

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    if (widget.tarefa != null) {
      controladorCampoDescricao.text = widget.tarefa['descricao'].toString();
      controladorCampoHoraAlerta.text = widget.tarefa['horaAlerta'].toString();
      controladorCampoDataAlerta.text = widget.tarefa['dataAlerta'].toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CampoPreenchimento(
                  controlador: controladorCampoDescricao,
                  rotulo: 'Descrição',
                  dica: 'Ex. Dar comida para o rex',
                ),
                CampoHora(
                    controlador: controladorCampoHoraAlerta,
                    rotulo: 'Hora do alerta'),
                CampoData(
                  controlador: controladorCampoDataAlerta,
                  rotulo: 'Data do alarme',
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
                          controladorCampoHoraAlerta.text = '';
                          controladorCampoDataAlerta.text = '';
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(60.0, 16.0, 16.0, 16.0),
                      child: carregando
                          ? CircularProgressIndicator()
                          : TextButton(
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
                              onPressed: () async {
                                var formValid =
                                    _formKey.currentState?.validate() ?? false;
                                if (formValid) {
                                  setState(() {
                                    carregando = true;
                                  });

                                  var tarefa = Tarefa(
                                      controladorCampoDescricao.text,
                                      controladorCampoHoraAlerta.text,
                                      controladorCampoDataAlerta.text);

                                  if (widget.tarefa != null) {
                                    _atualizaTarefa(
                                        tarefa, widget.tarefa['id'].toString());
                                  } else {
                                    _criaTarefa(tarefa);
                                  }
                                  await Future.delayed(Duration(seconds: 2));

                                  setState(() {
                                    carregando = false;
                                  });
                                }
                              },
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Tarefa {
  final String descricao;
  final String dataAlerta;
  final String horaAlerta;
  String? dataFinalizacao;
  int? responsavelId;
  int? idosoId;
  int? id;

  Tarefa(this.descricao, this.horaAlerta, this.dataAlerta);
}
