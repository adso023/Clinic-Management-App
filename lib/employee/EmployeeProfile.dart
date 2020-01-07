
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clinic_app/employee/EmployeePage.dart';
import 'package:flutter_clinic_app/transitions/SizeRoute.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EmployeeProfile extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _EmployeeProfile();
  }

}

class _EmployeeProfile extends State<EmployeeProfile>{

  Future<FirebaseUser> _user;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth;
  String _uid;

  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser();

    _user.then((onValue) => _uid = onValue.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: MaterialButton(
          child: Text('Go Back'),
          onPressed: () async {
            await Alert(
              context: context,
              type: AlertType.warning,
              title: 'Confirmation',
              desc: 'Do you want to go back',
              buttons: [
                DialogButton(
                  child: Text('Go Back', style: TextStyle(color: Colors.black),),
                  onPressed: (){

                    Navigator.pop(context);
                    Navigator.push(context, SizeRoute(page: EmployeeWelcome()));
                  },
                ),
                DialogButton(
                  child: Text('Stay', style: TextStyle(color: Colors.black),),
                  onPressed: () => Navigator.pop(context),
                )
              ]
            ).show();
          },
          color: Colors.red[300],
          height: 50.0,
        ),
      ),
      body: SafeArea(
        child: Form(
          onWillPop: () async => false,
          autovalidate: true,
          child: ListView(
            children: <Widget>[
              Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minWidth: 30.0, maxWidth: 500.0, minHeight: 40.0, maxHeight: 75.0),
                    child: Image.asset("assets/images/ClinicLogo.png", fit: BoxFit.contain,),
                    margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
              ),

              Container(
                child: Text('Clinic Profile', style: TextStyle(fontSize: 22.0),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}