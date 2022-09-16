import 'package:flutter/material.dart';

class AlertaMensagem extends StatefulWidget {
  String mensagem;
  AlertaMensagem({Key? key, required this.mensagem}) : super(key: key);

  @override
  _AlertaMensagemState createState() => _AlertaMensagemState();
}

class _AlertaMensagemState extends State<AlertaMensagem> {
  @override
  Widget build(BuildContext context) {
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    return AlertDialog(
      title: const Text("ALERTA"),
      content: Text(widget.mensagem),
      actions: [
        okButton,
      ],
    );
  }
}
