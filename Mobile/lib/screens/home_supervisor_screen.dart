import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSupervisorScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('puesto');
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supervisor Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Registrar Usuario'),
              onTap: () {
                Navigator.pushNamed(context, '/registroUsuarioScreen');
              },
            ),
            ListTile(
              title: Text('Mostrar Reportes de Ventas'),
              onTap: () {
                Navigator.pushNamed(context, '/consultaVentasScreen');
              },
            ),
            ListTile(
              title: Text('Grafica'),
              onTap: () {
                Navigator.pushNamed(context, '/graficaScreen');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Bienvenido Supervisor'),
      ),
    );
  }
}
