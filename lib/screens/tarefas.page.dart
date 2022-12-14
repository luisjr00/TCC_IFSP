import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/tarefa.page.dart';
import 'package:http/http.dart' as http;

import 'CriarTarefaPage.dart';
import 'HomePage.dart';

// ignore: must_be_immutable

class TarefasPage extends StatefulWidget {
  var token;
  TarefasPage({Key? key, required this.token});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  late Future<List> todasTarefas;

  Future<List> pegarTarefas() async {
    var token = widget.token;
    var headers = {'Authorization': 'Bearer $token'};
    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa");
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Erro ao carregar tarefas");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todasTarefas = pegarTarefas();
  }

  Future<void> _recarregaLista() async {
    setState(() {
      todasTarefas = pegarTarefas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(token: widget.token),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tarefas'),
        ),
        body: FutureBuilder<List>(
          future: todasTarefas,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao carregar tarefas'),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data! == null || snapshot.data!.length == 0) {
                return const Center(
                  child: Text('N??o existe tarefas'),
                );
              }
              return RefreshIndicator(
                onRefresh: _recarregaLista,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var tarefa = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          bool retorno = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TarefaPage(
                                  tarefa: tarefa, token: widget.token),
                            ),
                          );
                          if (retorno) {
                            setState(() {
                              todasTarefas = pegarTarefas();
                            });
                          }
                        },
                        leading: const Icon(Icons.calendar_today, size: 50),
                        title: Text(tarefa['descricao']),
                        // ignore: prefer_interpolation_to_compose_strings
                        subtitle: Text('Hora: ' +
                            tarefa['horaAlerta'] +
                            ', Data: ' +
                            tarefa['dataAlerta']),
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool criou = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CriarTarefa(token: widget.token),
              ),
            );
            if (criou) {
              setState(() {
                todasTarefas = pegarTarefas();
              });
            }
          },
          tooltip: 'Criar tarefa',
          child: const Icon(Icons.add),
        ),
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
  //               child: Text('N??o existe tarefas'),
  //             );
  //           }