import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class CampoPreenchimento extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final IconData? icone;
  final String? dica;
  final TextInputType? teclado;

  const CampoPreenchimento({
    super.key,
    required this.controlador,
    required this.rotulo,
    this.dica,
    this.icone,
    this.teclado,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      // ignore: prefer_if_null_operators
      keyboardType: teclado != null ? teclado : TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: icone != null ? Icon(icone) : null,
        labelText: rotulo,
        // ignore: prefer_if_null_operators
        hintText: dica != null ? dica : null,
        labelStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple(
        [
          Validatorless.required("Campo requerido"),
          Validatorless.min(3, "Campo precisa de no mínimo 3 caracteres"),
        ],
      ),
    );
  }
}

class CampoPreenchimentoEmail extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final IconData? icone;
  final String? dica;
  final TextInputType? teclado;

  const CampoPreenchimentoEmail({
    super.key,
    required this.controlador,
    required this.rotulo,
    this.dica,
    this.icone,
    this.teclado,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      // ignore: prefer_if_null_operators
      keyboardType: teclado != null ? teclado : TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: icone != null ? Icon(icone) : null,
        labelText: rotulo,
        // ignore: prefer_if_null_operators
        hintText: dica != null ? dica : null,
        labelStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple(
        [
          Validatorless.required("Campo requerido"),
          Validatorless.email("Informe um email valido"),
        ],
      ),
    );
  }
}

class CampoPreenchimentoCpf extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final IconData? icone;
  final String? dica;
  final TextInputType? teclado;

  const CampoPreenchimentoCpf({
    super.key,
    required this.controlador,
    required this.rotulo,
    this.dica,
    this.icone,
    this.teclado,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      // ignore: prefer_if_null_operators
      keyboardType: teclado != null ? teclado : TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: icone != null ? Icon(icone) : null,
        labelText: rotulo,
        // ignore: prefer_if_null_operators
        hintText: dica != null ? dica : null,
        labelStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple(
        [
          Validatorless.required("Campo requerido"),
          Validatorless.cpf("Informe um CPF valido"),
        ],
      ),
    );
  }
}
