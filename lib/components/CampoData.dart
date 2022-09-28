import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

class CampoData extends StatefulWidget {
  final TextEditingController controlador;
  final String rotulo;
  final bool? naoMostrar;
  const CampoData(
      {Key? key,
      required this.controlador,
      required this.rotulo,
      this.naoMostrar})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<CampoData> createState() => _CampoDataState();
}

class _CampoDataState extends State<CampoData> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controlador,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.calendar_month),
        labelText: widget.rotulo,
        hintText: 'dd/mm/aaaa',
        labelStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        enabled: widget.naoMostrar == true ? false : true,
      ),
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple([
        Validatorless.required("Campo requerido"),
      ]),
      onTap: () async {
        var data = widget.controlador.text;
        int? dia = int.tryParse(data.substring(1, 2));
        int? mes = int.tryParse(data.substring(4, 5));
        int? ano = int.tryParse(data.substring(6, 10));
        DateTime? pickeddate = await showDatePicker(
          context: context,
          keyboardType: TextInputType.emailAddress,
          initialDate: widget.controlador.text.isNotEmpty
              ? DateTime(ano!, mes!, dia!)
              : DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          locale: const Locale("pt", "BR"),
        );

        if (pickeddate != null) {
          setState(() {
            widget.controlador.text =
                DateFormat('dd/MM/yyyy').format(pickeddate);
          });
        }
      },
    );
  }
}
