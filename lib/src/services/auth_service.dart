import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = "identitytoolkit.googleapis.com";
  final String _firebasToken = "AIzaSyDmAxi4Eb4Wj6MHVCglkLHIfznwCWX4zw4";
  final _storage = const FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(
      _baseUrl,
      '/v1/accounts:signUp',
      {'key': _firebasToken},
    );

    try {
      final resp = await http.post(url, body: json.encode(authData));
      final Map<String, dynamic> decodedResp = json.decode(resp.body);

      if (decodedResp.containsKey('idToken')) {
        // Almacenar el token de forma segura
        await _storage.write(key: 'token', value: decodedResp['idToken']);
        return null; // Usuario creado con éxito
      } else {
        return decodedResp['error']['message']; // Mensaje de error
      }
    } catch (e) {
      return 'Error al conectar con el servidor: $e';
    }
  }

  // Método para obtener el token almacenado
  Future<String?> readToken() async {
    return await _storage.read(key: 'token');
  }

  // Método para eliminar el token (logout)
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}