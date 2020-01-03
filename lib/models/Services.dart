import 'package:flutter/material.dart';

class Services {
  String role;
  String service;
  double rate;
  Image _image;

  final _rolesImages = {
    'Doctor' : Image.asset('assets/images/DoctorIcon.png', fit: BoxFit.contain,),
    'Nurse' : Image.asset('assets/images/NurseIcon.png', fit: BoxFit.contain,),
    'Pharmacy' : Image.asset('assets/images/PharmacyIcon.png', fit: BoxFit.contain,),
  };

  factory Services.fromMap({Map<String, dynamic> json}) => Services(role: json['role'], service: json['service'], rate: double.parse(json['rate'].toString()));

  Map<String, dynamic> toMap() => {'role' : this.roleName, 'service': this.serviceName, 'rate' : this.serviceRate};

  Services({
    this.role,
    this.service,
    this.rate,
  }) {
    _image = _rolesImages.containsKey(role) ? _rolesImages[role] : Image.asset('assets/images/BlankImage.png', fit: BoxFit.contain,);
  }

  Image get image => _image;
  String get roleName => this.role;
  set roleName(String value) { this.role = value; }
  String get serviceName => this.service;
  set serviceName(String value) { this.service = value; }
  double get serviceRate => this.rate;
  set serviceRate(double value) { this.rate = value; }

  @override
  String toString() {
    return "Services (role=$role, service=$service, rate=$rate)";
  }
}