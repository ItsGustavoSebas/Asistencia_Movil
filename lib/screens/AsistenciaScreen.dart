import 'package:asistencias_movil/screens/LicenciaScreen.dart';
import 'package:flutter/material.dart';
import 'package:asistencias_movil/models/programacion_academica.dart';
import 'package:asistencias_movil/services/gruposervice.dart'; // Asegúrate de importar tu servicio

class Asistenciascreen extends StatefulWidget {
  final ProgramacionAcademica programacion;

  const Asistenciascreen({Key? key, required this.programacion})
      : super(key: key);

  @override
  State<Asistenciascreen> createState() => _AsistenciascreenState();
}

class _AsistenciascreenState extends State<Asistenciascreen> {
  final GrupoService _grupoService = GrupoService();

  Future<void> _marcarAsistencia() async {
    final DateTime now = DateTime.now().subtract(Duration(hours: 4));
    final asistencia = widget.programacion.asistencias.firstWhere(
      (a) => a.fecha.year == now.year && a.fecha.month == now.month && a.fecha.day == now.day,
    );

    double latitud = 0;
    double longitud = 0;

     String resultado = await _grupoService.marcarAsistencia(
      asistencia.id,
      now,
      latitud,
      longitud,
    );

    // Mostrar el resultado al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resultado: $resultado')),
    );

    // Navegar a la pantalla principal si el resultado es correcto
    if (resultado == 'correcto') {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Asistencia'),
      ),
      body: Padding(
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LicenciaScreen(
                        programacionAcademicaId: widget.programacion.id),
                  ),
                );
              },
              child: Text('Solicitar Licencia'),
            )
          ],
        ),
      ),
    );
  }
}
