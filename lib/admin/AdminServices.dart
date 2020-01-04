
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clinic_app/admin/ServiceOptions.dart';
import 'package:flutter_clinic_app/models/Services.dart';

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

            if(! snapshot.hasData) return Center(child: CircularProgressIndicator(),);

            List<DocumentSnapshot> documents = <DocumentSnapshot>[];

            for(DocumentSnapshot snapshot in snapshot.data.documents){
              if(snapshot.documentID != "AA") documents.add(snapshot);
            }

            if( documents.isEmpty){
              return _buildEmpty(context);
            }

            return Column(
              children: <Widget>[
                Container(
                  child: Text('Defined Services', style: TextStyle(letterSpacing: 1.2, fontSize: 22.0),),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20.0),
                ),
                Expanded(
                    child: ListView(
                      children: documents.map((docs){
                        final services = Services.fromMap(json: docs.data);
                        print(services.toString());

                        return Container(
                          child: ListTile(
                            leading: services.icon,
                            title: Text(services.serviceName),
                            trailing: Text('\$${services.serviceRate}'),
                            onLongPress: () async{
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => EditServices(services: services, documentId: docs.documentID,)
                              );
                            },
                          ),
                        );

                      }).toList()
                    ),
                  ),
              ],
            );

          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Service',
        child: Icon(Icons.add),
        onPressed: () async {

          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => NewService()
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