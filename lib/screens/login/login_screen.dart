import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asistencias_movil/providers/providers.dart';
import 'package:asistencias_movil/services/auth/auth_service.dart';
import 'package:asistencias_movil/widgets/widgets.dart';
import 'package:asistencias_movil/ui/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Iniciar Sesión',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => loginformprovider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Bienvenido a nuestra app de Recursos Humanos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<loginformprovider>(context);

    return Form(
      key: loginForm.formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: '',
              labelText: 'Correo Electrónico',
              prefixIcon: Icons.alternate_email_sharp,
            ),
            onChanged: (value) => loginForm.email = value,
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: '',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => loginForm.password = value,
            obscureText: true, // Oculta el texto de la contraseña
            validator: (value) {
              if (value != null && value.length >= 8) return null;
              return 'La contraseña es demasiado corta';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.blue,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading ? 'Espere' : 'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;

                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    String respuesta = await authService.login(
                        loginForm.email, loginForm.password, 'movil');

                    if (respuesta == 'correcto') {
                      loginForm.isLoading = false;
                      Navigator.pop(context);
                    } else {
                      loginForm.isLoading = false;
                      _showErrorSnackbar(context, respuesta);
                    }
                  },
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
