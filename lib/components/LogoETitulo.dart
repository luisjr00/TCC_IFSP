import 'package:flutter/material.dart';

class LogoTitulo extends StatelessWidget {
  String titulo;
  LogoTitulo({Key? key, required this.titulo}) : super(key: key);

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
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
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
