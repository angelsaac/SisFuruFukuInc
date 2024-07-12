using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

[Route("api/[controller]")]
[ApiController]
[Authorize]
public class ReportesVentasController : ControllerBase
{
  private readonly ApplicationDbContext _context;

  public ReportesVentasController(ApplicationDbContext context)
  {
    _context = context;
  }

  [HttpGet]
  public async Task<ActionResult<IEnumerable<ReporteVentaViewModel>>> GetReportesVentas()
  {
    var reportes = await _context.ReportesVentas
      .Join(_context.Agentes,
            rv => rv.ID_Agente,
            a => a.ID_Agente,
            (rv, a) => new ReporteVentaViewModel
            {
              ID_Reporte = rv.ID_Reporte,
              ID_Agente = rv.ID_Agente,
              NombreAgente = a.Nombre,
              DescripcionArticulo = rv.DescripcionArticulo,
              FechaVenta = rv.FechaVenta,
              ImporteTotal = rv.ImporteTotal,
              EstatusVenta = rv.EstatusVenta,
              EstatusSupervision = rv.EstatusSupervision
            })
      .ToListAsync();

    return reportes;
  }

  [HttpGet("{id}")]
  public async Task<ActionResult<ReporteVenta>> GetReporteVenta(int id)
  {
    var reporteVenta = await _context.ReportesVentas.FindAsync(id);
    if (reporteVenta == null)
    {
      return NotFound();
    }
    return reporteVenta;
  }

  [HttpPost]
  public async Task<ActionResult<ReporteVenta>> PostReporteVenta(ReporteVenta reporteVenta)
  {
    _context.ReportesVentas.Add(reporteVenta);
    await _context.SaveChangesAsync();

    await ActualizarAcumuladoVentas(reporteVenta.ID_Agente);

    return CreatedAtAction(nameof(GetReporteVenta), new { id = reporteVenta.ID_Reporte }, reporteVenta);
  }

  [HttpPut("{id}")]
  public async Task<IActionResult> PutReporteVenta(int id, ReporteVenta reporteVenta)
  {
    if (id != reporteVenta.ID_Reporte)
    {
      return BadRequest();
    }

    _context.Entry(reporteVenta).State = EntityState.Modified;

    try
    {
      await _context.SaveChangesAsync();
    }
    catch (DbUpdateConcurrencyException)
    {
      if (!ReporteVentaExists(id))
      {
        return NotFound();
      }
      else
      {
        throw;
      }
    }

    await ActualizarAcumuladoVentas(reporteVenta.ID_Agente);

    return NoContent();
  }

  [HttpDelete("{id}")]
  public async Task<IActionResult> DeleteReporteVenta(int id)
  {
    var reporteVenta = await _context.ReportesVentas.FindAsync(id);
    if (reporteVenta == null)
    {
      return NotFound();
    }

    _context.ReportesVentas.Remove(reporteVenta);
    await _context.SaveChangesAsync();

    await ActualizarAcumuladoVentas(reporteVenta.ID_Agente);

    return NoContent();
  }

  private async Task ActualizarAcumuladoVentas(int idAgente)
  {
    var agente = await _context.Agentes.FirstOrDefaultAsync(a => a.ID_Agente == idAgente);
    if (agente != null)
    {
      agente.AcumuladoVentas = await _context.ReportesVentas
          .Where(rv => rv.ID_Agente == idAgente)
          .SumAsync(rv => (decimal?)rv.ImporteTotal) ?? 0;
      await _context.SaveChangesAsync();
    }
  }

  private bool ReporteVentaExists(int id)
  {
    return _context.ReportesVentas.Any(e => e.ID_Reporte == id);
  }
}
