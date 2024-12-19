import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_forms/src/providers/login_form_provider.dart';
import 'package:validacion_forms/src/ui/input_decorations.dart';
import 'package:validacion_forms/src/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 350,),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm())
                  ],
                )
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'register');
                },
                style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(Colors.indigo.withOpacity(0.2)),
                  shape: const WidgetStatePropertyAll(StadiumBorder())
                ),
                child: Text(
                  'Crear una nueva cuenta',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);  
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
        children: [
          TextFormField(
            validator: (value){
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);
              return regExp.hasMatch(value ?? '') ? null : 'Introduce un email válido';
            },
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(hintText: 'jhon.doe@gmail.com', labelText: 'Email', prefixIcon: Icons.alternate_email_sharp),
            onChanged: (value) => loginForm.email = value,

          ),
          TextFormField(
            validator: (value){
              if(value != null && value.length < 6){
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(hintText: '123456', labelText: 'Contraseña', prefixIcon: Icons.lock_outline_sharp),
            onChanged: (value) => loginForm.password = value,
          ),
          SizedBox(height: 30),
          LoginBtn(loginForm: loginForm,)
        ],
      )),
    );
  }
}

class LoginBtn extends StatelessWidget {

  final LoginFormProvider loginForm;

  const LoginBtn({
    super.key, required this.loginForm
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.deepPurple,
      onPressed: loginForm.isLoading
       ? null
       : () async {
        FocusScope.of(context).unfocus();

        if(!loginForm.isValidForm()) return;

        loginForm.isLoading = true;

        await Future.delayed(Duration(seconds: 2));

        loginForm.isLoading = false;

        // Llamar a la API

        Navigator.pushReplacementNamed(context, 'home');

      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        child: Text(
          loginForm.isLoading ? 'Espere' : 'Acceder',
          style: TextStyle(color: Colors.white),
        ),
      ));
  }
}
