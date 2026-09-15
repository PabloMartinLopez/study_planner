import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_planner/services/AuthService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _handleLogout() async {
    await context.read<Authservice>().signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> _handleNewSubject() async {
    Navigator.of(context).pushNamed('/newSubject', arguments: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            const Text('Home Screen'),
            ElevatedButton(
              onPressed: () {
                _handleNewSubject();
              },
              child: Text("Nueva asignatura"),
            ),
            // Text(context.read<Authservice>().currentUser!.uid),
            ElevatedButton(
              onPressed: () {
                _handleLogout();
              },
              child: Text("Salir"),
            ),
          ],
        ),
      ),
    );
  }
}
