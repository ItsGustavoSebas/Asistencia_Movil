import 'package:asistencias_movil/models/asistencias.dart';
import 'package:asistencias_movil/services/asistenciasService.dart';
import 'package:asistencias_movil/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListaDeAsistenciasScreen extends StatefulWidget {
  @override
  _ListaDeAsistenciasScreenState createState() =>
      _ListaDeAsistenciasScreenState();
}

class _ListaDeAsistenciasScreenState extends State<ListaDeAsistenciasScreen> {
  late Future<List<Asistencias>> _asistenciasFuture;
  late AsistenciasService _asistenciasService;
  Map<String, List<Asistencias>> _asistenciasGroupedByDate = {};

  @override
  void initState() {
    super.initState();
    _asistenciasService = AsistenciasService();
    final userId = Provider.of<AuthService>(context, listen: false)
        .user
        .ourUsers
        .id
        .toString();
    _asistenciasFuture = _asistenciasService.loadAsistencias(userId);
  }

  DateTime getBoliviaTime() {
    return DateTime.now();
  }

  DateTime parseHora(String hora) {
    final now = getBoliviaTime();
    final timeParts = hora.split(':');
    return DateTime(now.year, now.month, now.day, int.parse(timeParts[0]),
        int.parse(timeParts[1]));
  }

  Color getStateColor(String estado) {
    switch (estado) {
      case 'Presente':
        return Colors.green;
      case 'Falta':
        return Colors.red;
      case 'Licencia':
        return Colors.blue;
      case 'Atraso':
        return const Color.fromARGB(255, 255, 123, 0);
      default:
        return Colors.black;
    }
  }

  void groupAsistenciasByDate(List<Asistencias> asistencias) {
    _asistenciasGroupedByDate = {};
    DateTime now = DateTime.now();
    String today = DateFormat('dd/MM/yyyy').format(now);
    for (var asistencia in asistencias) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(asistencia.fecha);
      // Check if the date is today and the start time has passed
      if (formattedDate == today) {
        DateTime horaInicio = parseHora(
            asistencia.programacionAcademica.diaHorario.horario.horaInicio);
        if (horaInicio.isAfter(now)) continue;
      }
      if (_asistenciasGroupedByDate.containsKey(formattedDate)) {
        _asistenciasGroupedByDate[formattedDate]!.add(asistencia);
      } else {
        _asistenciasGroupedByDate[formattedDate] = [asistencia];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencias'),
      ),
      body: FutureBuilder<List<Asistencias>>(
        future: _asistenciasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay asistencias disponibles'));
          } else {
            groupAsistenciasByDate(snapshot.data!);
            return ListView.builder(
              itemCount: _asistenciasGroupedByDate.keys.length,
              itemBuilder: (context, index) {
                String date = _asistenciasGroupedByDate.keys.elementAt(index);
                List<Asistencias> asistenciasForDate =
                    _asistenciasGroupedByDate[date]!;
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Column(
                          children: asistenciasForDate.map((asistencia) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${asistencia.programacionAcademica.grupo.materiaCarrera.materia.sigla} - ${asistencia.programacionAcademica.grupo.name}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: getStateColor(asistencia.estado),
                                  ),
                                ),
                                Text(
                                  'Hora: ${asistencia.programacionAcademica.diaHorario.horario.horaInicio} - ${asistencia.programacionAcademica.diaHorario.horario.horaFin}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                if (asistencia.estado != "Falta" &&
                                    asistencia.estado != "Licencia") ...[
                                  Text(
                                    'Hora Marcada: ${asistencia.fecha.hour.toString().padLeft(2, '0')}:${asistencia.fecha.minute.toString().padLeft(2, '0')}:${asistencia.fecha.second.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: getStateColor(asistencia.estado),
                                    ),
                                  ),
                                ],
                                Divider(),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
