// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:validatorless/validatorless.dart';
import 'cadastro.page2.dart';
import 'dart:convert';

// ignore: must_be_immutable
class CadastroRefatorada extends StatefulWidget {
  const CadastroRefatorada({Key? key}) : super(key: key);

  @override
  State<CadastroRefatorada> createState() => _CadastroRefatorada();
}

class _CadastroRefatorada extends State<CadastroRefatorada> {
  final _formKey = GlobalKey<FormState>();

  final _controladorCampoNome = TextEditingController();
  final _controladorCampoUsername = TextEditingController();
  final _controladorCampoCpf = TextEditingController();
  final _controladorCampoDataNasc = TextEditingController();
  final _controladorCampoTelefone = TextEditingController();
  final _controladorCampoEmail = TextEditingController();
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
    _controladorCampoEmail.dispose();
    _controladorCampoEndereco.dispose();
    _controladorCampoSenha.dispose();
    _controladorCampoConfSenha.dispose();
    super.dispose();
  }

  void _criaCadastro(CadastroUsuario cadastro, BuildContext context) {
    //validaCadastro(cadastro);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroPage2(),
      ),
    );
  }

  void validaCadastro(CadastroUsuario cadastro) async {
    var response = await realizaCadastro(cadastro);
    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CadastroPage2(),
        ),
      );
    } else if (response.statusCode == 500) {
      Widget okButton = FlatButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("ALERTA"),
            content: Text(json[0]['message']),
            actions: [
              okButton,
            ],
          );
        },
      );
    } else {
      var mensagem = json['errors']['RePassword'].toString();
      Widget okButton = FlatButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("ALERTA"),
            content: Text(mensagem),
            actions: [
              okButton,
            ],
          );
        },
      );
    }
  }

  Future<http.Response> realizaCadastro(CadastroUsuario cadastro) async {
    var headers = {'Content-Type': 'Application/json'};

    var cadastroJson = jsonEncode({
      "username": cadastro.Username,
      "Email": cadastro.Email,
      "Password": cadastro.senha,
      "RePassword": cadastro.Confsenha,
      "Nome": cadastro.Nome,
      "Cpf": cadastro.Cpf,
      "DataNascimento": cadastro.DataNasc,
      "Telefone": cadastro.Telefone,
      "Endereco": cadastro.Endereco
    });
    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/cadastro");
    var response = await http.post(url, headers: headers, body: cadastroJson);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Container(
        //color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 40,
            right: 40,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                LogoTitulo(),
                const SizedBox(
                  height: 15,
                ),
                CampoPreenchimento(
                    controlador: _controladorCampoNome,
                    rotulo: 'Nome Completo',
                    icone: Icons.person),
                CampoPreenchimento(
                    controlador: _controladorCampoUsername,
                    rotulo: 'Username',
                    icone: Icons.account_circle_outlined),
                CampoPreenchimento(
                    controlador: _controladorCampoCpf,
                    rotulo: 'CPF',
                    icone: Icons.pin),
                const SizedBox(
                  height: 10,
                ),
                CampoPreenchimento(
                    controlador: _controladorCampoDataNasc,
                    rotulo: 'Data Nascimento',
                    dica: 'dd/mm/aaaa',
                    icone: Icons.calendar_month),
                const SizedBox(
                  height: 10,
                ),
                CampoPreenchimento(
                    controlador: _controladorCampoTelefone,
                    rotulo: 'Telefone (fixo ou celular)',
                    dica: '11 99999-9999',
                    icone: Icons.phone),
                const SizedBox(
                  height: 10,
                ),
                CampoPreenchimento(
                    controlador: _controladorCampoEmail,
                    rotulo: 'Email',
                    dica: 'name@example.com',
                    icone: Icons.email),
                const SizedBox(
                  height: 10,
                ),
                CampoPreenchimento(
                    controlador: _controladorCampoEndereco,
                    rotulo: 'Endereço',
                    dica: 'Rua Exemplo, 999 - Exemplo - 99999-999',
                    icone: Icons.email),
                const SizedBox(
                  height: 10,
                ),
                CamposSenhas(
                  controlador: _controladorCampoSenha,
                  rotulo: 'Senha',
                ),
                const SizedBox(
                  height: 10,
                ),
                CamposSenhas(
                    controlador: _controladorCampoConfSenha,
                    rotulo: 'Confirmar Senha'),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        var formValid =
                            _formKey.currentState?.validate() ?? false;
                        if (formValid) {
                          var cadastro = CadastroUsuario(
                              _controladorCampoNome.text,
                              _controladorCampoUsername.text,
                              _controladorCampoCpf.text,
                              _controladorCampoDataNasc.text,
                              _controladorCampoTelefone.text,
                              _controladorCampoEmail.text,
                              _controladorCampoEndereco.text,
                              _controladorCampoSenha.text,
                              _controladorCampoConfSenha.text);
                          //validaCadastro(cadastro);
                        }
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
                        child: Image.asset("assets/down_arrow.png"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CadastroUsuario {
  final String Nome;
  final String Username;
  final String Cpf;
  final String DataNasc;
  final String Telefone;
  final String Email;
  final String Endereco;
  final String senha;
  final String Confsenha;

  CadastroUsuario(this.Nome, this.Username, this.Cpf, this.DataNasc,
      this.Telefone, this.Email, this.Endereco, this.senha, this.Confsenha);

  @override
  String toString() {
    return '$Username, $Cpf, $DataNasc, $Telefone, $Email, $Endereco, $senha, $Confsenha';
  }
}

class LogoTitulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 78,
          height: 78,
          child: Image.asset("assets/texte_cube.jpg"),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "Tela de Cadastro Responsável",
          textAlign: TextAlign.center,
          style: TextStyle(
            //fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 25,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class CampoPreenchimento extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String? dica;
  final IconData icone;

  const CampoPreenchimento(
      {super.key,
      required this.controlador,
      required this.rotulo,
      this.dica,
      required this.icone});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icone),
        labelText: rotulo,
        hintText: dica != null ? dica : null,
        labelStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple([
        Validatorless.required("Campo requerido"),
      ]),
    );
  }
}

class CamposSenhas extends StatefulWidget {
  final TextEditingController controlador;
  final String rotulo;
  const CamposSenhas(
      {Key? key, required this.controlador, required this.rotulo})
      : super(key: key);

  @override
  State<CamposSenhas> createState() => _CamposSenhasState(controlador, rotulo);
}

class _CamposSenhasState extends State<CamposSenhas> {
  bool _mostrarSenha = false;
  final TextEditingController controlador;
  final String rotulo;

  _CamposSenhasState(this.controlador, this.rotulo);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(1.0),
        labelText: rotulo,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
              _mostrarSenha == false ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _mostrarSenha = !_mostrarSenha;
            });
          },
        ),
        //hintText: "*******",
        labelStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      obscureText: _mostrarSenha == false ? true : false,
      style: const TextStyle(fontSize: 16),
      validator: Validatorless.multiple([
        Validatorless.required("Campo requerido"),
        Validatorless.min(6, "Senha precisa ter no mínimo 6 caracteres")
      ]),
    );
  }
}
