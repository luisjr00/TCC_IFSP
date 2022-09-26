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
}