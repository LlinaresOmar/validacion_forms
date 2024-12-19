import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_forms/src/providers/register_form_provider.dart';
import 'package:validacion_forms/src/screens/home_screen.dart';
import 'package:validacion_forms/src/services/auth_service.dart';
import 'package:validacion_forms/src/ui/input_decorations.dart';
import 'package:validacion_forms/src/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 350),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Register',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const _RegisterForm(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      Colors.indigo.withOpacity(0.2)),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                ),
                child: const Text(
                  '¿Ya tienes cuenta?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
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
    return Form(
      key: registerForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Campo de email
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'jhon.doe@gmail.com',
              labelText: 'Email',
              prefixIcon: Icons.alternate_email_sharp,
            ),
            onChanged: (value) => registerForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Introduce un email válido';
            },
          ),
          const SizedBox(height: 20),
          // Campo de contraseña
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(
              hintText: '123456',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline_sharp,
            ),
            onChanged: (value) => registerForm.password = value,
            validator: (value) {
              if (value != null && value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          RegisterBtn(registerForm: registerForm),
        ],
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.deepPurple,
      onPressed: registerForm.isLoading
          ? null
          : () async {
              FocusScope.of(context).unfocus();
              final authService =
                  Provider.of<AuthService>(context, listen: false);

              if (!registerForm.isValidForm()) return;

              registerForm.isLoading = true;

              final String? errorMessage =
                  await authService.createUser(registerForm.email, registerForm.password);

              if (errorMessage == null) {
                Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
                registerForm.isLoading = false;
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        child: Text(
          registerForm.isLoading ? 'Espere' : 'Registrarse',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
