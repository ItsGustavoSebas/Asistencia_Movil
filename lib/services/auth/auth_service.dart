import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:asistencias_movil/models/models.dart';
import 'package:asistencias_movil/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  bool _isLoggerdIn = false;
  User? _user;
  String? _token;

  bool get authentificated => _isLoggerdIn;
  User get user => _user!;
  Servidor servidor = Servidor();

  final _storage = const FlutterSecureStorage();

  Future<String> login(
      String email, String password, String device_name) async {
    try {
      final response = await http.post(
        Uri.parse('${servidor.baseUrl}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String token = responseBody['token'];
        tryToken(token);
        return 'correcto';
      } else {
        return 'incorrecto';
      }
    } catch (e) {
      return 'error';
    }
  }

  Future<bool> checkAuthentication() async {
    if (_isLoggerdIn) {
      return true;
    } else {
      String? token = _token ?? await _storage.read(key: 'token');
      if (token != null) {
        try {
          final response = await http.get(
            Uri.parse('${servidor.baseUrl}/adminuser/get-profile'),
            headers: {'Authorization': 'Bearer $token'},
          );
          if (response.statusCode == 200) {
            var responseBody = jsonDecode(response.body);
            if (responseBody.containsKey('data')) {
              _user = User.fromJson(responseBody['data']);
              _isLoggerdIn = true;
              _token = token;
              storeToken(token);
              notifyListeners();
              return true;
            } else {
              // Manejar el caso en el que la respuesta no contiene los datos esperados
              return false;
            }
          } else {
            // Manejar el caso en el que la solicitud no fue exitosa (código de estado diferente de 200)
            return false;
          }
        } catch (e) {
          print(e);
          return false;
        }
      } else {
        return false;
      }
    }
  }

  void tryToken(String? token) async {
    if (token == null) {
      return;
    } else {
      try {
        final response = await http.get(Uri.parse('${servidor.baseUrl}/adminuser/get-profile'),
            headers: {'Authorization': 'Bearer $token'});

        print(response.body);
        _isLoggerdIn = true;
        _user = User.fromJson(jsonDecode(response.body));
        _token = token;
        storeToken(token);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken(String token) async {
    _storage.write(key: 'token', value: token);
  }

  void logout() async {
    try {
      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    _user = null;
    _isLoggerdIn = false;
    _user = null;
    await _storage.delete(key: 'token');
  }
}
