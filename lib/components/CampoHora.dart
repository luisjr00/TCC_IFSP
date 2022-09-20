import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class CampoHora extends StatefulWidget {
  const CampoHora({Key? key, required this.controlador, required this.rotulo})
      : super(key: key);

  final TextEditingController controlador;
  final String rotulo;

  @override
  State<CampoHora> createState() => _CampoHoraState();
}

class _CampoHoraState extends State<CampoHora> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controlador,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.access_alarm_outlined),
        labelText: widget.rotulo,
        hintText: 'Ex. 00:00',
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
        TimeOfDay? pickedtime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedtime != null) {
          setState(() {
            widget.controlador.text = pickedtime.format(context);
          });
        }
      },
    );
  }
}
