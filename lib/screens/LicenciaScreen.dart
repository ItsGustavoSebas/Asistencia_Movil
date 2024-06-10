import 'package:flutter/material.dart';
import 'package:asistencias_movil/services/gruposervice.dart';

class LicenciaScreen extends StatefulWidget {
  final int programacionAcademicaId;

  const LicenciaScreen({Key? key, required this.programacionAcademicaId}) : super(key: key);

  @override
  _LicenciaScreenState createState() => _LicenciaScreenState();
}

class _LicenciaScreenState extends State<LicenciaScreen> {
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();
  bool _isLoading = false;

  Future<void> _solicitarLicencia() async {
    setState(() {
      _isLoading = true;
    });

    DateTime fechaInicio = DateTime.parse(_fechaInicioController.text);
    DateTime fechaFin = DateTime.parse(_fechaFinController.text);
    String motivo = _motivoController.text;

    String resultado = await GrupoService().solicitarLicencia(widget.programacionAcademicaId, fechaInicio, fechaFin, motivo);

    setState(() {
      _isLoading = false;
    });

    if (resultado == 'correcto') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Licencia solicitada con éxito')));
      Navigator.pushReplacementNamed(context, '/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al solicitar licencia')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar Licencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fechaInicioController,
              decoration: InputDecoration(labelText: 'Fecha de Inicio (yyyy-MM-dd)'),
            ),
            TextField(
              controller: _fechaFinController,
              decoration: InputDecoration(labelText: 'Fecha de Fin (yyyy-MM-dd)'),
            ),
            TextField(
              controller: _motivoController,
              decoration: InputDecoration(labelText: 'Motivo'),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _solicitarLicencia,
                child: Text('Solicitar Licencia'),
              ),
          ],
        ),
      ),
    );
  }
}
