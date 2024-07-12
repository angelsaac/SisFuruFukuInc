class ReporteVenta {
  final int idReporte;
  final int idAgente;
  final String nombreAgente;
  final String descripcionArticulo;
  final DateTime fechaVenta;
  final double importeTotal;
  final String estatusVenta;
  final String estatusSupervision;

  ReporteVenta({
    required this.idReporte,
    required this.idAgente,
    required this.nombreAgente,
    required this.descripcionArticulo,
    required this.fechaVenta,
    required this.importeTotal,
    required this.estatusVenta,
    required this.estatusSupervision,
  });

  factory ReporteVenta.fromJson(Map<String, dynamic> json) {
    return ReporteVenta(
      idReporte: json['idReporte'] ?? 0,
      idAgente: json['idAgente'] ?? 0,
      nombreAgente: json['nombreAgente'] ?? '',
      descripcionArticulo: json['descripcionArticulo'] ?? '',
      fechaVenta: DateTime.parse(json['fechaVenta']),
      importeTotal: (json['importeTotal'] ?? 0).toDouble(),
      estatusVenta: json['estatusVenta'] ?? '',
      estatusSupervision: json['estatusSupervision'] ?? '',
    );
  }
}
