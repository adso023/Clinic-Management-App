import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clinic_app/admin/NewService.dart';
import 'package:flutter_clinic_app/models/Services.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ManageServices extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _ManageServices();
  }
}

class _ManageServices extends State<ManageServices>{

  String _roleType;
  TextEditingController _service;
  double _rate;

  Firestore _firestore;

  @override
  void initState() {
    super.initState();

    _firestore = Firestore.instance;

    _roleType = "Doctor";
    _service = TextEditingController(text: "");
    _rate = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Service').snapshots(),
          builder: (context, snapshot){

            if(! snapshot.hasData){
              return _buildEmpty(context);
            }

            List<DocumentSnapshot> documents = snapshot.data.documents.map((documents){
              if(documents.documentID != "AA") return documents;
            }).toList();

            documents.map((elements) => print(elements.data));

            return Column(
              children: <Widget>[
                Container(
                  child: Text('Defined Services', style: TextStyle(letterSpacing: 1.2),),
                  alignment: Alignment.center,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: ListView(
                    children: documents.map((docs){
                      final services = Services.fromMap(json: docs.data);
                      print(services.toString());

                      return Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: ListTile(
                          leading: services.image,
                          title: Text(services.serviceName),
                          trailing: Text('\$${services.serviceRate}'),
                        ),
                      );

                    }).toList()
                  ),
                )
              ],
            );

          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

          return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return NewService();
            }
          );

        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Center(
          child: Image.asset(
            'assets/images/EmptyList.png', 
            fit: BoxFit.contain,
          ),
        ),

        Center(
          child: Text(
            'No Services in Database',
          ),
        ),

        Center(
          child: Text(
            'Hit the + button at the bottom to add services'
          ),
        ),
      ],
    );
  }
}