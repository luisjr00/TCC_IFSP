import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TarefaPage extends StatelessWidget {
  Map<String, dynamic> tarefa;
  TarefaPage({Key? key, required this.tarefa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tarefa['descricao'])),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(tarefa['descricao']),
              Text(tarefa['dataInicio']),
              Text(tarefa['dataFinal']),
              Text(tarefa['responsavelId'].toString()),
              Text(tarefa['idosoId'].toString()),
            ],
          ),
        ),
      ),
    );
  }
}
