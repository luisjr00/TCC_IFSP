import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/tarefa.page.dart';
import 'package:http/http.dart' as http;

class TarefasPage extends StatelessWidget {
  TarefasPage({Key? key}) : super(key: key);

  Future<List> pegarTarefas() async {
    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa");
    var response = await http.get(url);
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
        title: const Text("Tarefas"),
      ),
      body: FutureBuilder<List>(
          future: pegarTarefas(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar tarefas'),
              );
            }
            if (snapshot.hasData) {
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
                            builder: (context) => TarefaPage(tarefa: tarefa),
                          ),
                        );
                      }, // chamar metodo que mostra a tarefa,
                      leading: const Icon(Icons.calendar_today, size: 50),
                      title: Text(tarefa['descricao']),
                      subtitle: Text(tarefa['dataInicio']),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
