using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

[Route("api/[controller]")]
[ApiController]
public class AgentesController : ControllerBase
{
  private readonly UserManager<IdentityUser> _userManager;
  private readonly SignInManager<IdentityUser> _signInManager;
  private readonly ApplicationDbContext _context;
  private readonly IConfiguration _configuration;

  public AgentesController(UserManager<IdentityUser> userManager, SignInManager<IdentityUser> signInManager, ApplicationDbContext context, IConfiguration configuration)
  {
    _userManager = userManager;
    _signInManager = signInManager;
    _context = context;
    _configuration = configuration;
  }

  [HttpGet]
  public async Task<ActionResult<IEnumerable<Agente>>> GetAgentes()
  {
    return await _context.Agentes.ToListAsync();
  }

  [HttpGet("{id}")]
  public async Task<ActionResult<Agente>> GetAgente(int id)
  {
    var agente = await _context.Agentes.FindAsync(id);
    if (agente == null)
    {
      return NotFound();
    }
    return agente;
  }

  [HttpPost]
  public async Task<ActionResult> PostAgente(Agente agente)
  {
    // Crear usuario en AspNetUsers
    var user = new IdentityUser
    {
      UserName = agente.NombreUsuario,
      Email = agente.NombreUsuario  // Si tienes el email en el modelo de Agente, úsalo aquí
    };

    var result = await _userManager.CreateAsync(user, agente.Password);
    if (!result.Succeeded)
    {
      return BadRequest(result.Errors);
    }

    // Eliminar la contraseña del modelo Agente antes de guardarlo en la base de datos
    agente.Password = null;

    _context.Agentes.Add(agente);
    await _context.SaveChangesAsync();

    return CreatedAtAction("GetAgente", new { id = agente.ID_Agente }, agente);
  }

  [HttpPut("{id}")]
  public async Task<IActionResult> PutAgente(int id, Agente agente)
  {
    if (id != agente.ID_Agente)
    {
      return BadRequest("No coincide el ID.");
    }

    var existingAgente = await _context.Agentes.FindAsync(id);
    if (existingAgente == null)
    {
      return NotFound();
    }

    var user = await _userManager.FindByNameAsync(existingAgente.NombreUsuario);
    if (user == null)
    {
      return NotFound();
    }

    // Update IdentityUser
    user.UserName = agente.NombreUsuario;
    user.Email = agente.NombreUsuario;  // Si tienes el email en el modelo de Agente, úsalo aquí
    var updateResult = await _userManager.UpdateAsync(user);
    if (!updateResult.Succeeded)
    {
      return BadRequest(updateResult.Errors);
    }

    // Update Password if provided
    if (!string.IsNullOrEmpty(agente.Password))
    {
      var token = await _userManager.GeneratePasswordResetTokenAsync(user);
      var passwordResult = await _userManager.ResetPasswordAsync(user, token, agente.Password);
      if (!passwordResult.Succeeded)
      {
        return BadRequest(passwordResult.Errors);
      }
    }

    // Update Agente
    existingAgente.Nombre = agente.Nombre;
    existingAgente.Edad = agente.Edad;
    existingAgente.FechaIngreso = agente.FechaIngreso;
    existingAgente.AcumuladoVentas = agente.AcumuladoVentas;
    existingAgente.Puesto = agente.Puesto;
    existingAgente.NombreUsuario = agente.NombreUsuario;

    _context.Entry(existingAgente).State = EntityState.Modified;

    try
    {
      await _context.SaveChangesAsync();
    }
    catch (DbUpdateConcurrencyException)
    {
      if (!AgenteExists(id))
      {
        return NotFound();
      }
      else
      {
        throw;
      }
    }

    return NoContent();
  }

  [HttpDelete("{id}")]
  public async Task<IActionResult> DeleteAgente(int id)
  {
    var agente = await _context.Agentes.FindAsync(id);
    if (agente == null)
    {
      return NotFound();
    }

    var user = await _userManager.FindByNameAsync(agente.NombreUsuario);
    if (user != null)
    {
      var result = await _userManager.DeleteAsync(user);
      if (!result.Succeeded)
      {
        return BadRequest(result.Errors);
      }
    }

    _context.Agentes.Remove(agente);
    await _context.SaveChangesAsync();

    return NoContent();
  }

  private bool AgenteExists(int id)
  {
    return _context.Agentes.Any(e => e.ID_Agente == id);
  }
}
