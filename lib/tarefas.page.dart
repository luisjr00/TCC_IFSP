import 'dart:convert';

import 'package:flutter/material.dart';
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
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today, size: 50),
                      title: Text(snapshot.data![index]['descricao']),
                      subtitle: Text(snapshot.data![index]['dataInicio']),
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
