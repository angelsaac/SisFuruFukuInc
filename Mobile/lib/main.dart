import 'package:flutter/material.dart';
import 'package:furui_fukuinc/providers/auth_providers.dart';
import 'package:provider/provider.dart';
import 'screens/consulta_ventas_screen.dart';
import 'screens/login_screen.dart';
import 'screens/historial_ventas_screen.dart';
import 'screens/registro_usuario_screen.dart';
import 'screens/grafica_screen.dart';
import 'screens/home_supervisor_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Furui Fuku Inc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/consultaVentasScreen': (context) => ConsultaVentasScreen(),
        '/historialVentasScreen': (context) => HistorialVentasScreen(),
        '/registroUsuarioScreen': (context) => RegistroUsuarioScreen(),
        '/graficaScreen': (context) => GraficaScreen(),
        '/homeSupervisorScreen': (context) => HomeSupervisorScreen(),
      },
    );
  }
}
