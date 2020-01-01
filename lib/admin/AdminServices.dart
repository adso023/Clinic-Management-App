import 'package:flutter/material.dart';
import 'package:flutter_clinic_app/admin/NewService.dart';
import 'package:flutter_clinic_app/models/Services.dart';

class ManageServices extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _ManageServices();
  }
}

final exampleData = [
  Services(role: 'Doctor', service: 'Urine Test', rate: 14.34),
  Services(role: 'Doctor', service: 'Kidney Transplant Surgery', rate: 1200.00),
  Services(role: 'Nurse', service: 'Massage', rate: 14.53),
  Services(role: 'Nurse', service: 'Diabetes Check Up', rate: 20.00),
  Services(role: 'Doctor', service: 'Prostate Exams', rate: 13.00),
  Services(role: 'Pharmacy', service: 'Medicine Refill', rate: 12.00),
  Services(role: 'Doctor', service: 'Vaccine', rate: 5.00),
  Services(role: 'Nurse', service: 'DNA Test', rate: 85.00),
  Services(role: 'Doctor', service: 'Pediatrician', rate: 56.23),
  Services(role: 'Nurse', service: 'Eye Exams', rate: 25.00),
  Services(role: 'Doctor', service: 'Ear Exam', rate: 23.22),
  Services(role: 'Nurse', service: 'Fertility Test', rate: 12.34),
  Services(role: 'Pharmacy', service: 'Over the Counter Drugs', rate: 12.00),
];

class _ManageServices extends State<ManageServices>{

  String _roleType;
  TextEditingController _service;
  double _rate;

  @override
  void initState() {
    super.initState();

    _roleType = "Doctor";
    _service = TextEditingController(text: "");
    _rate = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Center(child: Text('Service', style: TextStyle(letterSpacing: 1.2, fontSize: 22.0,)))
          ] + exampleData.map<Widget>((f){
            Services service = f;

            return Container(
              margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: ListTile(
                leading: service.image,
                title: Text(service.serviceName),
                trailing: Text('\$${service.serviceRate}'),
              ),
            );

          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

          return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return NewService();
            }
          );

        },
      ),
    );
  }
}