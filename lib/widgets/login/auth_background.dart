import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [_HederIcon(), child],
      ),
    );
  }
}

class _HederIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ), // Margen superior del icono
          Center(
            child: SizedBox(
              width: 300,
              child: Image(
                image: AssetImage('assets/utils/splash.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
