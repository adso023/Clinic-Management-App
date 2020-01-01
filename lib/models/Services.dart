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

  Services({
    this.role,
    this.service,
    this.rate,
  }) {
    _image = _rolesImages.containsKey(role) ? _rolesImages[role] : Image.asset('assets/images/BlankImage.png', fit: BoxFit.contain,);
  }

  Image get image => _image;
  String get serviceName => this.service;
  double get serviceRate => this.rate;
}