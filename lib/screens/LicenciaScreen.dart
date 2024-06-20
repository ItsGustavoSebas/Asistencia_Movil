import 'package:flutter/material.dart';
import 'package:asistencias_movil/services/gruposervice.dart';

class LicenciaScreen extends StatefulWidget {
  final int programacionAcademicaId;

  const LicenciaScreen({Key? key, required this.programacionAcademicaId})
      : super(key: key);

  @override
  _LicenciaScreenState createState() => _LicenciaScreenState();
}

class _LicenciaScreenState extends State<LicenciaScreen> {
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _solicitarLicencia() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      DateTime fechaInicio = DateTime.parse(_fechaInicioController.text);
      DateTime fechaFin = DateTime.parse(_fechaFinController.text);
      String motivo = _motivoController.text;

      String resultado = await GrupoService().solicitarLicencia(
          widget.programacionAcademicaId, fechaInicio, fechaFin, motivo);

      setState(() {
        _isLoading = false;
      });

      if (resultado == 'correcto') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Licencia solicitada con éxito')));
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al solicitar licencia')));
      }
    }
  }

  String? _validateFecha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese una fecha';
    }
    try {
      DateTime.parse(value);
    } catch (e) {
      return 'Formato de fecha incorrecto (yyyy-MM-dd)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar Licencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fechaInicioController,
                decoration:
                    InputDecoration(labelText: 'Fecha de Inicio (yyyy-MM-dd)'),
                validator: _validateFecha,
              ),
              TextFormField(
                controller: _fechaFinController,
                decoration:
                    InputDecoration(labelText: 'Fecha de Fin (yyyy-MM-dd)'),
                validator: _validateFecha,
              ),
              TextFormField(
                controller: _motivoController,
                decoration: InputDecoration(labelText: 'Motivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un motivo';
                  }
                  return null;
                },
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
      ),
    );
  }
}
