import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CampoPreenchimento.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:validatorless/validatorless.dart';

class CampoCEP extends StatefulWidget {
  final TextEditingController controladorCEP;
  final TextEditingController controladorEnderecoCompleto;
  final String? rotulo;
  final IconData? icone;
  final String? dica;
  final TextInputType? teclado;

  const CampoCEP({
    super.key,
    required this.controladorCEP,
    this.rotulo,
    this.dica,
    this.icone,
    this.teclado,
    required this.controladorEnderecoCompleto,
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

  var retornoMensagemErroEndereco = false;
  String mensagemErroCep = 'CEP invalido';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controladorCEP,
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
              onPressed: () async {
                if (widget.controladorCEP.text.isEmpty) {
                  setState(() {
                    widget.controladorEnderecoCompleto.text = '';
                    retornoMensagemErroEndereco = true;
                    mensagemErroCep = 'Campo requerido';
                  });
                } else {
                  try {
                    var response =
                        await getEndereco(widget.controladorCEP.text);
                    if (response.statusCode == 200) {
                      var json = jsonDecode(utf8.decode(response.bodyBytes));
                      Endereco criaEndereco = Endereco(
                          json['uf'],
                          json['localidade'],
                          json['bairro'],
                          json['logradouro']);
                      setState(() {
                        retornoMensagemErroEndereco = false;
                        widget.controladorEnderecoCompleto.text =
                            criaEndereco.toString();
                      });
                    }
                  } catch (exception) {
                    setState(() {
                      widget.controladorEnderecoCompleto.text = '';
                      retornoMensagemErroEndereco = true;
                    });
                  }
                }
              },
            ),
            errorText: retornoMensagemErroEndereco ? mensagemErroCep : null,
          ),
          style: const TextStyle(fontSize: 20),
          validator: Validatorless.multiple(
            [
              Validatorless.required("Campo requerido"),
            ],
          ),
        ),
        CampoPreenchimentoArea(
          controlador: widget.controladorEnderecoCompleto,
          rotulo: "Endereço",
          icone: Icons.home,
          enable: true,
        ),
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
    return "$NomeRua - $Bairro - $Cidade/$Estado";
  }

  Endereco(this.Estado, this.Cidade, this.Bairro, this.NomeRua);
}
