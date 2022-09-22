import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login.page.dart';
import 'package:flutter_application_1/screens/tarefas.page.dart';

class HomePage extends StatefulWidget {
  var token;
  HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool?> confirmacaoSairDoApp() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Deseja sair do AMAAI?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: const Text('Sair'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final confirmacao = await confirmacaoSairDoApp();
        return confirmacao ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          leading: const Icon(Icons.home),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 170,
                    width: 150,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.fromBorderSide(
                        BorderSide(
                          width: 4,
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ), //BorderSide
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TarefasPage(token: widget.token)),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.calendar_today,
                            size: 80,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Tarefas Agendadas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 170,
                    width: 150,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.fromBorderSide(
                        BorderSide(
                          width: 4,
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ), //BorderSide
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.account_circle_outlined,
                            size: 80,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Dados da conta',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 170,
                    width: 150,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.fromBorderSide(
                        BorderSide(
                          width: 4,
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ), //BorderSide
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.task_alt_outlined,
                            size: 80,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Histórico de Tarefas',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 170,
                    width: 150,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.fromBorderSide(
                        BorderSide(
                          width: 4,
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ), //BorderSide
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        _deslogarDaConta();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.exit_to_app,
                            size: 80,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Sair',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool?> _deslogarDaConta() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Deseja deslogar do AMAAI?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Sim'),
              ),
            ],
          );
        });
  }
}
