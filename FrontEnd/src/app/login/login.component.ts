import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../auth.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  username: string = '';
  password: string = '';

  constructor(private authService: AuthService, private router: Router) { }

  login(): void {
    this.authService.login(this.username, this.password).subscribe(response => {
      const { token, puesto, idAgente } = response;
      localStorage.setItem('token', token);
      localStorage.setItem('puesto', puesto);
      localStorage.setItem('idAgente', idAgente);

      if (puesto === 'Supervisor') {
        this.router.navigate(['/home-supervisor']);
      } else if (puesto === 'Vendedor') {
        this.router.navigate(['/historial-ventas']);
      }
    }, error => {
      console.error('Fallo al loguearse', error);
      alert('Fallo al loguearse');
    });
  }
}
