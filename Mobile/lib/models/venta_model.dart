class Venta {
  final String nombreAgente;
  final double totalVentas;

  Venta({
    required this.nombreAgente,
    required this.totalVentas,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      nombreAgente: json['nombreAgente'],
      totalVentas: json['totalVentas'].toDouble(),
    );
  }
}
