import 'package:flutter/material.dart';
import 'package:validacion_forms/src/models/product.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Product product;

  ProductFormProvider(this.product);

  void updateAvailability(bool value) {
    product.available = value;  // Cambia el valor de 'available'
    notifyListeners();  // Notifica a los listeners para actualizar la UI
  }

  bool isValidForm() {
    return product.name.isNotEmpty && product.price > 0;
  }
}
