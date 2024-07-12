import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegistroVentaScreen extends StatefulWidget {
  final Map<String, dynamic>? venta;
  final VoidCallback onVentaAgregada;

  RegistroVentaScreen({this.venta, required this.onVentaAgregada});

  @override
  _RegistroVentaScreenState createState() => _RegistroVentaScreenState();
}

class _RegistroVentaScreenState extends State<RegistroVentaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _importeController = TextEditingController();
  String _estatusVentaSeleccionado = 'Concretada';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.venta != null) {
      _descripcionController.text = widget.venta!['descripcionArticulo'];
      _fechaController.text = widget.venta!['fechaVenta'];
      _importeController.text = widget.venta!['importeTotal'].toString();
      _estatusVentaSeleccionado = widget.venta!['estatusVenta'];
    }
  }

  Future<void> _agregarVenta() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? idAgente = prefs.getInt('idAgente');

      if (token != null && idAgente != null) {
        final response = await http.post(
          Uri.parse('https://localhost:7128/api/ReportesVentas'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'iD_Agente': idAgente,
            'descripcionArticulo': _descripcionController.text,
            'fechaVenta': _fechaController.text,
            'importeTotal': double.parse(_importeController.text),
            'estatusVenta': _estatusVentaSeleccionado,
            'estatusSupervision': 'En Espera de respuesta',
          }),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Venta registrada exitosamente')),
          );
          widget.onVentaAgregada();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al registrar la venta')),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo obtener el token o ID del agente')),
        );
      }
    }
  }

  Future<void> _editarVenta() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null && widget.venta != null) {
        final response = await http.put(
          Uri.parse('https://localhost:7128/api/ReportesVentas/${widget.venta!['iD_Reporte']}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'iD_Reporte': widget.venta!['iD_Reporte'],
            'iD_Agente': widget.venta!['iD_Agente'],
            'descripcionArticulo': _descripcionController.text,
            'fechaVenta': _fechaController.text,
            'importeTotal': double.parse(_importeController.text),
            'estatusVenta': _estatusVentaSeleccionado,
            'estatusSupervision': 'En Espera de respuesta',
          }),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Venta actualizada exitosamente')),
          );
          widget.onVentaAgregada();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar la venta')),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo obtener el token o ID del agente')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.venta == null ? 'Registrar Venta' : 'Editar Venta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción del Artículo'),
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción del artículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Venta',
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
                        _fechaController.text = pickedDate.toString().split(' ')[0];
                      }
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione la fecha de venta';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _importeController,
                decoration: InputDecoration(labelText: 'Importe Total'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el importe total';
                  } else if (double.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _estatusVentaSeleccionado,
                decoration: InputDecoration(labelText: 'Estatus de Venta'),
                items: <String>['Concretada', 'Pendiente de pago']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _estatusVentaSeleccionado = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: Text(widget.venta == null ? 'Agregar Venta' : 'Guardar Cambios'),
                      onPressed: widget.venta == null ? _agregarVenta : _editarVenta,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
