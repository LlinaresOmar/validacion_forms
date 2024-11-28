import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:validacion_forms/src/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier{

  final String _baseUrl = 'flutter-varios-527ca-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;
  File? newPictureFile;

  ProductsService(){
    this.loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = jsonDecode(resp.body);

    productsMap.forEach((key, value){
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();

    return products;
  }

  Future<String?> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, '/products/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    print(decodedData);

    // Actualizar la lista de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id;
  }

  
  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);
    print(decodedData);
    product.id = decodedData['name'];

    this.products.add(product);

    return product.id!;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    
    if(product.id == null){
      // Crear
      await this.createProduct(product);
    } else {
      // Actualizar
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }
}
