import 'package:asistencias_movil/screens/AsistenciaScreen.dart';
import 'package:asistencias_movil/screens/ListaDeAsistencias.dart';
import 'package:flutter/material.dart';
import 'package:asistencias_movil/models/programacion_academica.dart';
import 'package:asistencias_movil/screens/ProgramacionCalendarioScreen.dart';
import 'package:asistencias_movil/services/auth/auth_service.dart';
import 'package:asistencias_movil/services/gruposervice.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:asistencias_movil/screens/screens.dart';
import 'package:asistencias_movil/components/components.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  late Future<List<ProgramacionAcademica>> _programacionFuture;
  late GrupoService _programacionService;
  List<ProgramacionAcademica> _programacion = [];

  @override
  void initState() {
    readToken();
    super.initState();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<AuthService>(context, listen: false).tryToken(token);
    print(token);
  }

  String getCurrentDay() {
    DateTime now = getBoliviaTime();
    List<String> daysOfWeek = [
      "LUNES",
      "MARTES",
      "MIÉRCOLES",
      "JUEVES",
      "VIERNES",
      "SÁBADO",
      "DOMINGO"
    ];
    return daysOfWeek[now.weekday - 1];
  }

  String getCurrentDate() {
    DateTime now = getBoliviaTime();
    String day = DateFormat('d', 'es_ES').format(now);
    String month = DateFormat('MMMM', 'es_ES').format(now);
    return '$day de $month'.toUpperCase();
  }

  DateTime getBoliviaTime() {
    return DateTime.now().subtract(Duration(hours: 4));
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

  bool hasMarkedAttendanceToday(ProgramacionAcademica programacion) {
    DateTime now = getBoliviaTime();
    return programacion.asistencias.any((asistencia) {
      DateTime fechaAsistencia = asistencia.fecha;
      return fechaAsistencia.year == now.year &&
          fechaAsistencia.month == now.month &&
          fechaAsistencia.day == now.day &&
          (asistencia.estado == "Presente" ||
              asistencia.estado == "Licencia" ||
              asistencia.estado == "Atraso");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, auth, child) {
      if (!auth.authentificated) {
        return Scaffold(
          body: WelcomeScreen(),
        );
      } else {
        final user_id = auth.user.ourUsers.id.toString();
        _programacionService = GrupoService();
        _programacionFuture = _programacionService.loadProgramacion(user_id);

        return Scaffold(
          drawer: const SideBar(),
          appBar: AppBar(
            title: const Text('UnivSys'),
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
                bool isDiaNoLaborable = false;

                for (var programacion in _programacion) {
                  for (var fechaImportante
                      in programacion.grupo.facultadGestion.fechaImportantes) {
                    if (fechaImportante.tipo.id == 1) {
                      fechaInicioClases = (fechaImportante.fechaInicio);
                      fechaFinClases = (fechaImportante.fechaFin);
                    } else if (fechaImportante.tipo.id == 2) {
                      DateTime fechaNoLaborable = (fechaImportante.fechaInicio);
                      if (now.year == fechaNoLaborable.year &&
                          now.month == fechaNoLaborable.month &&
                          now.day == fechaNoLaborable.day) {
                        isDiaNoLaborable = true;
                      }
                    }
                  }
                }

                List<ProgramacionAcademica> programacionFiltrada =
                    _programacion.where((programacion) {
                  return normalizeString(programacion.diaHorario.dia.name) ==
                          normalizeString(getCurrentDay()) &&
                      now.isBefore(
                          parseHora(programacion.diaHorario.horario.horaFin)) &&
                      now.isAfter(fechaInicioClases) &&
                      now.isBefore(fechaFinClases);
                }).toList();

                // Ordenar por hora de inicio
                programacionFiltrada.sort((a, b) =>
                    parseHora(a.diaHorario.horario.horaInicio)
                        .compareTo(parseHora(b.diaHorario.horario.horaInicio)));

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              child: ClipOval(
                                child: Text(
                                  auth.user.ourUsers.name.isNotEmpty
                                      ? auth.user.ourUsers.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(fontSize: 35),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(auth.user.ourUsers.name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  auth.user.ourUsers.cargo.name,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navegar a la vista de calendario
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProgramacionScreen()),
                            );
                          },
                          child: Text('Ver Programación Académica'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navegar a la vista de reporte de asistencias
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListaDeAsistenciasScreen()),
                            );
                          },
                          child: Text('Ver Reporte de Asistencias'),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getCurrentDay(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  getCurrentDate(),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                if (!isDiaNoLaborable) ...[
                                  if (!programacionFiltrada.isEmpty) ...[
                                    Row(
                                      children: [
                                        Container(
                                          width: 4,
                                          height: 70 *
                                              programacionFiltrada.length
                                                  .toDouble(),
                                          color: Colors.lightBlue,
                                        ),
                                        SizedBox(width: 8),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: programacionFiltrada
                                              .map((programacion) {
                                            bool canMarkAttendance = now
                                                    .isAfter(parseHora(
                                                        programacion
                                                            .diaHorario
                                                            .horario
                                                            .horaInicio)) &&
                                                now.isBefore(parseHora(
                                                    programacion.diaHorario
                                                        .horario.horaFin)) &&
                                                !hasMarkedAttendanceToday(
                                                    programacion);
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                SizedBox(height: 16),
                                                if (canMarkAttendance) ...[
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Asistenciascreen(
                                                            programacion:
                                                                programacion,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Asistencia'),
                                                  ),
                                                ]
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ] else ...[
                                    Text(
                                      'No hay horarios próximos para hoy.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ]
                                ] else ...[
                                  Text(
                                    'Hoy es un día no laborable.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        );
      }
    });
  }
}
