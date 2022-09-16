class CadastroUsuario {
  final String Nome;
  final String Username;
  final String Cpf;
  final String DataNasc;
  final String Telefone;
  String? Email;
  final String Endereco;
  final String Senha;
  final String Confsenha;
  int? ResponsavelId;

  CadastroUsuario(this.Nome, this.Username, this.Cpf, this.DataNasc,
      this.Telefone, this.Endereco, this.Senha, this.Confsenha);
}
