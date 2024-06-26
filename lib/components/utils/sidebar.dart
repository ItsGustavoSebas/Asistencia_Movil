import 'package:asistencias_movil/screens/ListaDeAsistencias.dart';
import 'package:asistencias_movil/screens/ListaDeLicencias.dart';
import 'package:asistencias_movil/screens/ProgramacionCalendarioScreen.dart';
import 'package:asistencias_movil/screens/screens.dart';
import 'package:asistencias_movil/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthService>(builder: (context, auth, child) {
        if (!auth.authentificated) {
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Iniciar Sesión'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            ],
          );
        } else {
          return ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(auth.user.ourUsers.name),
                accountEmail: Text(auth.user.ourUsers.email),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Text(
                      auth.user.ourUsers.name.isNotEmpty
                          ? auth.user.ourUsers.name[0].toUpperCase()
                          : '?', 
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/utils/sidebar_fondo.jpg'),
                        fit: BoxFit.cover)),
              ),
              const Divider(
                thickness: 3,
                indent: 15,
                endIndent: 15,
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Programación Académica'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProgramacionScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Asistencias'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListaDeAsistenciasScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_rounded),
                title: const Text('Licencias'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LicenciasListScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar Sesión'),
                onTap: () {
                  Provider.of<AuthService>(context, listen: false).logout();
                },
              ),
              
            ],
          );
        }
      }),
    );
  }
}
