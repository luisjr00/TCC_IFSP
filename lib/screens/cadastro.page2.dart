// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/CampoData.dart';
import '../components/CampoPreenchimento.dart';
import '../components/CamposSenha.dart';
import '../components/LogoETitulo.dart';
import '../models/CadastroUsuario.dart';
import 'login.page.dart';

// ignore: must_be_immutable
class CadastroPage2 extends StatefulWidget {
  String code;
  CadastroPage2({Key? key, required this.code}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<CadastroPage2> createState() => _CadastroPage2(code);
}

class _CadastroPage2 extends State<CadastroPage2> {
  String code;

  _CadastroPage2(this.code);

  final _formKey = GlobalKey<FormState>();
  final loading = ValueNotifier<bool>(false);

  final _controladorCampoNome = TextEditingController();
  final _controladorCampoUsername = TextEditingController();
  final _controladorCampoCpf = TextEditingController();
  final _controladorCampoDataNasc = TextEditingController();
  final _controladorCampoTelefone = TextEditingController();
  final _controladorCampoEndereco = TextEditingController();
  final _controladorCampoSenha = TextEditingController();
  final _controladorCampoConfSenha = TextEditingController();

  @override
  void dispose() {
    _controladorCampoNome.dispose();
    _controladorCampoUsername.dispose();
    _controladorCampoCpf.dispose();
    _controladorCampoDataNasc.dispose();
    _controladorCampoTelefone.dispose();
    _controladorCampoEndereco.dispose();
    _controladorCampoSenha.dispose();
    _controladorCampoConfSenha.dispose();
    super.dispose();
  }

  int _extraiResponsavelId(String code) {
    int id = 0;
    int inicio = code.length - 5;
    var result = code.substring(inicio);
    id = int.tryParse(result.toString())!;
    return id;
  }

  void _criaCadastro(CadastroUsuario cadastro) async {
    var response = await realizaCadastro(cadastro);
    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      var snackBar = const SnackBar(
        content: Text('Cadastro do assistido realizado com sucesso!'),
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } else if (response.statusCode == 500) {
      var mensagem = Text(json[0]['message']).toString();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    } else {
      var mensagem = json['errors']['RePassword'].toString();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> realizaCadastro(CadastroUsuario cadastro) async {
    var headers = {'Content-Type': 'Application/json'};

    var cadastroJson = jsonEncode({
      "username": cadastro.Username,
      "Password": cadastro.Senha,
      "RePassword": cadastro.Confsenha,
      "Nome": cadastro.Nome,
      "Cpf": cadastro.Cpf,
      "DataNascimento": cadastro.DataNasc,
      "Telefone": cadastro.Telefone,
      "Endereco": cadastro.Endereco,
      "ResponsavelId": cadastro.ResponsavelId
    });
    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/cadastroassistido");
    var response = await http.post(url, headers: headers, body: cadastroJson);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(null),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            LogoTitulo(titulo: "Pessoa Assistida"),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    var formValid = _formKey.currentState?.validate() ?? false;
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(18)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.indigo),
                    shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder(
                            //borderRadius: BorderRadius.circular(100),
                            //side: BorderSide(color: Colors.indigo)
                            )),
                  ),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset("assets/up_arrow.png"),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  CampoPreenchimento(
                      controlador: _controladorCampoNome,
                      rotulo: 'Nome Completo',
                      icone: Icons.person),
                  const Divider(),
                  CampoPreenchimento(
                      controlador: _controladorCampoUsername,
                      rotulo: 'Username',
                      icone: Icons.account_circle_outlined),
                  const Divider(),
                  CampoPreenchimento(
                      controlador: _controladorCampoCpf,
                      rotulo: 'CPF',
                      teclado: TextInputType.number,
                      icone: Icons.pin),
                  const Divider(),
                  CampoData(
                    controlador: _controladorCampoDataNasc,
                    rotulo: "Data de Nascimento",
                  ),
                  CampoPreenchimento(
                      controlador: _controladorCampoTelefone,
                      rotulo: 'Telefone (fixo ou celular)',
                      dica: '11 99999-9999',
                      teclado: TextInputType.phone,
                      icone: Icons.phone),
                  CampoPreenchimento(
                      controlador: _controladorCampoEndereco,
                      rotulo: 'Endereço',
                      dica: 'Rua Exemplo, 999 - Exemplo - 99999-999',
                      icone: Icons.home),
                  CamposSenha(
                    controlador: _controladorCampoSenha,
                    rotulo: 'Senha',
                  ),
                  CamposSenha(
                      controlador: _controladorCampoConfSenha,
                      rotulo: 'Confirmar Senha'),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.3, 1],
                        colors: [
                          Colors.blue[900]!,
                          Colors.blue,
                        ],
                      ),
                    ),
                    child: SizedBox.expand(
                      child: TextButton(
                        child: AnimatedBuilder(
                            animation: loading,
                            builder: (context, _) {
                              return loading.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Cadastrar Dados",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    );
                            }),
                        onPressed: () {
                          var formValid =
                              _formKey.currentState?.validate() ?? false;
                          if (formValid) {
                            var responsavelId = _extraiResponsavelId(code);
                            var cadastro = CadastroUsuario(
                                _controladorCampoNome.text,
                                _controladorCampoUsername.text,
                                _controladorCampoCpf.text,
                                _controladorCampoDataNasc.text,
                                _controladorCampoTelefone.text,
                                _controladorCampoEndereco.text,
                                _controladorCampoSenha.text,
                                _controladorCampoConfSenha.text);
                            cadastro.ResponsavelId = responsavelId;
                            _criaCadastro(cadastro);
                            loading.value = !loading.value;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
