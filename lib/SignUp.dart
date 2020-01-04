import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clinic_app/Login.dart';
import 'package:flutter_clinic_app/transitions/ScaleRoute.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CreateAccount extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _CreateAccountState();
  }

}

class _CreateAccountState extends State<CreateAccount>{

  FirebaseAuth _auth;
  Firestore _firestore;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  TextEditingController _firstName;
  TextEditingController _lastName;
  TextEditingController _username;
  TextEditingController _password;

  String _accountType;

  bool _isLoading;
  bool _viewHide;

  @override
  void initState() {
    super.initState();

    _firstName = TextEditingController(text: "");
    _lastName = TextEditingController(text: "");
    _username = TextEditingController(text: "");
    _password = TextEditingController(text: "");

    _isLoading = false; _viewHide = false;
    _accountType = "Patient";

    _auth = FirebaseAuth.instance;
    _firestore = Firestore.instance;

  }

  @override
  void dispose() {
    super.dispose();

    _accountType = null;
    _firstName.dispose();
    _lastName.dispose();
    _username.dispose();
    _password.dispose();

    _isLoading = null; _viewHide = null;
    _auth.signOut();
    _auth = null;
    _firestore = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[

                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(minWidth: 30.0, maxWidth: 500.0, minHeight: 40.0, maxHeight: 100.0),
                  child: Image.asset('assets/images/ClinicLogo.png', fit: BoxFit.contain,),
                  margin: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 30.0),
                ),

                Center(
                  child: Text('Sign up Form for $_accountType', style: TextStyle(fontSize: 25.0, letterSpacing: 1.2),),
                ),

                Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: _firstName,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      hintStyle: TextStyle(letterSpacing: 1.2),
                      prefixIcon: Icon(Icons.perm_identity)
                    ),
                    style: TextStyle(fontSize: 22.0, letterSpacing: 1.2),
                  ),
                  margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
                ),

                Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: _lastName,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      hintStyle: TextStyle(letterSpacing: 1.2),
                      prefixIcon: Icon(Icons.perm_identity),
                    ),
                    style: TextStyle(fontSize: 22.0, letterSpacing: 1.2),
                  ),
                  margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                ),

                Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      key: Key('txtUsername'),
                      controller: _username,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(letterSpacing: 1.2),
                        prefixIcon: Icon(Icons.account_circle, size: 32.0,)
                      ),
                      style: TextStyle(fontSize: 22.0, letterSpacing: 1.2),
                    ),
                    margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
                  ),

                  Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(letterSpacing: 1.2),
                        prefixIcon: Icon(Icons.vpn_key),
                        suffixIcon: IconButton(
                          icon: (_viewHide) ? Icon(Icons.lock_open) : Icon(Icons.lock),
                          onPressed: () => setState(() {_viewHide = !_viewHide;}),
                        ),
                      ),
                      obscureText: ! _viewHide,
                      style: TextStyle(fontSize: 22.0, letterSpacing: 1.2),
                    ),
                    margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                  ),

                  Container(
                    alignment: Alignment.centerLeft,
                    child: DropdownButtonFormField(
                      items: <DropdownMenuItem>[
                        DropdownMenuItem(
                          value: 'Employee',
                          child: Text('Employee', style: TextStyle(fontSize: 22.0, letterSpacing: 1.2),),
                        ),
                        DropdownMenuItem(
                          value: 'Patient',
                          child: Text('Patient', style: TextStyle(fontSize: 22.0, letterSpacing: 1.2),),
                        )
                      ],
                      value: _accountType,
                      onChanged: (str) => setState(() {_accountType = str;}),
                    ),
                    margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                  ),

                  Container(
                    alignment: Alignment.center,
                    child: (! _isLoading) ? MaterialButton(
                      color: Colors.teal,
                      child: Text('Create Account', style: TextStyle(fontSize: 22.0, letterSpacing: 1.2),),
                      onPressed: () {

                        setState(() {_isLoading = true;});

                        String authFirstname = _firstName.text;
                        String authLastname = _lastName.text;
                        String authUsername = _username.text + "@clinic.domain.com";
                        String authPassword = _password.text;

                        _auth.createUserWithEmailAndPassword(email: authUsername, password: authPassword)
                        .then((onValue) {

                          UserUpdateInfo update = UserUpdateInfo();
                          update.displayName = authFirstname + " " + authLastname;

                          onValue.user.updateProfile(update).then((onValue) => print('User Updated'));
                          
                          _firestore.collection(_accountType).document(onValue.user.uid).setData({
                            'First Name' : authFirstname,
                            'Last Name' : authLastname,
                            'Username' : authUsername,
                            'Password' : authPassword
                          }).then((onValue){

                            setState(() {_isLoading = false;});

                            _auth.signOut();

                            Navigator.push(context, ScaleRoute(page: Login()));

                          }).catchError((onError) {

                            setState(() {_isLoading = false;});
                            print(onError.toString());

                            Alert(
                              context: context,
                              type: AlertType.error,
                              style: AlertStyle(
                                animationDuration: Duration(milliseconds: 500),
                                animationType: AnimationType.fromTop
                              ),
                              title: 'Write to Database Failed',
                              desc: onError.toString()
                            ).show();

                          });
                        })
                        .catchError((onError) {

                          setState(() {_isLoading = false;});
                          print(onError.toString());

                          Alert(
                            context: context,
                            type: AlertType.error,
                            style: AlertStyle(
                              animationDuration: Duration(milliseconds: 500),
                              animationType: AnimationType.fromTop
                            ),
                            title: 'Create User Failed',
                            desc: onError.toString()
                          ).show();

                        });

                      },
                    ) : CircularProgressIndicator(),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 5.0),
                    child: Divider(),
                  ),

                  Container(
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: Text('Already Have an Account - Log in Here!', style: TextStyle(fontSize: 18.0, letterSpacing: 0.6),),
                      onPressed: () {
                         Navigator.pop(context);
                         Navigator.push(context, ScaleRoute(page: Login()));
                      },
                    ),
                  )

              ],
            ),
          ),
        ),
      ),
    );
  }
}