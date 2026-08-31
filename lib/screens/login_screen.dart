import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/AuthService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _handleGoogleLogin() async {
    bool _loading = false;
    String? _error;
    setState(() { _loading = true; _error = null; });
    try {
      await context.read<Authservice>().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _loading = false);
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 1),
            Image.asset(
              //TODO: Eliminar fondo imagen
              'assets/img/logos/logo.jpg',
            ),
            Spacer(flex: 1),
            Text(
              'Bienvenido',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              'Study Planner',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Spacer(flex: 1),
            ElevatedButton(
              onPressed: () {
                _handleGoogleLogin();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Iniciar Sesión con google'),
            ),
            ElevatedButton(
              onPressed: () {
                //TODO: Implementar login con correo
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Iniciar Sesión con Correo'),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
