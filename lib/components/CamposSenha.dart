import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class CamposSenha extends StatefulWidget {
  final TextEditingController controlador;
  final String rotulo;
  const CamposSenha({Key? key, required this.controlador, required this.rotulo})
      : super(key: key);

  @override
  State<CamposSenha> createState() => _CamposSenhaState();
}

class _CamposSenhaState extends State<CamposSenha> {
  bool _mostrarSenha = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controlador,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(1.0),
        labelText: widget.rotulo,
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
          Validatorless.min(6, "Senha precisa ter no mínimo 6 caracteres"),
        ],
      ),
    );
  }
}
