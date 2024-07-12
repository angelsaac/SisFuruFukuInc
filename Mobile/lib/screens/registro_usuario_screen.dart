import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:furui_fukuinc/providers/auth_providers.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  @override
  _RegistroUsuarioScreenState createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreUsuarioController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _fechaIngresoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _puestoSeleccionado = 'Vendedor';

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState?.validate() ?? false) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await http.post(
        Uri.parse('https://localhost:7128/api/Agentes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'nombreUsuario': _nombreUsuarioController.text,
          'nombre': _nombreController.text,
          'edad': int.parse(_edadController.text),
          'fechaIngreso': _fechaIngresoController.text,
          'acumuladoVentas': 0,
          'puesto': _puestoSeleccionado,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado exitosamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar usuario')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nombreUsuarioController,
                decoration: InputDecoration(labelText: 'Nombre de Usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre de usuario';
                  } else if (value.contains(' ')) {
                    return 'El nombre de usuario no debe contener espacios';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  } else if (RegExp(r'[0-9]').hasMatch(value)) {
                    return 'El nombre no debe contener números';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _edadController,
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la edad';
                  } else if (RegExp(r'[^\d]').hasMatch(value)) {
                    return 'La edad debe ser un número';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaIngresoController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Ingreso',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _fechaIngresoController.text = pickedDate.toString().split(' ')[0];
                      }
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione la fecha de ingreso';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _puestoSeleccionado,
                decoration: InputDecoration(labelText: 'Puesto'),
                items: <String>['Vendedor', 'Supervisor']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _puestoSeleccionado = newValue!;
                  });
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la contraseña';
                  } else if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarUsuario,
                child: Text('Registrar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
