
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clinic_app/models/AccountType.dart';
import 'package:flutter_clinic_app/models/Accounts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ManageAccounts extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ManageAccounts();
  }
}

class _ManageAccounts extends State<ManageAccounts>{

  FirebaseAuth _auth;
  Firestore _firestore;
  Future<FirebaseUser> _user;

  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;
    _firestore = Firestore.instance;
    _user = _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(child: Text('Accounts in Database', style: TextStyle(letterSpacing: 1.2, fontSize: 20.0),),),
            SizedBox(height: 10.0,),
            Center(child: Text('Employees', style: TextStyle(letterSpacing: 1.2,),),),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Employee').snapshots(),
                builder: (context, snapshots){
                  if(! snapshots.hasData) return Center(child: CircularProgressIndicator(),);

                  List<DocumentSnapshot> emp = _sortDocuments(snapshots.data.documents);

                  if(emp.isEmpty) return _buildEmpty(context);

                  return ListView(
                    shrinkWrap: true,
                    children: emp.map<Widget>((docs){
                      final account = Accounts.fromJson(json: docs.data);
                      account.accountType = AccountType.employee;

                      return ListTile(
                        leading: Icon(MdiIcons.account),
                        title: Text('${account.accountFName} ${account.accountLName}'),
                        trailing: IconButton(
                          icon: Icon(MdiIcons.delete),
                          onPressed: () async => await _firestore.collection('Employee').document(account.documentID).delete(),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 10.0,),
            Center(child: Text('Patients', style: TextStyle(letterSpacing: 1.2),),),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Patient').snapshots(),
                builder: (context, snapshots){
                  if(! snapshots.hasData) return Center(child: CircularProgressIndicator(),);

                  List<DocumentSnapshot> pat = _sortDocuments(snapshots.data.documents);

                  if(pat.isEmpty) return _buildEmpty(context);

                  return ListView(
                    shrinkWrap: true,
                    children: pat.map<Widget>((docs){
                      final account = Accounts.fromJson(json: docs.data);
                      account.accountType = AccountType.patient;

                      return ListTile(
                        leading: Icon(MdiIcons.account),
                        title: Text('${account.accountFName} ${account.accountLName}'),
                        trailing: IconButton(
                          icon: Icon(MdiIcons.delete),
                          onPressed: () async => await _firestore.collection('Patient').document(account.documentID).delete(),
                        ),
                      );
                    }).toList()
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }

  Widget _buildEmpty(BuildContext context){
    return ListView(
      children: <Widget>[

        Center(
          child: Image.asset(
            'assets/images/EmptyList.png', 
            fit: BoxFit.cover,
            height: 100.0,
          ),
        ),

        Center(
          child: Text(
            'No Accounts in Database',
          ),
        ),
      ],
    );
  }

  List<DocumentSnapshot> _sortDocuments(List<DocumentSnapshot> snapshots){
    List<DocumentSnapshot> toReturn = <DocumentSnapshot>[];

    for(DocumentSnapshot snapshot in snapshots){
      if(snapshot.documentID != "AA") toReturn.add(snapshot);
    }

    return toReturn;
  }
}