import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clinic_app/models/Services.dart';

class NewService extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _NewService();
  }
}

class _NewService extends State<NewService>{

  String _roleType;
  TextEditingController _service;
  TextEditingController _rate;

  Firestore _firestore;
  FirebaseAuth _auth;
  Future<FirebaseUser> _user;

  @override
  void initState() {
    super.initState();

    _roleType = "Doctor";
    _service = TextEditingController(text: "");
    _rate = TextEditingController(text: "");

    _auth = FirebaseAuth.instance;
    _firestore = Firestore.instance;
    _user = _auth.currentUser();

    _user = _auth.currentUser();
  }

  //Alert Dialog code taken from rflutter_alert package
  //I do not own this code, credit to rflutter_alert package creator
  //Almost all of the code is taken from rflutter_alert
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: double.infinity, height: double.infinity),
        child: Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.blueGrey)
              ),
              titlePadding: EdgeInsets.all(0.0),
              title: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 15,),
                            Text(
                              'New Service',
                              style: TextStyle(letterSpacing: 1.2, fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10,),
                            Column(
                              children: <Widget>[
                                
                                Row(
                                  children: <Widget>[
                                    Text('Role: '),
                                    SizedBox(width: 2.0,),
                                    Expanded(
                                      child: Center(
                                        child: DropdownButton(
                                          value: _roleType,
                                          items: <String>['Doctor', 'Nurse', 'Pharmacy'].map<DropdownMenuItem<String>>((f) => DropdownMenuItem(
                                            value: f, child: Center(child: Text(f, style: TextStyle(fontSize: 20.0),)),
                                          )).toList(),
                                          onChanged: (str) => setState(() {_roleType = str;}),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                TextField(
                                  controller: _service,
                                  decoration: InputDecoration(
                                    hintText: 'Service Name',
                                    hintStyle: TextStyle(letterSpacing: 1.2),
                                  ),
                                ),

                                TextField(
                                  controller: _rate,
                                  decoration: InputDecoration(
                                    hintText: 'Rate',
                                    hintStyle: TextStyle(letterSpacing: 1.2)
                                  ),
                                  keyboardType: TextInputType.number,
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.teal,
                            child: Text('Add', style: TextStyle(letterSpacing: 1.0),),
                            onPressed: () => this.addNewService(_roleType, _service.text.trim(), _rate.text.trim())
                          ),

                          MaterialButton(
                            color: Colors.black26,
                            child: Text('Cancel', style: TextStyle(letterSpacing: 1.0),),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      )
                    ],
                  )
                ),
              ),
            ),
          ),
        )
      )
    );
  }

  void addNewService(String roleType, String serviceName, String rateDef){
    final data = Services(role: roleType, service: serviceName, rate: double.parse(rateDef));

    final jsonData = data.toMap();

    print(jsonData);

    _firestore.collection('Service').document().setData(jsonData)
    .then((onValue){
      Navigator.pop(context);
    }).catchError((onError){

    });
  }
}

class EditServices extends StatefulWidget{
  final Services services;
  final String documentId;

  EditServices({this.services, this.documentId});

  @override
  State<StatefulWidget> createState() {
    return _EditServices();
  }
}

class _EditServices extends State<EditServices>{

  String _roleType;
  TextEditingController _service;
  TextEditingController _rate;

  Firestore _firestore;
  FirebaseAuth _auth;
  Future<FirebaseUser> _user;

  @override
  void initState() {
    super.initState();

    _roleType = widget.services.roleName;
    _service = TextEditingController(text: widget.services.serviceName);
    _rate = TextEditingController(text: widget.services.serviceRate.toString());

    _auth = FirebaseAuth.instance;
    _firestore = Firestore.instance;
    _user = _auth.currentUser();

  }

  @override
  Widget build(BuildContext context) {
    print("Role Type $_roleType");
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: double.infinity, height: double.infinity),
        child: Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.blueGrey)
              ),
              titlePadding: EdgeInsets.all(0.0),
              title: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        child: IconButton(
                          padding: const EdgeInsets.all(0.0),
                          icon: Icon(Icons.close, size: 18.0,),
                          onPressed: () => Navigator.pop(context),
                        ),
                        alignment: Alignment.centerRight
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'New Service',
                              style: TextStyle(letterSpacing: 1.2, fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10,),
                            Column(
                              children: <Widget>[
                                
                                Row(
                                  children: <Widget>[
                                    Text('Role: '),
                                    SizedBox(width: 2.0,),
                                    Expanded(
                                      child: Center(
                                        child: DropdownButton(
                                          value: _roleType,
                                          items: <String>['Doctor', 'Nurse', 'Pharmacy'].map<DropdownMenuItem<String>>((f) => DropdownMenuItem(
                                            value: f, child: Center(child: Text(f, style: TextStyle(fontSize: 20.0),)),
                                          )).toList(),
                                          onChanged: (str) => setState(() {_roleType = str;}),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                TextField(
                                  controller: _service,
                                  decoration: InputDecoration(
                                    hintText: 'Service Name',
                                    hintStyle: TextStyle(letterSpacing: 1.2),
                                  ),
                                ),

                                TextField(
                                  controller: _rate,
                                  decoration: InputDecoration(
                                    hintText: 'Rate',
                                    hintStyle: TextStyle(letterSpacing: 1.2)
                                  ),
                                  keyboardType: TextInputType.number,
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.teal,
                            child: Text('Edit', style: TextStyle(letterSpacing: 1.0),),
                            onPressed: () => this.editService(context, _roleType, _service.text.trim(), _rate.text.trim())
                          ),

                          MaterialButton(
                            color: Colors.black26,
                            child: Text('Delete', style: TextStyle(letterSpacing: 1.0),),
                            onPressed: () => _firestore.collection('Service').document(widget.documentId).delete().then((onValue) => Navigator.pop(context)),
                          )
                        ],
                      )
                    ],
                  )
                ),
              ),
            ),
          ),
        )
      )
    );
  }

  void editService(BuildContext context, String role, String service, String rate){
    Services editService = widget.services;

    print(editService.toMap());

    editService.roleName = role;
    editService.serviceName = service;
    editService.serviceRate = double.parse(rate);

    final jsonData = editService.toMap();

    print(jsonData);

    _firestore.collection('Service').document(widget.documentId).updateData(jsonData).then((onValue) => Navigator.pop(context));
  }
}