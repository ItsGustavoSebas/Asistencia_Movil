// welcome.dart
import 'package:flutter/material.dart';
import 'package:asistencias_movil/screens/login/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'RRHH',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.purple[100], // background color
              ),
              child: Text(
                'Puestos Disponibles',
                style: TextStyle(
                  color: Colors.purple, // text color
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Acción del botón "Información de la Empresa"
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.purple[100], // background color
              ),
              child: Text(
                'Información de la Empresa',
                style: TextStyle(
                  color: Colors.purple, // text color
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/utils/HomeScreenPicture.png', // Path to your image
                    height: 200,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'ADMINISTRACIÓN',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  Text(
                    'RECURSOS HUMANOS',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bienvenido a nuestra empresa de administración de recursos humanos. Aumenta la productividad en los procesos de remuneraciones, asistencia, documentación, desempeño y mucho más.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey[600],
                    ),
                  ),
                  SizedBox(height: 40),
                  Align(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: Colors.purple[100], // background color
                        minimumSize:
                            Size(200, 50), // Define el tamaño mínimo del botón
                      ),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          color: Colors.purple, // text color
                          fontSize: 20, // Tamaño de fuente del texto
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
