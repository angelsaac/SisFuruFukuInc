using System.ComponentModel.DataAnnotations;

public class ReporteVenta
{
  [Key]
  public int ID_Reporte { get; set; }
  public int ID_Agente { get; set; } // Asegúrate de que el tipo sea entero
  public string DescripcionArticulo { get; set; }
  public DateTime FechaVenta { get; set; }
  public decimal ImporteTotal { get; set; }
  public string EstatusVenta { get; set; }
  public string EstatusSupervision { get; set; }
}
