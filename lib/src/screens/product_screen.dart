import 'package:flutter/material.dart';
import 'package:validacion_forms/src/ui/input_decorations.dart';
import 'package:validacion_forms/src/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              ProductImage(),
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
            _ProductForm()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){}),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: _formDecorarion(),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto', labelText: 'Nombre:')
            ),
            SizedBox(height: 30),
            TextFormField(
              decoration: InputDecorations.authInputDecoration(
                  hintText: '150€', labelText: 'Precio:')
            ),
            SizedBox(height: 30),
            SwitchListTile(
              value: true, 
              title: Text('Disponible'),
              activeColor: Colors.indigo,
              onChanged: (value){}
            ),
          ],
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
