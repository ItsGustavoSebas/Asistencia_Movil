import 'package:asistencias_movil/components/components.dart';
import 'package:asistencias_movil/screens/screens.dart';
import 'package:asistencias_movil/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppState());
}

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    );
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UnivSys',
      initialRoute: 'splash',
      routes: {
        '/': (_) => const HomeScreen(),
        'splash': (_) => const SplashScreen(),
        'login': (_) => LoginScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 244, 243),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color.fromARGB(255, 247, 215, 166),
        ),
      ),

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'),
      ],
      locale: const Locale('es', 'ES'), 
    );
  }
}
