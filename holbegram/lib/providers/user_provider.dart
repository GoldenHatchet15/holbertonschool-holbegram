import 'package:flutter/material.dart';
import '../models/user.dart';
import '../methods/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Userd? _user;
  final AuthMethods _authMethod = AuthMethods();

  Userd get getUser => _user!;

  Future<void> refreshUser() async {
    Userd user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
