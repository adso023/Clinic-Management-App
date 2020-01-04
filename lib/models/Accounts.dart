import 'package:flutter_clinic_app/models/AccountType.dart';

class Accounts {
  String _accountFName;
  String _accountLName;
  String _accountUsername;
  String _accountPassword;
  AccountType _accountType;
  String _documentID;

  Accounts({String fname, String lname, String username, String password, String type, String id}) : 
    _accountFName = fname, _accountLName = lname, _accountUsername = username, _accountPassword = password, _accountType = type == "employee" ? AccountType.employee : AccountType.patient, _documentID = id;

  factory Accounts.fromJson({Map<String, dynamic> json, String type, String id}) => 
    Accounts(fname: json['First Name'], lname: json['Last Name'], username: json['Username'], password: json['Password'], type: type, id: id);

  String get accountFName => _accountFName;
  String get accountLName => _accountLName;
  String get accountUsername => _accountUsername;
  String get accountPassword => _accountPassword;
  AccountType get accountType => _accountType;
  String get documentID => _documentID;

  set accountFName(String value) { _accountFName = value; }
  set accountLName(String value) { _accountLName = value; }
  set accountUsername(String value) { _accountUsername = value; }
  set accountPassword(String value) { _accountPassword = value; }
  set accountType(AccountType value) { _accountType = value; }
  set documentID(String value) { _documentID = value; }

  @override
  String toString() {
    return "Service (Name=$accountFName $accountLName, Username=$accountUsername, Password=$accountPassword, Type=$accountType, ID=$documentID)";
  }
}