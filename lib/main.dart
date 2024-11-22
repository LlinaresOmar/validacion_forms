import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_forms/src/providers/login_form_provider.dart';
import 'package:validacion_forms/src/providers/register_form_provider.dart';
import 'package:validacion_forms/src/screens/register_screen.dart';
import 'package:validacion_forms/src/screens/screens.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterFormProvider()), // Proveedor para el registro
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),    // Proveedor para el login
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
      ),
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginScreen(),
        'home': (context) => HomeScreen(),
        'register' : (context) => RegisterScreen(),
      },
    );
  }
}