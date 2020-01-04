import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clinic_app/Login.dart';
import 'package:flutter_clinic_app/admin/AdminAccounts.dart';
import 'package:flutter_clinic_app/admin/AdminServices.dart';
import 'package:flutter_clinic_app/transitions/SizeRoute.dart';
import 'package:flutter_clinic_app/transitions/SlideRoute.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdminWelcome extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _AdminWelcome();
  }

}

class _AdminWelcome extends State<AdminWelcome>{

  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;

    _auth.currentUser().then((onValue) => print(onValue.email));
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
                      child: Text('Welcome Admin\nSigned in as Administrator'),
                      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        child: Text('Manage Accounts'),
                        color: Colors.teal[500],
                        onPressed: () => Navigator.push(context, SizeRoute(page: ManageAccounts()))
                      ),
                      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        child: Text('Manage Services'),
                        onPressed: () => Navigator.push(context, SizeRoute(page: ManageServices())),
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
                  onPressed: () async {

                    await Alert(
                      context: context,
                      type: AlertType.warning,
                      title: 'Confirmation',
                      desc: 'Do you want to log out',
                      buttons: [
                        DialogButton(
                          child: Text('Log out', style: TextStyle(color: Colors.black),),
                          onPressed: (){
                            _auth.signOut();

                            Navigator.pop(context);
                            Navigator.push(context, SlideLeftRoute(page: Login()));
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
              )
            ],
          ),
        ),
      ),
    );
  }
}