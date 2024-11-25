import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:validacion_forms/src/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier{

  final String _baseUrl = 'flutter-varios-527ca-default-rtdb.europe-west1.firebasedatabase.app/';
  final List<Product> products = [];
  bool isLoading = true;

  ProductsService(){
    this.loadProducts();
  }

  Future loadProducts() async {
    final url = Uri.http(_baseUrl, 'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = jsonDecode(resp.body);
    print(productsMap);
  }


}
