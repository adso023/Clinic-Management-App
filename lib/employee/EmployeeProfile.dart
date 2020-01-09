
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<String, dynamic> _paymentMethods;
  Map<String, dynamic> _insuranceTypes;
  FirebaseAuth _auth;
  Firestore _firestore;
  String _uid;

  TextStyle _formFieldStyle = TextStyle(fontSize: 22.0, letterSpacing: 1.2);
  EdgeInsets _containerEdge = const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0);

  void _initTextFieldsController(){
    _streetAddr = TextEditingController(text: "");
    _apartmentSuiteUnit = TextEditingController(text: "");
    _prov = TextEditingController(text: "");
    _towncty = TextEditingController(text: "");
    _postalCode = TextEditingController(text: "");
    _phone = TextEditingController(text: "");
    _nameClinic = TextEditingController(text: "");
  }

  void _submitClinicProfile(){

    print('Document ID $_uid');

    Map<String, dynamic> profile = {
      'Street Addr' : _streetAddr.text,
      'AptSuiteUnit' : _apartmentSuiteUnit.text,
      'Province' : _prov.text,
      'TownCity' : _towncty.text,
      'PostalCode' : _postalCode.text,
      'Phone' : _phone.text,
      'ClinicName' : _nameClinic.text,
      'InsuranceTypes' : _insuranceTypes,
      'PaymentTypes' : _paymentMethods
    };

    _firestore.collection('Employee').document(_uid).get()
    .then((onValue) async{
      String profileID = _firestore.collection('Profile').document().documentID;
      Map<String, dynamic> data = onValue.data;
      data['ProfileID'] = profileID;

      await _firestore.collection('Profile').document(profileID).setData(profile);
      await _firestore.collection('Employee').document(_uid).setData(data);

      Navigator.pop(context);
      Navigator.push(context, SizeRoute(page: EmployeeWelcome()));

    }).catchError((onError){



    });

  }

  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser();
    _firestore = Firestore.instance;

    _initTextFieldsController();

    _paymentMethods = {
      'Cash' : false,
      'Debit' : false,
      'Credit' : false,
    };

    _insuranceTypes = {
      'OHIP' : false,
      'Private' : false,
    };

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
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 0.0),
                    child: MaterialButton(
                      child: Text('Submit', style: _formFieldStyle,),
                      onPressed: () => _submitClinicProfile(),
                      color: Colors.teal[500]
                    ),
                  ),

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
                ],
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[

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
                      child: Divider(),
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Text('Insurance Types', style: _formFieldStyle,),
                          
                          Row(
                            children: <Widget>[
                              Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.padded,
                                value: _paymentMethods['Cash'],
                                onChanged: (newValue) => setState((){_paymentMethods['Cash'] = newValue;}),
                              ),
                              Text('Cash', style: _formFieldStyle,),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.padded,
                                value: _paymentMethods['Debit'],
                                onChanged: (newValue) => setState((){_paymentMethods['Debit'] = newValue;}),
                              ),
                              Text('Debit', style: _formFieldStyle,),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.padded,
                                value: _paymentMethods['Credit'],
                                onChanged: (newValue) => setState((){_paymentMethods['Credit'] = newValue;}),
                              ),
                              Text('Credit', style: _formFieldStyle,),
                            ],
                          )
                        ],
                      ),
                      margin: _containerEdge
                    ),

                    Container(
                      child: Divider(),
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Text('Insurance Types', style: _formFieldStyle),

                          Row(
                            children: <Widget>[
                              Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.padded,
                                value: _insuranceTypes['OHIP'],
                                onChanged: (newValue) => setState(() {_insuranceTypes['OHIP'] = newValue;}),
                              ),
                              Text('OHIP', style: _formFieldStyle,)
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.padded,
                                value: _insuranceTypes['Private'],
                                onChanged: (newValue) => setState(() {_insuranceTypes['Private'] = newValue;}),
                              ),
                              Text('Private', style: _formFieldStyle,)
                            ],
                          ),
                        ],
                      ),
                      margin: _containerEdge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}