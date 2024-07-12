import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = 'https://localhost:7128/api/Auth/login';

  constructor(private http: HttpClient) { }

  login(username: string, password: string): Observable<any> {
    return this.http.post(this.apiUrl, { UserName: username, Password: password });
  }

  logout(): void {
    localStorage.removeItem('token');
    localStorage.removeItem('puesto');
    localStorage.removeItem('idAgente');
  }

  getRole(): string | null {
    return localStorage.getItem('puesto');
  }
}
