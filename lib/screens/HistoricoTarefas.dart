import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomePage.dart';
import 'TarefaFinalizada.dart';

class HistoricoTarefas extends StatefulWidget {
  var token;
  HistoricoTarefas({Key? key, required this.token}) : super(key: key);

  @override
  State<HistoricoTarefas> createState() => _HistoricoTarefasState();
}

class _HistoricoTarefasState extends State<HistoricoTarefas> {
  Future<List> pegarTarefas() async {
    var token = widget.token;
    var headers = {'Authorization': 'Bearer $token'};
    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/tarefa/finalizadas");
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Erro ao carregar tarefas");
    }
  }

  late Future<List> todasTarefasFinalizadas;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todasTarefasFinalizadas = pegarTarefas();
  }

  Future<void> _recarregaLista() async {
    setState(() {
      todasTarefasFinalizadas = pegarTarefas();
    });
  }

  @override
  Widget build(BuildContext context) {
    var listTarefas = pegarTarefas();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(token: widget.token),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tarefas finalizadas'),
        ),
        body: FutureBuilder<List>(
          future: listTarefas,
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
                              builder: (context) => TarefaFinalizada(
                                  tarefa: tarefa, token: widget.token),
                            ),
                          );
                          if (retorno) {
                            setState(() {
                              todasTarefasFinalizadas = pegarTarefas();
                            });
                          }
                        },
                        leading: const Icon(Icons.event_available, size: 50),
                        title: Text(tarefa['descricao']),
                        // ignore: prefer_interpolation_to_compose_strings
                        subtitle:
                            Text('Finalizada em ' + tarefa['dataFinalizacao']),
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
      ),
    );
  }
}
