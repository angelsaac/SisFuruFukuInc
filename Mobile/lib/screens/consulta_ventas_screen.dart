import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConsultaVentasScreen extends StatefulWidget {
  @override
  _ConsultaVentasScreenState createState() => _ConsultaVentasScreenState();
}

class _ConsultaVentasScreenState extends State<ConsultaVentasScreen> {
  List<Map<String, dynamic>> ventas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVentas();
  }

  Future<void> _fetchVentas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('https://localhost:7128/api/ReportesVentas'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          ventas = jsonResponse.map((venta) => venta as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener las ventas')),
        );
      }
    }
  }

  Future<void> _actualizarEstatusSupervision(int idReporte, String nuevoEstatus, Map<String, dynamic> venta) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.put(
        Uri.parse('https://localhost:7128/api/ReportesVentas/$idReporte'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'iD_Reporte': idReporte,
          'iD_Agente': venta['iD_Agente'],
          'descripcionArticulo': venta['descripcionArticulo'],
          'fechaVenta': venta['fechaVenta'],
          'importeTotal': venta['importeTotal'],
          'estatusVenta': venta['estatusVenta'],
          'estatusSupervision': nuevoEstatus,
        }),
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Estatus actualizado exitosamente')),
        );
        _fetchVentas();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el estatus')),
        );
      }
    }
  }

  void _navigateToEditScreen(BuildContext context, Map<String, dynamic> venta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarVentaScreen(
          venta: venta,
          actualizarEstatusSupervision: _actualizarEstatusSupervision,
        ),
      ),
    ).then((_) {
      _fetchVentas(); // Refresh the list after returning from the edit screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Reportes de Ventas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: ventas.length,
                      itemBuilder: (context, index) {
                        final venta = ventas[index];
                        final estatusActual = venta['estatusSupervision'];

                        return Card(
                          child: ListTile(
                            title: Text(venta['descripcionArticulo']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fecha: ${venta['fechaVenta']}'),
                                Text('Importe: \$${venta['importeTotal']}'),
                                Text('Estatus de Venta: ${venta['estatusVenta']}'),
                                Text('Estatus de Supervisión: $estatusActual'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, color: Color.fromARGB(255, 202, 133, 28)),
                              onPressed: () => _navigateToEditScreen(context, venta),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class EditarVentaScreen extends StatefulWidget {
  final Map<String, dynamic> venta;
  final Future<void> Function(int, String, Map<String, dynamic>) actualizarEstatusSupervision;

  EditarVentaScreen({required this.venta, required this.actualizarEstatusSupervision});

  @override
  _EditarVentaScreenState createState() => _EditarVentaScreenState();
}

class _EditarVentaScreenState extends State<EditarVentaScreen> {
  String? _estatusSupervisionSeleccionado;
  final List<String> _estatusOptions = ['Seleccione una opción', 'Aceptada', 'Rechazada'];

  @override
  void initState() {
    super.initState();
    _estatusSupervisionSeleccionado = _estatusOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Venta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nombre del Agente: ${widget.venta['nombreAgente']}'),
            Text('Descripción del Artículo: ${widget.venta['descripcionArticulo']}'),
            Text('Fecha de la Venta: ${widget.venta['fechaVenta']}'),
            Text('Importe Total: \$${widget.venta['importeTotal']}'),
            Text('Estatus de Venta: ${widget.venta['estatusVenta']}'),
            DropdownButtonFormField<String>(
              value: _estatusSupervisionSeleccionado,
              decoration: InputDecoration(labelText: 'Estatus de Supervisión'),
              items: _estatusOptions
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _estatusSupervisionSeleccionado = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Actualizar'),
              onPressed: () {
                if (_estatusSupervisionSeleccionado != null && _estatusSupervisionSeleccionado != 'Seleccione una opción') {
                  widget.actualizarEstatusSupervision(
                    widget.venta['iD_Reporte'],
                    _estatusSupervisionSeleccionado!,
                    widget.venta,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, seleccione un estatus válido.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
