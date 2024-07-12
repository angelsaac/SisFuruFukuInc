import 'package:flutter/material.dart';

class EditarVentaScreen extends StatefulWidget {
  @override
  _EditarVentaScreenState createState() => _EditarVentaScreenState();
}

class _EditarVentaScreenState extends State<EditarVentaScreen> {
  final _formKey = GlobalKey<FormState>();

  void _editarVenta() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Venta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción del Artículo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción del artículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fecha de la Venta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de la venta';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Importe Total'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el importe total de la venta';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Estatus de la Venta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el estatus de la venta';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Estatus de Supervisión'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el estatus de supervisión';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Guardar Cambios'),
                onPressed: _editarVenta,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
