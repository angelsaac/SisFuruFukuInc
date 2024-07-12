using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

[Route("api/[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
  private readonly UserManager<IdentityUser> _userManager;
  private readonly SignInManager<IdentityUser> _signInManager;
  private readonly ApplicationDbContext _context;
  private readonly IConfiguration _configuration;

  public AuthController(UserManager<IdentityUser> userManager, SignInManager<IdentityUser> signInManager, ApplicationDbContext context, IConfiguration configuration)
  {
    _userManager = userManager;
    _signInManager = signInManager;
    _context = context;
    _configuration = configuration;
  }

  [HttpPost("login")]
  public async Task<IActionResult> Login([FromBody] LoginModel model)
  {
    var result = await _signInManager.PasswordSignInAsync(model.UserName, model.Password, false, false);
    if (result.Succeeded)
    {
      var user = await _userManager.FindByNameAsync(model.UserName);
      var agente = await _context.Agentes.FirstOrDefaultAsync(a => a.NombreUsuario == model.UserName);
      if (agente == null)
      {
        return Unauthorized();
      }
      var token = GenerateJwtToken(user);
      return Ok(new { token, puesto = agente.Puesto, idAgente = agente.ID_Agente });
    }

    return Unauthorized();
  }

  private string GenerateJwtToken(IdentityUser user)
  {
    var jwtSettings = _configuration.GetSection("JwtSettings");
    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings["Key"]));
    var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

    var claims = new[]
    {
      new Claim(JwtRegisteredClaimNames.Sub, user.UserName),
      new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
      new Claim(ClaimTypes.NameIdentifier, user.Id)
    };

    var token = new JwtSecurityToken(
        issuer: jwtSettings["Issuer"],
        audience: jwtSettings["Audience"],
        claims: claims,
        expires: DateTime.Now.AddMinutes(30),
        signingCredentials: creds
    );

    return new JwtSecurityTokenHandler().WriteToken(token);
  }
}

public class LoginModel
{
  public string UserName { get; set; }
  public string Password { get; set; }
}
