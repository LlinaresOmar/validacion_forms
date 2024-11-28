import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_forms/src/models/product.dart';
import 'package:validacion_forms/src/screens/product_screen.dart';
import 'package:validacion_forms/src/screens/screens.dart';
import 'package:validacion_forms/src/services/products_service.dart';
import 'package:validacion_forms/src/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    if(productsService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              productsService.selectedProduct = productsService.products[index].copy();
              Navigator.pushNamed(context, 'product');
            },
            child: ProductCard(
              product: productsService.products[index]
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          // Creamos un nuevo producto
          productsService.selectedProduct = new Product(
            available: false, 
            name: '', 
            price: 0)
            ;
          Navigator.pushNamed(context, 'product');
        })
    );
  }
}
