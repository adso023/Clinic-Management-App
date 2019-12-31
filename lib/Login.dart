
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clinic_app/SignUp.dart';
import 'package:flutter_clinic_app/admin/AdminPage.dart';
import 'package:flutter_clinic_app/transitions/ScaleRoute.dart';
import 'package:flutter_clinic_app/transitions/SlideRoute.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login>{

  TextEditingController _usernameController;
  TextEditingController _passwordController;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  bool _usernameError;
  bool _passwordError;
  bool _viewHide;
  bool _isLoading;

  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;

    _usernameController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");

    _usernameError = false;
    _passwordError = false;
    _viewHide = false;
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();

    _usernameController.dispose();
    _passwordController.dispose();

    _formKey = null; _scaffoldState = null;

    _usernameError = null; _passwordError = null;
    _viewHide = null; _isLoading = null;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: SafeArea(
        child: WillPopScope(
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(minWidth: 30.0, maxWidth: 500.0, minHeight: 40.0, maxHeight: 100.0),
                  child: Image.asset("assets/images/ClinicLogo.png", fit: BoxFit.contain,),
                  margin: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 30.0),
                ),

                Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    key: Key('txtUsername'),
                    controller: _usernameController,
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
                    controller: _passwordController,
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
                  margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 5.0),
                  child: (! _isLoading) ? MaterialButton(
                    color: Colors.teal,
                    child: Text('Login', style: TextStyle(letterSpacing: 1.2, fontSize: 20.0),),
                    onPressed: () {

                      setState(() {_isLoading = true;});

                      String authUsername = _usernameController.text + "@clinic.domain.com";
                      String authPassword = _passwordController.text;

                      if(authUsername == "Admin@clinic.domain.com" && authPassword == "5T5ptQ"){

                        _auth.signInAnonymously().then((onValue) {
                          
                          Navigator.pop(context);
                          Navigator.push(context, SlideRightRoute(page: AdminWelcome()));

                        }).catchError((onError){
                          print(onError.toString());
                        });

                      }else{

                        print(authUsername); print(authPassword);

                      _auth.signInWithEmailAndPassword(email: authUsername, password: authPassword)
                      .then((onValue) {
                        print('Sign in Successful');
                        setState(() {_isLoading = false;});

                      }).catchError((onError){
                        print('Sign in Failed');
                        setState(() {_isLoading = false;});

                        Alert(
                          context: context,
                          type: AlertType.error,
                          style: AlertStyle(
                            animationDuration: Duration(milliseconds: 500),
                            animationType: AnimationType.grow,
                          ),
                          title: 'Sign in Failed',
                          desc: 'Username or Password is incorrect'
                        ).show();

                      });

                      }

                    },
                  ) : CircularProgressIndicator() ,
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 5.0),
                  child: Divider(),
                ),

                Container(
                  alignment: Alignment.center,
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text('Create Account', style: TextStyle(letterSpacing: 1.2, fontSize: 18.0),),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, ScaleRoute(page: CreateAccount()));
                        },
                      ),

                      MaterialButton(
                        color: Colors.black26,
                        child: Icon(Icons.settings),
                        onPressed: () => print('Settings'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          onWillPop: () async => false,
        ),
      ),
    );
  }
}