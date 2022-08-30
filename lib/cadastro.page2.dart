import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CadastroPage2 extends StatefulWidget {
  const CadastroPage2({Key? key}) : super(key: key);
  
  @override
  State<CadastroPage2> createState() => _CadastroPage2();
}


class _CadastroPage2 extends State<CadastroPage2> {

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
    );
  }
}       
      