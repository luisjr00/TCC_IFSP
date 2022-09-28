import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/CampoCEP.dart';
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
      print("erro");
    }
  }

  final controladorCampoNome = TextEditingController();
  final controladorCampoUsername = TextEditingController();
  final controladorCampoCpf = TextEditingController();
  final controladorCampoDataNasc = TextEditingController();
  final controladorCampoTelefone = TextEditingController();
  final controladorCampoEmail = TextEditingController();
  final controladorCampoEndereco = TextEditingController();
  final controladorCampoSenha = TextEditingController();
  final controladorCampoConfSenha = TextEditingController();
  final controladorCampoCEP = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String id = ConverteToken(widget.token).ConverteTokenParaId();
    recuperaDadosEConverte(id);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edicao de dados"),
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
                      enable: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoUsername,
                      rotulo: 'Username',
                      icone: Icons.account_circle_outlined,
                      enable: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoCpf,
                      rotulo: 'CPF',
                      teclado: TextInputType.number,
                      icone: Icons.pin,
                      enable: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoData(
                      controlador: controladorCampoDataNasc,
                      rotulo: "Data de Nascimento",
                      naoMostrar: true,
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
                      enable: true,
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
                      enable: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoEndereco,
                      rotulo: 'Endereco',
                      teclado: TextInputType.name,
                      icone: Icons.home,
                      enable: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoCEP(
                        controladorCEP: controladorCampoCEP,
                        controladorEnderecoCompleto: controladorCampoEndereco,
                        rotulo: 'Endereço',
                        dica: 'Rua Exemplo, 999 - Exemplo - 99999-999',
                        icone: Icons.home),
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
  String? cep;
}
