import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

class CampoData extends StatefulWidget {
  final TextEditingController controlador;
  final String rotulo;
  const CampoData({Key? key, required this.controlador, required this.rotulo})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<CampoData> createState() => _CampoDataState(controlador, rotulo);
}

class _CampoDataState extends State<CampoData> {
  TextEditingController controlador;
  final String rotulo;
  _CampoDataState(this.controlador, this.rotulo);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.calendar_month),
        labelText: rotulo,
        hintText: 'dd/mm/aaaa',
        labelStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple([
        Validatorless.required("Campo requerido"),
      ]),
      onTap: () async {
        DateTime? pickeddate = await showDatePicker(
          context: context,
          keyboardType: TextInputType.emailAddress,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          locale: const Locale("pt", "BR"),
        );

        if (pickeddate != null) {
          setState(() {
            controlador.text = DateFormat('dd/MM/yyyy').format(pickeddate);
          });
        }
      },
    );
  }
}
