public class ReporteVentaViewModel
{
  public int ID_Reporte { get; set; }
  public int ID_Agente { get; set; }
  public string NombreAgente { get; set; }
  public string DescripcionArticulo { get; set; }
  public DateTime FechaVenta { get; set; }
  public decimal ImporteTotal { get; set; }
  public string EstatusVenta { get; set; }
  public string EstatusSupervision { get; set; }
}
