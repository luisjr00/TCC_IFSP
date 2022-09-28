import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:flutter_application_1/components/CampoCEP.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/CampoData.dart';
import '../components/CampoPreenchimento.dart';
import '../models/Token.dart';

class EdicaoDeDados extends StatefulWidget {
  var token;
  EdicaoDeDados({Key? key, required this.token}) : super(key: key);

  @override
  State<EdicaoDeDados> createState() => _EdicaoDeDadosState();
}

class _EdicaoDeDadosState extends State<EdicaoDeDados> {
  Future<http.Response> recuperaDados(String id) async {
    String token = widget.token;
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/RecuperaEAtualizaDados/$id");
    var response = await http.get(url, headers: headers);

    return response;
  }

  void recuperaDadosEConverte(String id) async {
    var response = await recuperaDados(id);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      controladorCampoNome.text = json['nome'].toString();
      controladorCampoUsername.text = json['username'].toString();
      controladorCampoCpf.text = json['cpf'].toString();
      controladorCampoDataNasc.text = json['dataNascimento'].toString();
      controladorCampoTelefone.text = json['telefone'].toString();
      controladorCampoEmail.text = json['email'].toString();
      controladorCampoEndereco.text = json['endereco'].toString();
    } else {
      String mensagem = "Falha ao carregar dados";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> realizaUpdateDeDados(
      DadosAtualizados dados, String id) async {
    String token = widget.token;
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var cadastroJson = jsonEncode({
      "username": dados.username,
      "email": dados.email,
      "nome": dados.nome,
      "cpf": dados.cpf,
      "dataNascimento": dados.dataNascimento,
      "telefone": dados.telefone,
      "endereco": dados.endereco
    });

    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/RecuperaEAtualizaDados/$id");
    var response = await http.put(url, headers: headers, body: cadastroJson);

    return response;
  }

  void atualizaDados(DadosAtualizados dados, String id) async {
    var response = await realizaUpdateDeDados(dados, id);
    String mensagem;
    if (response.statusCode == 204) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await Future.delayed(const Duration(seconds: 2));
      limpaControles();
      setState(() {
        Navigator.pop(context);
        recuperaDadosEConverte(id);
      });
      var snackBar = const SnackBar(
        content: Text('Dados atualizados com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      mensagem = "Falha ao atualizar dados";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  void limpaControles() {
    controladorCampoNome.text = "";
    controladorCampoUsername.text = "";
    controladorCampoCpf.text = "";
    controladorCampoDataNasc.text = "";
    controladorCampoTelefone.text = "";
    controladorCampoEmail.text = "";
    controladorCampoEndereco.text = "";
    controladorCampoEndereco.text = "";
  }

  final controladorCampoNome = TextEditingController();
  final controladorCampoUsername = TextEditingController();
  final controladorCampoCpf = TextEditingController();
  final controladorCampoDataNasc = TextEditingController();
  final controladorCampoTelefone = TextEditingController();
  final controladorCampoEmail = TextEditingController();
  final controladorCampoEndereco = TextEditingController();
  final controladorCampoCEP = TextEditingController();
  bool bloqueado = true;
  IconData icone = Icons.edit;

  String id = '';
  @override
  Widget build(BuildContext context) {
    id = ConverteToken(widget.token).ConverteTokenParaId();
    recuperaDadosEConverte(id);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edição de dados responsavel"),
          actions: <Widget>[
            IconButton(
              icon: Icon(icone),
              onPressed: () {
                setState(() {
                  if (bloqueado == true) {
                    bloqueado = false;
                    icone = Icons.edit_off_outlined;
                  } else {
                    bloqueado = true;
                    icone = Icons.edit;
                  }
                });
              },
            )
          ],
        ),
        body: Form(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  children: [
                    CampoPreenchimento(
                      controlador: controladorCampoNome,
                      rotulo: 'Nome Completo',
                      icone: Icons.person,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoUsername,
                      rotulo: 'Username',
                      icone: Icons.account_circle_outlined,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoCpf,
                      rotulo: 'CPF',
                      teclado: TextInputType.number,
                      icone: Icons.pin,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoData(
                      controlador: controladorCampoDataNasc,
                      rotulo: "Data de Nascimento",
                      naoMostrar: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoTelefone,
                      rotulo: 'Telefone (fixo ou celular)',
                      dica: '11 99999-9999',
                      teclado: TextInputType.phone,
                      icone: Icons.phone,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoEmail,
                      rotulo: 'Email',
                      dica: 'name@example.com',
                      teclado: TextInputType.emailAddress,
                      icone: Icons.email,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (bloqueado == true)
                      CampoPreenchimento(
                        controlador: controladorCampoEndereco,
                        rotulo: 'Endereco',
                        teclado: TextInputType.name,
                        icone: Icons.home,
                        enable: bloqueado,
                      ),
                    if (bloqueado == false)
                      CampoCEP(
                        controladorCEP: controladorCampoCEP,
                        controladorEnderecoCompleto: controladorCampoEndereco,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (bloqueado == false)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            bloqueado = true;
                            icone = Icons.edit;
                          });
                          var dados = DadosAtualizados(
                              controladorCampoNome.text,
                              controladorCampoUsername.text,
                              controladorCampoCpf.text,
                              controladorCampoDataNasc.text,
                              controladorCampoTelefone.text,
                              controladorCampoEmail.text,
                              controladorCampoEndereco.text);
                          atualizaDados(dados, id);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          primary: Colors.white,
                        ),
                        child: const Text("Finalizar edição"),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ));
  }
}

class EdicaoDeDadosAssistido extends StatefulWidget {
  var token;
  EdicaoDeDadosAssistido({Key? key, required this.token}) : super(key: key);

  @override
  State<EdicaoDeDadosAssistido> createState() => _EdicaoDeDadosAssistidoState();
}

class _EdicaoDeDadosAssistidoState extends State<EdicaoDeDadosAssistido> {
  Future<http.Response> recuperaDados(String id) async {
    String token = widget.token;
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/RecuperaEAtualizaDados/assistido/$id");
    var response = await http.get(url, headers: headers);

    return response;
  }

  void recuperaDadosEConverte(String id) async {
    var response = await recuperaDados(id);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      controladorCampoNome.text = json['nome'].toString();
      controladorCampoUsername.text = json['username'].toString();
      controladorCampoCpf.text = json['cpf'].toString();
      controladorCampoDataNasc.text = json['dataNascimento'].toString();
      controladorCampoTelefone.text = json['telefone'].toString();
      controladorCampoEndereco.text = json['endereco'].toString();
    } else {
      String mensagem = "Falha ao carregar dados";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> realizaUpdateDeDados(
      DadosAtualizados dados, String id) async {
    String token = widget.token;
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var cadastroJson = jsonEncode({
      "username": dados.username,
      "nome": dados.nome,
      "cpf": dados.cpf,
      "dataNascimento": dados.dataNascimento,
      "telefone": dados.telefone,
      "endereco": dados.endereco
    });

    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/RecuperaEAtualizaDados/assistido/$id");
    var response = await http.put(url, headers: headers, body: cadastroJson);

    return response;
  }

  void atualizaDados(DadosAtualizados dados, String id) async {
    var response = await realizaUpdateDeDados(dados, id);
    String mensagem;
    if (response.statusCode == 204) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await Future.delayed(const Duration(seconds: 2));
      limpaControles();
      setState(() {
        Navigator.pop(context);
        recuperaDadosEConverte(id);
      });
      var snackBar = const SnackBar(
        content: Text('Dados atualizados com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      mensagem = "Falha ao atualizar dados";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  void limpaControles() {
    controladorCampoNome.text = "";
    controladorCampoUsername.text = "";
    controladorCampoCpf.text = "";
    controladorCampoDataNasc.text = "";
    controladorCampoTelefone.text = "";
    controladorCampoEndereco.text = "";
    controladorCampoEndereco.text = "";
  }

  final controladorCampoNome = TextEditingController();
  final controladorCampoUsername = TextEditingController();
  final controladorCampoCpf = TextEditingController();
  final controladorCampoDataNasc = TextEditingController();
  final controladorCampoTelefone = TextEditingController();
  final controladorCampoEndereco = TextEditingController();
  final controladorCampoCEP = TextEditingController();
  bool bloqueado = true;
  IconData icone = Icons.edit;

  String id = '';
  @override
  Widget build(BuildContext context) {
    id = ConverteToken(widget.token).verificaSeTemAssistidoCadastrado();
    recuperaDadosEConverte(id);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edição de dados Assistido"),
          actions: <Widget>[
            IconButton(
              icon: Icon(icone),
              onPressed: () {
                setState(() {
                  if (bloqueado == true) {
                    bloqueado = false;
                    icone = Icons.edit_off_outlined;
                  } else {
                    bloqueado = true;
                    icone = Icons.edit;
                  }
                });
              },
            )
          ],
        ),
        body: Form(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  children: [
                    CampoPreenchimento(
                      controlador: controladorCampoNome,
                      rotulo: 'Nome Completo',
                      icone: Icons.person,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoUsername,
                      rotulo: 'Username',
                      icone: Icons.account_circle_outlined,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoCpf,
                      rotulo: 'CPF',
                      teclado: TextInputType.number,
                      icone: Icons.pin,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoData(
                      controlador: controladorCampoDataNasc,
                      rotulo: "Data de Nascimento",
                      naoMostrar: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoTelefone,
                      rotulo: 'Telefone (fixo ou celular)',
                      dica: '11 99999-9999',
                      teclado: TextInputType.phone,
                      icone: Icons.phone,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (bloqueado == true)
                      CampoPreenchimento(
                        controlador: controladorCampoEndereco,
                        rotulo: 'Endereco',
                        teclado: TextInputType.name,
                        icone: Icons.home,
                        enable: bloqueado,
                      ),
                    if (bloqueado == false)
                      CampoCEP(
                        controladorCEP: controladorCampoCEP,
                        controladorEnderecoCompleto: controladorCampoEndereco,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (bloqueado == false)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            bloqueado = true;
                            icone = Icons.edit;
                          });
                          var dados = DadosAtualizados(
                              controladorCampoNome.text,
                              controladorCampoUsername.text,
                              controladorCampoCpf.text,
                              controladorCampoDataNasc.text,
                              controladorCampoTelefone.text,
                              null,
                              controladorCampoEndereco.text);
                          atualizaDados(dados, id);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          primary: Colors.white,
                        ),
                        child: const Text("Finalizar edição"),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ));
  }
}

class DadosAtualizados {
  String? nome;
  String? username;
  String? cpf;
  String? dataNascimento;
  String? telefone;
  String? email;
  String? endereco;

  DadosAtualizados(this.nome, this.username, this.cpf, this.dataNascimento,
      this.telefone, this.email, this.endereco);
}
