import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CampoCEP extends StatefulWidget {
  final TextEditingController controlador;
  final String? rotulo;
  final IconData? icone;
  final String? dica;
  final TextInputType? teclado;

  const CampoCEP({
    super.key,
    required this.controlador,
    this.rotulo,
    this.dica,
    this.icone,
    this.teclado,
  });

  @override
  State<CampoCEP> createState() => _CampoCEPState();
}

class _CampoCEPState extends State<CampoCEP> {
  Future<http.Response> getEndereco(String cep) async {
    var url = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    var response = await http.get(url);

    return response;
  }

  void buscaEndereco(String cep) async {
    try {
      var response = await getEndereco(cep);
      if (response.statusCode == 200) {
        var json = jsonDecode(utf8.decode(response.bodyBytes));

        Endereco criaEndereco = Endereco(
            json['uf'], json['localidade'], json['bairro'], json['logradouro']);
        setState(() {
          endereco = criaEndereco;
          retornoMensagemErroEndereco = false;
        });
      }
    } catch (Excepetsion) {
      setState(() {
        retornoMensagemErroEndereco = true;
        endereco = null;
      });
    }
  }

  var endereco;
  var retornoMensagemErroEndereco = false;
  String mensagemErroCep = 'CEP invalido';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controlador,
          // ignore: prefer_if_null_operators
          keyboardType:
              widget.teclado != null ? widget.teclado : TextInputType.number,

          decoration: InputDecoration(
            prefixIcon: widget.icone != null
                ? Icon(widget.icone)
                : const Icon(Icons.pin),
            labelText: "CEP",
            // ignore: prefer_if_null_operators
            hintText: "00000-000",
            labelStyle: const TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (widget.controlador.text.isEmpty) {}
                buscaEndereco(widget.controlador.text);
              },
            ),
            errorText: retornoMensagemErroEndereco ? mensagemErroCep : null,
          ),
          style: const TextStyle(fontSize: 20),
        ),
        endereco == null ? const Text('') : Text(endereco.toString()),
      ],
    );
  }
}

class Endereco {
  final String Estado;
  final String Cidade;
  final String Bairro;
  final String NomeRua;
  String? numero;

  @override
  toString() {
    return "Estado: $Estado, Cidade: $Cidade, Bairro: $Bairro, Rua: $NomeRua";
  }

  Endereco(this.Estado, this.Cidade, this.Bairro, this.NomeRua);
}
