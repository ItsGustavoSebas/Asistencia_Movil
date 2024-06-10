import 'dart:convert';
import 'package:asistencias_movil/models/programacion_academica.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:asistencias_movil/services/services.dart';

class GrupoService extends ChangeNotifier {
  bool _isLoggerdIn = false;
  late List<ProgramacionAcademica> programacion = [];
  String? _token;
  bool isLoading = true;
  bool get authentificated => _isLoggerdIn;
  Servidor servidor = Servidor();

  final _storage = const FlutterSecureStorage();

  Future<List<ProgramacionAcademica>> loadProgramacion(String userId) async {
    isLoading = true;
    programacion = [];

    String? token = _token ?? await _storage.read(key: 'token');
    if (token == null) {
      isLoading = false;
      notifyListeners();
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('${servidor.baseUrl}/adminuser/programacion/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> programacionMap =
          json.decode(response.body)['programacionAcademicas'];

      programacionMap.forEach((element) {
        final map = ProgramacionAcademica.fromMap(element);
        programacion.add(map);
      });
      _isLoggerdIn = true;
      _token = token;
      storeToken(token);
      isLoading = false;
      notifyListeners();
      print(programacion);
      return programacion;
    } else {
      isLoading = false;
      notifyListeners();
      throw Exception('Response does not contain data key');
    }
  }

  void storeToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String> marcarAsistencia(
      int asistenciaId, DateTime fecha, double latitud, double longitud) async {
    try {
      String? token = _token ?? await _storage.read(key: 'token');
      if (token == null) {
        isLoading = false;
        notifyListeners();
        throw Exception('Token not found');
      }
      final response = await http.post(
        Uri.parse('${servidor.baseUrl}/adminuser/programacion/marcar'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'asistenciaId': asistenciaId,
          'fecha': fecha.toIso8601String(),
          'latitud': latitud,
          'longitud': longitud,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        dynamic statusCode = responseBody['statusCode'];
        if (statusCode is int && statusCode == 200) {
          return 'correcto';
        } else {
          return responseBody['message'] ?? 'Error desconocido';
        }
      } else {
        return 'incorrecto';
      }
    } catch (e) {
      return 'error';
    }
  }


  Future<String> solicitarLicencia(int programacionAcademicaId,
      DateTime fechaInicio, DateTime fechaFin, String motivo) async {
    try {
      String? token = _token ?? await _storage.read(key: 'token');
      if (token == null) {
        isLoading = false;
        notifyListeners();
        throw Exception('Token not found');
      }

      final response = await http.post(
        Uri.parse('${servidor.baseUrl}/adminuser/programacion/licencia'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'programacionAcademicaId': programacionAcademicaId,
          'fechaInicio': fechaInicio.toIso8601String().split('T')[0],
          'fechaFin': fechaFin.toIso8601String().split('T')[0],
          'motivo': motivo,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        dynamic statusCode = responseBody['statusCode'];
        if (statusCode is int && statusCode == 200) {
          return 'correcto';
        } else {
          return responseBody['message'] ?? 'Error desconocido';
        }
      } else {
        return 'incorrecto';
      }
    } catch (e) {
      return 'error';
    }
  }

}
