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

  void updateSelectedProductImage(String path){
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if(newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/dtou6xw6u/image/upload?upload_preset=preset'
    );
    // Definimos la peticion post
    final imageUploadRequest = http.MultipartRequest('POST', url);
    // Indicamos el nombre que tendra la imagen
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);
    // A la peticion le añadimos al foto
    imageUploadRequest.files.add(file);
    // La info que vamos a estar esperando de la peticion
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print("Ha habido un error");
      print(resp.body);
      return null;
    } 

    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }

  Future<String?> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, '/products/${product.id}.json');
    final resp = await http.put(url, body: json.encode(product.toJson()));
    final decodedData = resp.body;

    print(decodedData);

    // Actualizar la lista de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id;
  }

  
  Future<String> createProduct(Product product) async {
    print(product.toJson());
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: json.encode(product.toJson()));
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
