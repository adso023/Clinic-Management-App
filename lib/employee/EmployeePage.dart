import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clinic_app/Login.dart';
import 'package:flutter_clinic_app/transitions/SlideRoute.dart';

class EmployeeWelcome extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _EmployeeWelcome();
  }
}

class _EmployeeWelcome extends State<EmployeeWelcome>{

  FirebaseAuth _auth;
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();

    print(_auth.currentUser().then((onValue) => print(onValue.email)));

    _user = _auth.currentUser().then((onValue) => onValue) as FirebaseUser;
  }

  @override
  void dispose() {
    super.dispose();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(minWidth: 30.0, maxWidth: 500.0, minHeight: 40.0, maxHeight: 150.0),
                      child: Image.asset("assets/images/ClinicLogo.png", fit: BoxFit.contain,),
                      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 30.0),
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: Text('Welcome ${_user.displayName}\nSigned in as Employee'),
                      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        child: Text('Manage Accounts'),
                        color: Colors.teal[500],
                        onPressed: () => print('Manage Accounts'),
                      ),
                      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        child: Text('Manage Services'),
                        onPressed: () => print('Manage Services'),
                        color: Colors.teal[500],
                      ),
                      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  child: Text('Log out'),
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pop(context);
                    Navigator.push(context, SlideLeftRoute(page: Login()));
                  },
                  color: Colors.red[300],
                  height: 50.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}