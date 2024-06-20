import 'dart:convert';
import 'package:asistencias_movil/models/licencia.dart';
import 'package:asistencias_movil/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LicenciaService extends ChangeNotifier {
  late List<Licencias> licencias = [];
  bool isLoading = true;
  Servidor servidor = Servidor();
  String? _token;
  bool get authentificated => _isLoggerdIn;
  bool _isLoggerdIn = false;
  
  Future<List<Licencias>> loadLicencias(String userId) async {
    isLoading = true;
    final _storage = const FlutterSecureStorage();
    licencias = [];
    String? token = _token ?? await _storage.read(key: 'token');
    if (token == null) {
      isLoading = false;
      notifyListeners();
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('${servidor.baseUrl}/adminuser/licencias/user/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to load licencias');
    }

    final List<dynamic> licenciasMap = json.decode(response.body);

    licenciasMap.forEach((element) {
      final map = Licencias.fromMap(element);
      licencias.add(map);
    });

    isLoading = false;
    notifyListeners();
    return licencias;
  }
}
