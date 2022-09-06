import 'package:flutter/material.dart';
import 'package:flutter_application_1/cadastro.page1.dart';
import 'package:flutter_application_1/cadastroRefatorada.dart';

import 'login.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste TCC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const LoginPage(),
    );
  }
}
