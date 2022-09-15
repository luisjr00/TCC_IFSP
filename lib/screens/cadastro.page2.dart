// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';
import 'dart:convert';

import '../components/CampoData.dart';
import '../components/CampoPreenchimento.dart';
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
      var snackBar = SnackBar(
        content: const Text('Cadastro do assistido realizado com sucesso!'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
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
      "Password": cadastro.senha,
      "RePassword": cadastro.Confsenha,
      "Nome": cadastro.Nome,
      "Cpf": cadastro.Cpf,
      "DataNascimento": cadastro.DataNasc,
      "Telefone": cadastro.Telefone,
      "Endereco": cadastro.Endereco,
      "ResponsavelId": cadastro.responsavelId
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
                const LogoTitulo(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        var formValid =
                            _formKey.currentState?.validate() ?? false;
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
                    teclado: TextInputType.number,
                    icone: Icons.pin),
                const SizedBox(
                  height: 10,
                ),
                CampoData(
                  controlador: _controladorCampoDataNasc,
                  rotulo: "Data de Nascimento",
                ),
                const SizedBox(
                  height: 10,
                ),
                CampoPreenchimento(
                    controlador: _controladorCampoTelefone,
                    rotulo: 'Telefone (fixo ou celular)',
                    dica: '11 99999-9999',
                    teclado: TextInputType.phone,
                    icone: Icons.phone),
                const SizedBox(
                  height: 10,
                ),
                CampoPreenchimento(
                    controlador: _controladorCampoEndereco,
                    rotulo: 'Endereço',
                    dica: 'Rua Exemplo, 999 - Exemplo - 99999-999',
                    icone: Icons.home),
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
                                _controladorCampoConfSenha.text,
                                responsavelId);
                            _criaCadastro(cadastro);
                            loading.value = !loading.value;
                          }
                        } // chamar o metodo que vai conexão com a api e validar o login
                        ),
                  ),
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
  final String Endereco;
  final String senha;
  final String Confsenha;
  final int responsavelId;

  CadastroUsuario(
      this.Nome,
      this.Username,
      this.Cpf,
      this.DataNasc,
      this.Telefone,
      this.Endereco,
      this.senha,
      this.Confsenha,
      this.responsavelId);

  @override
  String toString() {
    return '$Username, $Cpf, $DataNasc, $Telefone, $Endereco, $senha, $Confsenha';
  }
}

class LogoTitulo extends StatelessWidget {
  const LogoTitulo({Key? key}) : super(key: key);

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
          "Cadastro",
          textAlign: TextAlign.center,
          style: TextStyle(
            //fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 25,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "Pessoa Assistida",
          textAlign: TextAlign.center,
          style: TextStyle(
            //fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
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
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple(
        [
          Validatorless.required("Campo requerido"),
          Validatorless.min(6, "Senha precisa ter no mínimo 6 caracteres")
        ],
      ),
    );
  }
}
