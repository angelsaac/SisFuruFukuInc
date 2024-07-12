import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'registro_venta_screen.dart';

class HistorialVentasScreen extends StatefulWidget {
  @override
  _HistorialVentasScreenState createState() => _HistorialVentasScreenState();
}

class _HistorialVentasScreenState extends State<HistorialVentasScreen> {
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
    int? idAgente = prefs.getInt('idAgente');

    if (token != null && idAgente != null) {
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
          ventas = jsonResponse
              .where((venta) => venta['iD_Agente'] == idAgente)
              .map((venta) => venta as Map<String, dynamic>)
              .toList();
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

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('puesto');
    await prefs.remove('idAgente');
    Navigator.pushReplacementNamed(context, '/');
  }

  Future<void> _deleteVenta(int idReporte) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.delete(
        Uri.parse('https://localhost:7128/api/ReportesVentas/$idReporte'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Venta eliminada exitosamente')),
        );
        _fetchVentas();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la venta')),
        );
      }
    }
  }

  void _editVenta(Map<String, dynamic> venta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistroVentaScreen(
          venta: venta,
          onVentaAgregada: _fetchVentas,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Ventas'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  ventas.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.warning, color: Colors.red, size: 48),
                                Text('Sin ventas'),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: ventas.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(ventas[index]['descripcionArticulo']),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Fecha: ${ventas[index]['fechaVenta']}'),
                                      Text('Importe: \$${ventas[index]['importeTotal']}'),
                                      Text('Estatus de Venta: ${ventas[index]['estatusVenta']}'),
                                      Text('Estatus de Supervisión: ${ventas[index]['estatusSupervision']}'),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.yellow),
                                        onPressed: () => _editVenta(ventas[index]),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deleteVenta(ventas[index]['iD_Reporte']),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  ElevatedButton(
                    child: Text('Agregar Venta'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistroVentaScreen(
                            onVentaAgregada: _fetchVentas,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
