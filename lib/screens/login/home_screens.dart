// home_screen.dart
import 'package:asistencias_movil/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:asistencias_movil/screens/screens.dart';
import 'package:asistencias_movil/components/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();

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

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, auth, child) {
      if (!auth.authentificated) {
        return Scaffold(
          body: WelcomeScreen(),
        );
      } else {
        return Scaffold(
        drawer: const SideBar(),
        appBar: AppBar(
          title: const Text('Recursos Humanos'),
          
        ),
        body: const Text('Administrador'));
      }
    });
  }
}
