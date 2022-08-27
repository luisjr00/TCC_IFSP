import 'package:flutter/material.dart';
import 'package:flutter_application_1/cadastro.page.dart';

class Login {
  final String email;
  final String senha;

  Login(this.email, this.senha);

  @override
  String toString() {
    return 'Email = $email, Senha = $senha';
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _controladorCampoEmail = TextEditingController();
  final TextEditingController _controladorCampoSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Login login;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 128,
              height: 128,
              child: Image.asset("assets/texte_cube.jpg"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _controladorCampoEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _controladorCampoSenha,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: const TextStyle(fontSize: 20),
            ),
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  "Esqueceu a senha ?",
                  textAlign: TextAlign.right,
                ),
                onPressed:
                    () {}, /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordPage(),
                      ),
                    );
                */
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.3, 1],
                  colors: [
                    Colors.blue[900]!,
                    Colors.blue,
                  ],
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: SizedBox.expand(
                child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => {
                          login = Login(_controladorCampoEmail.text,
                              _controladorCampoSenha.text),
                          debugPrint(login.toString())
                        } // chamar o metodo que vai conexão com a api e validar o login
                    ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            SizedBox(
              height: 40,
              // ignore: prefer_const_constructors
              child: Row(
                //onPressed: () {},              CadastroPage
                //child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Não tem acesso? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroPage(),
                      ),
                    );
                    },
                    // ignore: prefer_const_constructors
                    child: Text(
                      "Cadastre-se",
                      //textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
