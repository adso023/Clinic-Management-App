
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clinic_app/employee/EmployeePage.dart';
import 'package:flutter_clinic_app/transitions/SizeRoute.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  TextEditingController _streetAddr;
  TextEditingController _apartmentSuiteUnit;
  TextEditingController _prov;
  TextEditingController _towncty;
  TextEditingController _postalCode;
  TextEditingController _phone;
  TextEditingController _nameClinic;
  String _insurance;
  String _paymentMethod;
  FirebaseAuth _auth;
  String _uid;

  TextStyle _formFieldStyle = TextStyle(fontSize: 22.0, letterSpacing: 1.2);
  EdgeInsets _containerEdge = const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0);

  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser();

    _insurance = "Insurance 1";
    _paymentMethod = "Payment Method 1";

    _user.then((onValue) => _uid = onValue.uid);
  }

  Widget _getBottomAppBar(BuildContext context) => BottomAppBar(
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
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _getBottomAppBar(context),
      body: SafeArea(
        child: Form(
          key: _formKey,
          onWillPop: () async => false,
          autovalidate: true,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: IconButton(
                  iconSize: 32.0,
                  icon: Icon(Icons.help),
                  onPressed: () => Alert(
                    context: context,
                    title: 'Highlighted icons are mandatory fields',
                    type: AlertType.info,
                    buttons: [
                      DialogButton(
                        child: Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ).show(),
                ),
              ),

              Container(
                alignment: Alignment.center,
                child: Text('Clinic Profile', style: TextStyle(fontSize: 22.0),),
              ),

              Container(
                child: TextFormField(
                  controller: _streetAddr,
                  decoration: InputDecoration(
                    hintText: 'Street Address',
                    hintStyle: TextStyle(letterSpacing: 1.2),
                    prefixIcon: Icon(Icons.location_on , color: Colors.red,)
                  ),
                  style: _formFieldStyle,
                ),
                margin: _containerEdge,
              ),

              Container(
                child: TextFormField(
                  controller: _apartmentSuiteUnit,
                  decoration: InputDecoration(
                    hintText: 'Apartment, Suite, Unit, etc (Optional)',
                    hintStyle: TextStyle(letterSpacing: 1.2),
                    prefixIcon: Icon(MdiIcons.pound)
                  ),
                  style: _formFieldStyle,
                ),
                margin: _containerEdge,
              ),

              Container(
                child: TextFormField(
                  controller: _prov,
                  decoration: InputDecoration(
                    hintText: 'Province',
                    hintStyle: TextStyle(letterSpacing: 1.2),
                    prefixIcon: Icon(Icons.location_on, color: Colors.red,)
                  ),
                  style: _formFieldStyle,
                ),
                margin: _containerEdge,
              ),

              Container(
                child: TextFormField(
                  controller: _towncty,
                  decoration: InputDecoration(
                    hintText: 'Town/City',
                    hintStyle: TextStyle(letterSpacing: 1.2),
                    prefixIcon: Icon(Icons.location_on, color: Colors.red,)
                  ),
                  style: _formFieldStyle,
                ),
                margin: _containerEdge,
              ),

              Container(
                child: TextFormField(
                  controller: _postalCode,
                  decoration: InputDecoration(
                    hintText: 'Postal Code',
                    hintStyle: TextStyle(letterSpacing: 1.2),
                    prefixIcon: Icon(MdiIcons.zipBox, color: Colors.red)
                  ),
                  style: _formFieldStyle,
                ),
                margin: _containerEdge,
              ),

              Container(
                child: TextFormField(
                  controller: _phone,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(letterSpacing: 1.2),
                    prefixIcon: Icon(MdiIcons.phone, color: Colors.red,)
                  ),
                  style: _formFieldStyle,
                ),
                margin: _containerEdge,
              ),

              Container(
                child: TextFormField(
                  controller: _nameClinic,
                  decoration: InputDecoration(
                    hintText: 'Clinic Name',
                    hintStyle: TextStyle(letterSpacing: 1.2),
                    prefixIcon: Icon(MdiIcons.hospital, color: Colors.red,)
                  ),
                  style: _formFieldStyle,
                ),
                margin: _containerEdge,
              ),

              Container(
                child: DropdownButtonFormField(
                  elevation: 0,
                  value: _insurance,
                  items: List.generate(5, (generator) => 
                    DropdownMenuItem(value: (generator + 1).toString(), child: Text('Insurance ${(generator+1).toString()}', textAlign: TextAlign.center, style: _formFieldStyle,),)),
                  onChanged: (str) => setState(() { _insurance = str; }),
                ),
                margin: _containerEdge.subtract(EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}