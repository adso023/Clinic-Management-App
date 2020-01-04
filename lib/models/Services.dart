import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Services {
  String _role;
  String _service;
  double _rate;
  Icon _icon;

  factory Services.fromMap({Map<String, dynamic> json}) => Services(role: json['role'], service: json['service'], rate: double.parse(json['rate'].toString()));

  Services({String role, String service, double rate}) : _role = role, _service = service, _rate = rate, _icon = _rolesImages.containsKey(role) ? _rolesImages[role] : Icon(MdiIcons.borderAll);

  Icon get icon => _icon;
  String get roleName => this._role;
  set roleName(String value) { this._role = value; }
  String get serviceName => this._service;
  set serviceName(String value) { this._service = value; }
  double get serviceRate => this._rate;
  set serviceRate(double value) { this._rate = value; }

  static Map<String, Icon> _rolesImages = {
    'Doctor' : Icon(MdiIcons.doctor, size: 40.0,),
    'Nurse' : Icon(MdiIcons.motherNurse, size: 40.0,),
    'Pharmacy' : Icon(MdiIcons.pharmacy, size: 40.0,),
  };

  Map<String, dynamic> toMap() => {'role' : this.roleName, 'service': this.serviceName, 'rate' : this.serviceRate};
  
  @override
  String toString() {
    return "Services (role=$roleName, service=$serviceName, rate=$serviceRate)";
  }
}