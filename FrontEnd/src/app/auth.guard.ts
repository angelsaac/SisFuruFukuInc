import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, UrlTree, Router } from '@angular/router';
import { Observable } from 'rxjs';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  constructor(private authService: AuthService, private router: Router) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): boolean | UrlTree {
    const token = localStorage.getItem('token');
    if (token) {
      const role = this.authService.getRole();
      const expectedRole = route.data['role'];
      if (role === expectedRole) {
        return true;
      } else {
        if (role === 'Supervisor') {
          alert("No tienes permiso para acceder")
          return this.router.createUrlTree(['/home-supervisor']);
        } else if (role === 'Vendedor') {
          alert("No tienes permiso para acceder")
          return this.router.createUrlTree(['/historial-ventas']);
        } else {
          return this.router.createUrlTree(['/login']);
        }
      }
    }
    alert("No tienes permiso para acceder")
    this.router.navigate(['/login']);
    return false
  }
}
