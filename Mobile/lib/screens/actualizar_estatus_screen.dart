import 'package:flutter/material.dart';

class ActualizarEstatusScreen extends StatelessWidget {
  final List<String> ventas = ['Venta 1', 'Venta 2', 'Venta 3'];

  void _actualizarEstatus(BuildContext context, String venta, String estatus) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$venta estatus actualizado a $estatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Estatus de Supervisión'),
      ),
      body: ListView.builder(
        itemCount: ventas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ventas[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => _actualizarEstatus(context, ventas[index], 'Aceptada'),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => _actualizarEstatus(context, ventas[index], 'Rechazada'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
