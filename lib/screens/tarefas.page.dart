import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/tarefa.page.dart';
import 'package:http/http.dart' as http;

import 'CriarTarefaPage.dart';

// ignore: must_be_immutable

class TarefasPage extends StatefulWidget {
  var token;
  TarefasPage({Key? key, required this.token});

  @override
  State<TarefasPage> createState() => _TarefasPageState(token);
}

class _TarefasPageState extends State<TarefasPage> {
  var token;
  _TarefasPageState(this.token);

  Future<List> pegarTarefas() async {
    var headers = {'Authorization': 'Bearer $token'};
    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa");
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Erro ao carregar tarefas");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
        leading: const Icon(Icons.calendar_today),
      ),
      body: FutureBuilder<List>(
        future: pegarTarefas(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar tarefas'),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data! == null || snapshot.data!.length == 0) {
              return const Center(
                child: Text('Não existe tarefas'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var tarefa = snapshot.data![index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TarefaPage(tarefa: tarefa, token: token),
                        ),
                      );
                    },
                    leading: const Icon(Icons.calendar_today, size: 50),
                    title: Text(tarefa['descricao']),
                    subtitle: Text(tarefa['dataInicio']),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CriarTarefa(token: token),
            ),
          );
        },
        tooltip: 'Criar tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }
}



























  // Future<List> pegarTarefas() async {
  //   var headers = {'Authorization': 'Bearer $token'};

  //   var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa");
  //   var response = await http.get(url, headers: headers);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(utf8.decode(response.bodyBytes));
  //   } else {
  //     throw Exception("Erro ao carregar tarefas");
  //   }
  // }

  // if (snapshot.data! == null || snapshot.data!.length == 0) {
  //             return const Center(
  //               child: Text('Não existe tarefas'),
  //             );
  //           }