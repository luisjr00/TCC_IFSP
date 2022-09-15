/*import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendario extends StatefulWidget {
  const Calendario({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tarefas"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Container(
          //color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 40,
              right: 40,
            ),
            child: SfCalendar(
              view: CalendarView.week,
              firstDayOfWeek: 1, //Inicia semana pela segunda
              dataSource: MeetingDataSource(getAppointments()),
              //initialDisplayDate: DateTime(2022, 09, 01, 22, 20),
              //initialSelectedDate: DateTime(2022, 09, 01, 22, 20),
            ),
          ),
        ));
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Conference',
      color: Colors.indigo,
      recurrenceRule: 'FREQ=DAILY; COUNT=10'));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
*/