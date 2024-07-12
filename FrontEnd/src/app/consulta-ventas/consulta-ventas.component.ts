import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { jsPDF } from 'jspdf';
import html2canvas from 'html2canvas';

@Component({
  selector: 'app-consulta-ventas',
  templateUrl: './consulta-ventas.component.html',
  styleUrls: ['./consulta-ventas.component.css']
})
export class ConsultaVentasComponent implements OnInit {
  ventas: any[] = [];
  isLoading = true;

  constructor(private http: HttpClient, private router: Router) {}

  ngOnInit(): void {
    this.fetchVentas();
  }

  fetchVentas(): void {
    const token = localStorage.getItem('token');
    if (token) {
      const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
      this.http.get<any[]>('https://localhost:7128/api/ReportesVentas', { headers })
        .subscribe(
          response => {
            this.ventas = response;
            this.isLoading = false;
          },
          error => {
            console.error('Error al obtener las ventas', error);
            this.isLoading = false;
          }
        );
    }
  }

  navigateToEdit(venta: any): void {
    this.router.navigate(['/editar-venta', venta.iD_Reporte]);
  }

  goBack(): void {
    this.router.navigate(['/home-supervisor']);
  }

  downloadPDF(): void {
    const DATA = document.getElementById('ventasTable');
    if (DATA) {
      const editButtons = Array.from(DATA.getElementsByClassName('btn-edit'));
      editButtons.forEach((button: any) => button.style.display = 'none');

      html2canvas(DATA).then(canvas => {
        const fileWidth = 208;
        const fileHeight = canvas.height * fileWidth / canvas.width;
        const FILEURI = canvas.toDataURL('image/png');
        const PDF = new jsPDF('p', 'mm', 'a4');
        const position = 20;
        PDF.text('Reporte de Ventas', 105, 10, { align: 'center' });
        PDF.addImage(FILEURI, 'PNG', 0, position, fileWidth, fileHeight);
        PDF.save('ventas-reporte.pdf');

        editButtons.forEach((button: any) => button.style.display = 'block');
      });
    }
  }
}
