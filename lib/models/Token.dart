import 'package:jwt_decoder/jwt_decoder.dart';

class ConverteToken {
  String token;

  ConverteToken(this.token);

  String ConverteTokenParaRole() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String role = (decodedToken[
        "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"]);
    return role;
  }

  String ConverteTokenParaId() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String id = (decodedToken["id"]);
    return id;
  }

  String verificaSeTemAssistidoCadastrado() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    var verificado = (decodedToken["assistido"]);
    if (verificado == 0 || verificado == null) return "0";
    return verificado;
  }
}
