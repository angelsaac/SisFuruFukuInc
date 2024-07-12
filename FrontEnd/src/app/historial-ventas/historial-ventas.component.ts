import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-historial-ventas',
  templateUrl: './historial-ventas.component.html',
  styleUrls: ['./historial-ventas.component.css']
})
export class HistorialVentasComponent implements OnInit {
  ventas: any[] = [];
  isLoading = true;

  constructor(private http: HttpClient, private router: Router) {}

  ngOnInit(): void {
    this.fetchVentas();
  }

  fetchVentas(): void {
    const token = localStorage.getItem('token');
    const idAgente = localStorage.getItem('idAgente');
    if (token && idAgente) {
      const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
      this.http.get<any[]>('https://localhost:7128/api/ReportesVentas', { headers })
        .subscribe(
          response => {
            this.ventas = response.filter(venta => venta.iD_Agente == idAgente);
            this.isLoading = false;
          },
          error => {
            console.error('Error al obtener las ventas', error);
            this.isLoading = false;
          }
        );
    }
  }

  logout(): void {
    localStorage.removeItem('token');
    localStorage.removeItem('puesto');
    localStorage.removeItem('idAgente');
    this.router.navigate(['/']);
  }

  deleteVenta(idReporte: number): void {
    const token = localStorage.getItem('token');
    if (token) {
      const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
      this.http.delete(`https://localhost:7128/api/ReportesVentas/${idReporte}`, { headers })
        .subscribe(
          () => {
            alert('Venta eliminada exitosamente');
            this.fetchVentas(); 
          },
          error => {
            console.error('Error al eliminar la venta', error);
          }
        );
    }
  }

  editVenta(venta: any): void {
    this.router.navigate(['/editar-venta-vendedor', venta.iD_Reporte]);
  }

  addVenta(): void {
    this.router.navigate(['/registro-venta']);
  }
}
