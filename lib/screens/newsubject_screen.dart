import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'package:study_planner/services/AuthService.dart';

class NewsubjectScreen extends StatefulWidget {
  const NewsubjectScreen({super.key});

  @override
  State<NewsubjectScreen> createState() => _NewsubjectScreenState();
}

class _NewsubjectScreenState extends State<NewsubjectScreen> {
  Color pickColor = Colors.white;

  TextEditingController subjectNameController = TextEditingController();
  TextEditingController hoursController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _handleColorPicker() async {
    Color tempColor = pickColor;

    Color? result = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Elige un color'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: tempColor,
              onColorChanged: (Color value) {
                tempColor = value;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              // cancelar, sin devolver color
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(tempColor),
              // confirmar
              child: const Text('Seleccionar'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        pickColor = result;
      });
    }
  }

  Future<void> _handleHoursController(
      String text,
      String hours,
      Color color,
      ) async {
    await FirebaseFirestore.instance // Añadido el await
        .collection('users')
        .doc('YR5HDNf6ozVYrcsJAAT5xTejsq23')
        .collection('subjects')
        .add({
      'name': text, // Usando el parámetro
      'hours': hours, // Usando el parámetro
      'color': color.toARGB32(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva asignatura'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    "Crear asignatura nueva",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  const SizedBox(height: 24),
                  TextFormField(
                    controller: subjectNameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre asignatura',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: hoursController,
                    decoration: InputDecoration(
                      labelText: 'Horas de estudio',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese las horas de estudio';
                      } else {
                        if (int.tryParse(value) == null) {
                          return 'Por favor ingrese un número';
                        } else {
                          if (int.parse(value) < 1) {
                            return 'Por favor ingrese un número mayor a 0';
                          }
                        }
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      _handleColorPicker();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: pickColor,
                      foregroundColor:
                          ThemeData.estimateBrightnessForColor(pickColor) ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: Text("Color Asignatura"),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _handleHoursController(
                          subjectNameController.text,
                          hoursController.text,
                          pickColor,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Asignatura creada')),
                        );

                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/home', (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor complete todos los campos',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('New Subject'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
