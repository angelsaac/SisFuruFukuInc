import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-editar-venta',
  templateUrl: './editar-venta.component.html',
  styleUrls: ['./editar-venta.component.css']
})
export class EditarVentaComponent implements OnInit {
  venta: any;
  editarForm: FormGroup;
  estatusOptions = ['Seleccione una opción', 'Aceptada', 'Rechazada'];

  constructor(
    private route: ActivatedRoute,
    private http: HttpClient,
    private fb: FormBuilder,
    private router: Router
  ) {
    this.editarForm = this.fb.group({
      estatusSupervision: ['Seleccione una opción', Validators.required]
    });
  }

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id !== null) {
      this.fetchVenta(id);
    }
  }

  fetchVenta(id: string): void {
    const token = localStorage.getItem('token');
    if (token) {
      const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
      this.http.get<any>(`https://localhost:7128/api/ReportesVentas/${id}`, { headers })
        .subscribe(
          response => {
            this.venta = response;
            this.editarForm.patchValue({
              estatusSupervision: this.venta.estatusSupervision
            });
          },
          error => {
            console.error('Error al obtener la venta', error);
          }
        );
    }
  }

  onSubmit(): void {
    if (this.editarForm.valid) {
      const token = localStorage.getItem('token');
      const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
      const updatedVenta = { ...this.venta, ...this.editarForm.value };

      this.http.put(`https://localhost:7128/api/ReportesVentas/${this.venta.iD_Reporte}`, updatedVenta, { headers })
        .subscribe(
          () => {
            alert('Estatus actualizado exitosamente');
            this.router.navigate(['/consulta-ventas']);
          },
          error => {
            console.error('Error al actualizar la venta', error);
          }
        );
    }
  }

  goBack(): void {
    this.router.navigate(['/consulta-ventas']);
  }
}
