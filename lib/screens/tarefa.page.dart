// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:flutter_application_1/screens/tarefas.page.dart';
import 'package:http/http.dart' as http;

import 'CriarTarefaPage.dart';

// ignore: must_be_immutable
class TarefaPage extends StatelessWidget {
  Map<String, dynamic> tarefa;
  var token;
  TarefaPage({Key? key, required this.tarefa, this.token}) : super(key: key);

  void _excluirTarefa(String id, BuildContext context) async {
    var response = await realizaDeleteTarefa(id);

    if (response.statusCode == 204) {
      // ignore: prefer_const_constructors
      var snackBar = SnackBar(
        content: const Text('Tarefa excluida com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TarefasPage(token: token),
        ),
      );
    } else {
      var mensagem = 'Erro ao excluir tarefa';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> realizaDeleteTarefa(String id) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url =
        Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa/$id");

    var response = await http.delete(url, headers: headers);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tarefa['descricao'])),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: [
                Text(tarefa['descricao']),
                Text(tarefa['dataInicio']),
                Text(tarefa['dataFinal']),
                Text(tarefa['responsavelId'].toString()),
                Text(tarefa['idosoId'].toString()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 8.0, 16.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 123, 11, 3),
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
                      padding:
                          const EdgeInsets.fromLTRB(60.0, 16.0, 16.0, 16.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          elevation: 15,
                        ),
                        child: const Text(
                          'EDITAR',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CriarTarefa(tarefa: tarefa, token: token),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(60.0, 16.0, 16.0, 16.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 15,
                        ),
                        child: const Text(
                          'EXCLUIR',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Widget okButton = FlatButton(
                            child: const Text("CANCELAR"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          Widget cancelaButton = FlatButton(
                            child: const Text("OK"),
                            onPressed: () {
                              _excluirTarefa(tarefa['id'].toString(), context);
                              Navigator.of(context).pop();
                            },
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Tem certeza?"),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  okButton,
                                  cancelaButton,
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          elevation: 15,
                        ),
                        child: const Text(
                          'FINALIZAR',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
