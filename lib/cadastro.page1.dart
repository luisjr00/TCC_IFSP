// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'cadastro.page2.dart';

// ignore: must_be_immutable
class CadastroPage1 extends StatefulWidget {
  const CadastroPage1({Key? key}) : super(key: key);
  
  @override
  State<CadastroPage1> createState() => _CadastroPage1();
}


class _CadastroPage1 extends State<CadastroPage1> {

  bool _mostrarSenha = false;
  bool _mostrarConfSenha = false;

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
            const Text("Tela de Cadastro",
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
              //controller: _controladorCampoEmail,
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
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              //controller: _controladorCampoEmail,
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
              //controller: _controladorCampoEmail,
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
              //controller: _controladorCampoEmail,
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
              //controller: _controladorCampoEmail,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "Senha",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  child: Icon( _mostrarSenha == false ? Icons.visibility_off : Icons.visibility),
                  onTap: (){
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
              //controller: _controladorCampoEmail,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Confirmar Senha",
                prefixIcon: const Icon(Icons.lock_reset),
                suffixIcon: GestureDetector(
                  child: Icon( _mostrarConfSenha == false ? Icons.visibility_off : Icons.visibility),
                  onTap: (){
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CadastroPage2(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(18)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                      shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder(
                          //borderRadius: BorderRadius.circular(100),
                          //side: BorderSide(color: Colors.indigo)
                        )
                      ),
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