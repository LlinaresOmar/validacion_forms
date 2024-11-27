import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:validacion_forms/src/models/product.dart';
import 'package:validacion_forms/src/providers/product_form_provider.dart';
import 'package:validacion_forms/src/services/products_service.dart';
import 'package:validacion_forms/src/ui/input_decorations.dart';
import 'package:validacion_forms/src/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct),
      child: _ProductScreenBody(productsService: productsService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    super.key,
    required this.productsService,
  });

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    ProductFormProvider productForm = new ProductFormProvider(productsService.selectedProduct);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              ProductImage(url:productForm.product.picture),
              Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          size: 40, color: Colors.white))),
              Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.camera_alt_outlined,
                          size: 40, color: Colors.white))),
            ]),
            _ProductForm(product: productsService.selectedProduct)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!productForm.isValidForm()) return;
          await productsService.saveOrCreateProduct(productForm.product);
        }),
    );
  }
}

class _ProductForm extends StatelessWidget {
  final Product product;

  const _ProductForm({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    ProductFormProvider productForm = new ProductFormProvider(product);
    return Form(
      key: productForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: double.infinity,
          decoration: _formDecorarion(),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if(value == null || value.length < 1){
                    return 'El nombre es obligatorio';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del producto', labelText: 'Nombre:')
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: '${product.price}',
                onChanged: (value){
                  if(double.tryParse(value) == null){
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
                decoration: InputDecorations.authInputDecoration(
                    hintText: '150€', labelText: 'Precio:')
              ),
              SizedBox(height: 30),
              SwitchListTile(
                value: true, 
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: (value) => productForm.updateAvailability(value)
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _formDecorarion() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5)
        ]);
  }
}
