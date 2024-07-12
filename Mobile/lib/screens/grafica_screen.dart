import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/venta_model.dart';

class GraficaScreen extends StatefulWidget {
  @override
  _GraficaScreenState createState() => _GraficaScreenState();
}

class _GraficaScreenState extends State<GraficaScreen> {
  late Future<List<Venta>> futureVentas;

  @override
  void initState() {
    super.initState();
    futureVentas = fetchVentas();
  }

  Future<List<Venta>> fetchVentas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token is null');
    }

    final response = await http.get(
      Uri.parse('https://localhost:7128/api/ReportesVentas'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      Map<String, double> ventasMap = {};

      for (var item in jsonResponse) {
        String nombreAgente = item['nombreAgente'];
        double importeTotal = item['importeTotal'].toDouble();

        if (ventasMap.containsKey(nombreAgente)) {
          ventasMap[nombreAgente] = ventasMap[nombreAgente]! + importeTotal;
        } else {
          ventasMap[nombreAgente] = importeTotal;
        }
      }

      List<Venta> ventas = ventasMap.entries
          .map((entry) => Venta(nombreAgente: entry.key, totalVentas: entry.value))
          .toList();

      return ventas;
    } else {
      throw Exception('Failed to load ventas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfica de Reportes de Ventas'),
      ),
      body: FutureBuilder<List<Venta>>(
        future: futureVentas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hay datos disponibles"));
          }

          List<Venta> ventas = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                minimum: 0,
                interval: 10000,
                title: AxisTitle(text: 'Total Ventas'),
              ),
              title: ChartTitle(text: 'Ventas por Agente'),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries>[
                ColumnSeries<Venta, String>(
                  dataSource: ventas,
                  xValueMapper: (Venta venta, _) => venta.nombreAgente,
                  yValueMapper: (Venta venta, _) => venta.totalVentas,
                  name: 'Ventas',
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
