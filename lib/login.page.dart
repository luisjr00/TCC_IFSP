import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: const TextStyle(
                fontSize: 20
                ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
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
              style: const TextStyle(
                fontSize: 20
                ),
            ),
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  "Esqueceu a senha ?",
                  textAlign: TextAlign.right,
                ),
                onPressed: (){}, /*
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
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),  
                  ),
                ],
              ),
              onPressed: () => {},
            ),
          ),
        ),
        const SizedBox(
          height: 70,
        ),
        Container(
          height: 40,
          // ignore: prefer_const_constructors
          child: TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[ 
                Text("Não tem acesso?"),
                Text(
                  "  Cadastre-se",
                  //textAlign: TextAlign.center,
                  style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                    fontSize: 15,
                  ),
                ),
              ],
            )
                ),
              ),
          ], 
        ),
      ),  
    );
  }
}