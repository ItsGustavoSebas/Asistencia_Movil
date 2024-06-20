import 'package:flutter/material.dart';
import 'package:asistencias_movil/models/programacion_academica.dart';
import 'package:asistencias_movil/services/gruposervice.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:asistencias_movil/services/auth/auth_service.dart';

class ProgramacionScreen extends StatefulWidget {
  const ProgramacionScreen({super.key});

  @override
  State<ProgramacionScreen> createState() => _ProgramacionScreenState();
}

class _ProgramacionScreenState extends State<ProgramacionScreen> {
  late Future<List<ProgramacionAcademica>> _programacionFuture;
  late GrupoService _programacionService;
  List<ProgramacionAcademica> _programacion = [];

  @override
  void initState() {
    super.initState();
    _programacionService = GrupoService();
    _programacionFuture = _programacionService.loadProgramacion(
        Provider.of<AuthService>(context, listen: false)
            .user
            .ourUsers
            .id
            .toString());
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

  DateTime parseDate(String date) {
    return DateFormat('yyyy-MM-dd').parse(date);
  }

  List<DateTime> getWeekDates(DateTime startDate) {
    return List.generate(7, (index) => startDate.add(Duration(days: index)));
  }

  String normalizeString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâã]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöôõ]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programación de la Semana'),
      ),
      body: FutureBuilder<List<ProgramacionAcademica>>(
        future: _programacionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos disponibles'));
          } else {
            _programacion = snapshot.data!;
            DateTime now = getBoliviaTime();
            DateTime fechaInicioClases = DateTime.now();
            DateTime fechaFinClases = DateTime.now();

            for (var programacion in _programacion) {
              for (var fechaImportante
                  in programacion.grupo.facultadGestion.fechaImportantes) {
                if (fechaImportante.tipo.id == 1) {
                  fechaInicioClases = fechaImportante.fechaInicio;
                  fechaFinClases = fechaImportante.fechaFin;
                }
              }
            }

            List<DateTime> weekDates =
                getWeekDates(now.subtract(Duration(days: now.weekday - 1)));

            return ListView.builder(
              itemCount: weekDates.length,
              itemBuilder: (context, index) {
                DateTime date = weekDates[index];
                String dayName =
                    DateFormat('EEEE', 'es_ES').format(date).toUpperCase();

                List<ProgramacionAcademica> dayProgramacion =
                    _programacion.where((programacion) {
                  return normalizeString(programacion.diaHorario.dia.name) ==
                          normalizeString(dayName) &&
                      date.isAfter(fechaInicioClases) &&
                      date.isBefore(fechaFinClases);
                }).toList();

                if (dayProgramacion.isEmpty) {
                  return SizedBox.shrink();
                }

                // Ordenar por hora de inicio
                dayProgramacion.sort((a, b) => a.diaHorario.horario.horaInicio
                    .compareTo(b.diaHorario.horario.horaInicio));

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: dayProgramacion.map((programacion) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${programacion.grupo.materiaCarrera.materia.sigla}-${programacion.grupo.name} - ${programacion.modulo.name}-${programacion.aula}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${programacion.diaHorario.horario.horaInicio} - ${programacion.diaHorario.horario.horaFin}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
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
