import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_forms/src/providers/register_form_provider.dart';
import 'package:validacion_forms/src/screens/home_screen.dart';
import 'package:validacion_forms/src/ui/input_decorations.dart';
import 'package:validacion_forms/src/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 350,
              ),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Register',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    _RegisterForm(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              RegisterBtn(registerForm: registerForm)
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // Campo de nombre
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'jhon',
                  labelText: 'Nombre',
                  prefixIcon: Icons.person_3_sharp),
              onChanged: (value) => registerForm.name = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es obligatorio';
                }
                return null;
              },
            ),

            // Campo de email
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'jhon.doe@gmail.com',
                  labelText: 'Email',
                  prefixIcon: Icons.alternate_email_sharp),
              onChanged: (value) => registerForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Introduce un email válido';
              },
            ),

            // Campo de contraseña
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '123456',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline_sharp),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                if (value != null && value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),

            // Campo de teléfono
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '93568457',
                  labelText: 'Teléfono',
                  prefixIcon: Icons.phone_android_sharp),
              onChanged: (value) => registerForm.phone = value,
              validator: (value) {
                if (value?.length != 9) {
                  return 'El teléfono debe contener 9 dígitos';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value!)) {
                  return 'El teléfono debe contener solo números';
                }
                return null;
              },
            ),

            // Selector de sexo
            DropdownButtonFormField<String>(
              value: registerForm.sex.isEmpty ? null : registerForm.sex,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Seleccione su sexo',
                  labelText: 'Sexo',
                  prefixIcon: Icons.person),
              onChanged: (String? newValue) {
                registerForm.sex =
                    newValue ?? ''; // Actualiza el sexo seleccionado
              },
              items: ['Masculino', 'Femenino', 'Otro']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El sexo es obligatorio';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecorations.authInputDecoration(
                hintText: '24/12/1999',
                labelText: 'Fecha de Nacimiento',
                prefixIcon: Icons.calendar_month_sharp,
              ),
              onChanged: (value) => registerForm.fechaNac = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Fecha de nacimiento obligatoria';
                }
                final regex = RegExp(
                    r'^\d{2}/\d{2}/\d{4}$');
                if (!regex.hasMatch(value)) {
                  return 'Formato inválido. Usa dd/MM/yyyy';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterBtn extends StatelessWidget {

  final RegisterFormProvider registerForm;

  const RegisterBtn({super.key, required this.registerForm});

  @override
  Widget build(BuildContext context) {
     return MaterialButton(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.deepPurple,
      onPressed: registerForm.isLoading
       ? null
       : () async {
        FocusScope.of(context).unfocus();

        if(!registerForm.isValidForm()) {
        print('Es aqui');
        return;
        }

        registerForm.isLoading = true;

        await Future.delayed(Duration(seconds: 2));

        registerForm.isLoading = false;

        // Llamar a la API

        Navigator.pushReplacementNamed(context, 'home');

      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        child: Text(
          registerForm.isLoading ? 'Espere' : 'Registrarse',
          style: TextStyle(color: Colors.white),
        ),
      ));
  }
}
