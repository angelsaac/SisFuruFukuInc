import 'package:flutter/material.dart';

class EliminarVentaScreen extends StatelessWidget {
  final List<String> ventas = ['Venta 1', 'Venta 2', 'Venta 3'];

  void _eliminarVenta(BuildContext context, String venta) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$venta eliminada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Venta'),
      ),
      body: ListView.builder(
        itemCount: ventas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ventas[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _eliminarVenta(context, ventas[index]),
            ),
          );
        },
      ),
    );
  }
}
