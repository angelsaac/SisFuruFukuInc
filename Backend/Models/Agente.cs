using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

public class Agente
{
  [Key]
  [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
  public int ID_Agente { get; set; }
  public string NombreUsuario { get; set; }
  public string Nombre { get; set; }
  public int Edad { get; set; }
  public DateTime FechaIngreso { get; set; }
  public decimal AcumuladoVentas { get; set; }
  public string Puesto { get; set; }

  [NotMapped]
  public string Password { get; set; }
}
