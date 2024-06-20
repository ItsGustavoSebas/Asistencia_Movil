import 'package:flutter/material.dart';
import 'package:asistencias_movil/models/programacion_academica.dart';
import 'package:asistencias_movil/services/gruposervice.dart';
import 'package:geolocator/geolocator.dart';

class Asistenciascreen extends StatefulWidget {
  final ProgramacionAcademica programacion;

  const Asistenciascreen({Key? key, required this.programacion})
      : super(key: key);

  @override
  State<Asistenciascreen> createState() => _AsistenciascreenState();
}

class _AsistenciascreenState extends State<Asistenciascreen> {
  final GrupoService _grupoService = GrupoService();
  late Position position;
  late double latitud;
  late double longitud;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> _marcarAsistencia() async {
    final DateTime now = DateTime.now();
    final asistencia = widget.programacion.asistencias.firstWhere(
      (a) =>
          a.fecha.year == now.year &&
          a.fecha.month == now.month &&
          a.fecha.day == now.day,
    );

    String resultado = await _grupoService.marcarAsistencia(
      asistencia.id,
      now,
      latitud,
      longitud,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resultado: $resultado')),
    );

    if (resultado == 'correcto') {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future<Position> determinatePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación están denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación están denegados permanentemente, no podemos solicitar permisos.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    try {
      position = await determinatePosition();
      latitud = position.latitude;
      longitud = position.longitude;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener la ubicación: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Asistencia'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.programacion.grupo.materiaCarrera.materia.sigla} - ${widget.programacion.grupo.name}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Módulo: ${widget.programacion.modulo.name}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aula: ${widget.programacion.aula}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hora: ${widget.programacion.diaHorario.horario.horaInicio} - ${widget.programacion.diaHorario.horario.horaFin}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _marcarAsistencia,
                    child: Text('Marcar Asistencia Ahora'),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
