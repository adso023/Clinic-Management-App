
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmployeeProfile extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _EmployeeProfile();
  }

}

class _EmployeeProfile extends State<EmployeeProfile>{

  Future<FirebaseUser> _user;
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
    return null;
  }
}