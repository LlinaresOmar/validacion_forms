import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String name = "";
  String email = '';
  String password = '';
  String phone = '';
  String sex = '';
  
  String _fechaNac = '';
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners(); 
  }

  String get fechaNac => _fechaNac;

  set fechaNac(String value) {
    _fechaNac = value;
    notifyListeners(); 
  }

  bool isValidForm() {
    print('$name - $email - $password - $phone - $sex - "$_fechaNac');
    print(formKey.currentState?.validate()); 
    return formKey.currentState?.validate() ?? false;
  }
}
