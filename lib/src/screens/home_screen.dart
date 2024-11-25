import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_forms/src/services/products_service.dart';
import 'package:validacion_forms/src/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index){
          return ProductCard();
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){})
      );
  }
}
