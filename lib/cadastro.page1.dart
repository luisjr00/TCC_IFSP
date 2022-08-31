// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cadastro.page2.dart';
import 'dart:convert';

// ignore: must_be_immutable
class CadastroPage1 extends StatefulWidget {
  CadastroPage1({Key? key}) : super(key: key);
  final TextEditingController _controladorCampoNome = TextEditingController();

  @override
  State<CadastroPage1> createState() => _CadastroPage1();
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

class _CadastroPage1 extends State<CadastroPage1> {
  bool _mostrarSenha = false;
  bool _mostrarConfSenha = false;

  final TextEditingController _controladorCampoNome = TextEditingController();
  final TextEditingController _controladorCampoUsername =
      TextEditingController();
  final TextEditingController _controladorCampoCpf = TextEditingController();
  final TextEditingController _controladorCampoDataNasc =
      TextEditingController();
  final TextEditingController _controladorCampoTelefone =
      TextEditingController();
  final TextEditingController _controladorCampoEmail = TextEditingController();
  final TextEditingController _controladorCampoEndereco =
      TextEditingController();
  final TextEditingController _controladorCampoSenha = TextEditingController();
  final TextEditingController _controladorCampoConfSenha =
      TextEditingController();

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
    CadastroUsuario cadastro;

    void validaCadastro(CadastroUsuario cadastro) async {
      var response = await realizaCadastro(cadastro);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
      } else {
        print(response.body);
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 78,
              height: 78,
              child: Image.asset("assets/texte_cube.jpg"),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Tela de Cadastro Responsavel",
              textAlign: TextAlign.center,
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 25,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _controladorCampoNome,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                //hintText: "Ex: Luan Nascimento Júnior",Luis
                labelText: "Nome Completo",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            TextFormField(
              controller: _controladorCampoUsername,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_circle_outlined),
                //hintText: "Ex: Luan Nascimento Júnior",Luis
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            TextFormField(
              controller: _controladorCampoCpf,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.pin),
                //hintText: "Ex: Luan Nascimento Júnior",Luis
                labelText: "CPF",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            TextFormField(
              controller: _controladorCampoDataNasc,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.calendar_month),
                //hintText: "Ex: Luan Nascimento Júnior",Luis
                labelText: "Data Nascimento",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _controladorCampoTelefone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                hintText: "11 99999-9999",
                labelText: "Telefone (fixo ou celular)",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _controladorCampoEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "name.example@example.com",
                labelText: "Email",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _controladorCampoEndereco,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.home),
                hintText: "Rua Exemplo, 999 - Exemplo - 99999-999",
                labelText: "Endereço",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _controladorCampoSenha,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "Senha",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_mostrarSenha == false
                      ? Icons.visibility_off
                      : Icons.visibility),
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
                  fontSize: 16,
                ),
              ),
              obscureText: _mostrarSenha == false ? true : false,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _controladorCampoConfSenha,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Confirmar Senha",
                prefixIcon: const Icon(Icons.lock_reset),
                suffixIcon: IconButton(
                  icon: Icon(_mostrarConfSenha == false
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _mostrarConfSenha = !_mostrarConfSenha;
                    });
                  },
                ),
                //hintText: "*******",
                labelStyle: const TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              obscureText: _mostrarConfSenha == false ? true : false,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    cadastro = CadastroUsuario(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CadastroPage2(),
                      ),
                    );
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
          ],
        ),
      ),
    );
  }
}
