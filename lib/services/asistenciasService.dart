import 'dart:convert';
import 'package:asistencias_movil/models/asistencias.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:asistencias_movil/services/services.dart';

class AsistenciasService extends ChangeNotifier {
  bool _isLoggerdIn = false;
  String? _token;
  bool isLoading = true;
  bool get authentificated => _isLoggerdIn;
  Servidor servidor = Servidor();
  
  late List<Asistencias> asistencias = [];

  final _storage = const FlutterSecureStorage();


  void storeToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }


  Future<List<Asistencias>> loadAsistencias(String userId) async {
    isLoading = true;
    asistencias = [];

    String? token = _token ?? await _storage.read(key: 'token');
    if (token == null) {
      isLoading = false;
      notifyListeners();
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('${servidor.baseUrl}/adminuser/programacion/asistencias/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> asistenciasMap = json.decode(response.body);

      asistenciasMap.forEach((element) {
      final map = Asistencias.fromMap(element);
      asistencias.add(map);
      });
      isLoading = false;
      notifyListeners();
      return asistencias;
    } else {
      isLoading = false;
      notifyListeners();
      throw Exception('Response does not contain data key');
    }
  }
}
