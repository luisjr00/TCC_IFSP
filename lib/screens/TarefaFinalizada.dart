// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

// ignore: must_be_immutable
class TarefaFinalizada extends StatefulWidget {
  Map<String, dynamic> tarefa;
  var token;
  TarefaFinalizada({Key? key, required this.tarefa, this.token})
      : super(key: key);

  @override
  State<TarefaFinalizada> createState() => _TarefaFinalizadaState();
}

class _TarefaFinalizadaState extends State<TarefaFinalizada> {
  void _excluirTarefa(String id, BuildContext context) async {
    var response = await realizaDeleteTarefa(id);

    if (response.statusCode == 204) {
      var snackBar = SnackBar(
        content: const Text('Tarefa excluida com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
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
    var headers = {'Authorization': 'Bearer ${widget.token}'};

    var url =
        Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa/$id");

    var response = await http.delete(url, headers: headers);

    return response;
  }

  bool isSpeaking = false;
  final TextEditingController _controller = TextEditingController();
  final _flutterTts = FlutterTts();

  void initializeTts() {
    _flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    _flutterTts.setErrorHandler((message) {
      setState(() {
        isSpeaking = false;
      });
    });
    _flutterTts.setLanguage("pt-br");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeTts();
  }

  void speak() async {
    await _flutterTts.speak(widget.tarefa['descricao']);
  }

  void stop() async {
    await _flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Finalizada')),
      body: Center(
        child: Card(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.fromBorderSide(
                          BorderSide(
                              width: 4,
                              color: Colors.black,
                              style: BorderStyle.solid), //BorderSide
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                widget.tarefa['descricao'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Criada em ' + widget.tarefa['dataCriacao'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              Divider(),
                              Text(
                                'Finalizada em ' +
                                    widget.tarefa['dataFinalizacao'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              Divider(),
                              Text(
                                'Horario do alerta :' +
                                    widget.tarefa['horaAlerta'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  isSpeaking ? stop() : speak();
                                },
                                child: Text(isSpeaking ? "Parar" : "Repetir"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.fromBorderSide(
                            BorderSide(
                                width: 4,
                                color: Colors.black,
                                style: BorderStyle.solid), //BorderSide
                          )),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                widget.tarefa['horaAlerta'],
                                style: TextStyle(fontSize: 30),
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              Text(
                                widget.tarefa['dataAlerta'],
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      carregando
                          ? CircularProgressIndicator()
                          : TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                elevation: 15,
                              ),
                              child: Text(
                                'EXCLUIR',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  carregando = true;
                                });
                                Widget cancelaButton = FlatButton(
                                  child: const Text("CANCELAR"),
                                  onPressed: () {
                                    setState(() {
                                      carregando = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                                Widget okButton = FlatButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    _excluirTarefa(
                                        widget.tarefa['id'].toString(),
                                        context);
                                    setState(() {
                                      carregando = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Tem certeza?"),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      actions: [
                                        cancelaButton,
                                        okButton,
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
