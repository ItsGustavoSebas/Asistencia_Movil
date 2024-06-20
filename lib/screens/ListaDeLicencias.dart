  import 'package:asistencias_movil/components/components.dart';
import 'package:asistencias_movil/models/licencia.dart';
import 'package:asistencias_movil/services/licenciaService.dart';
import 'package:asistencias_movil/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class LicenciasListScreen extends StatefulWidget {
  const LicenciasListScreen({super.key});

  @override
  State<LicenciasListScreen> createState() => _LicenciasListScreenState();
}

class _LicenciasListScreenState extends State<LicenciasListScreen> {
  late Future<List<Licencias>> _licenciasFuture;
  late LicenciaService _licenciasService;

  @override
  void initState() {
    super.initState();
    _licenciasService = LicenciaService();
    final userId = Provider.of<AuthService>(context, listen: false)
        .user
        .ourUsers
        .id
        .toString();
    _licenciasFuture = _licenciasService.loadLicencias(userId);
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        title: const Text('Lista de Licencias'),
      ),
      body: FutureBuilder<List<Licencias>>(
          future: _licenciasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay licencias disponibles'));
            } else {
              return ListView.builder(
                  itemCount: _licenciasService.licencias.length,
                  itemBuilder: (context, index) {
                    final licencia = _licenciasService.licencias[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Licencia: ${licencia.id}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Desde: ${formatDate(licencia.fechaInicio)}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Hasta: ${formatDate(licencia.fechaFin)}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Motivo: ${licencia.motivo}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              licencia.aprobado == true
                                  ? 'Aprobado'
                                  : licencia.aprobado == false
                                      ? 'Rechazado'
                                      : 'Pendiente',
                              style: TextStyle(
                                  color: licencia.aprobado == true
                                      ? Colors.green
                                      : licencia.aprobado == false
                                          ? Colors.red
                                          : Colors.orange,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
