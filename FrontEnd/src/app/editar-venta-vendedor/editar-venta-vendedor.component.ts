import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-editar-venta-vendedor',
  templateUrl: './editar-venta-vendedor.component.html',
  styleUrls: ['./editar-venta-vendedor.component.css']
})
export class EditarVentaVendedorComponent implements OnInit {
  editForm: FormGroup;
  ventaId: number = 0; 
  isLoading = true;

  goBack(): void {
    this.router.navigate(['/historial-ventas']);
  }

  constructor(
    private route: ActivatedRoute,
    private http: HttpClient,
    private fb: FormBuilder,
    private router: Router
  ) {
    this.editForm = this.fb.group({
      descripcionArticulo: ['', Validators.required],
      fechaVenta: ['', Validators.required],
      importeTotal: ['', [Validators.required, Validators.pattern(/^[0-9]+(\.[0-9]{1,2})?$/)]],
      estatusVenta: ['', Validators.required]
    });
  }

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id !== null) {
      this.ventaId = +id;
      this.fetchVenta(this.ventaId);
    }
  }

  fetchVenta(id: number): void {
    const token = localStorage.getItem('token');
    if (token) {
      const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
      this.http.get<any>(`https://localhost:7128/api/ReportesVentas/${id}`, { headers })
        .subscribe(
          response => {
            this.editForm.patchValue(response);
            this.isLoading = false;
          },
          error => {
            console.error('Error al obtener la venta', error);
            this.isLoading = false;
          }
        );
    }
  }

  onSubmit(): void {
    if (this.editForm.valid) {
      const token = localStorage.getItem('token');
      if (token) {
        const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
        const updatedVenta = {
          ...this.editForm.value,
          iD_Agente: localStorage.getItem('idAgente'),
          iD_Reporte: this.ventaId,
          estatusSupervision: 'En Espera de respuesta'
        };
        this.http.put(`https://localhost:7128/api/ReportesVentas/${this.ventaId}`, updatedVenta, { headers })
          .subscribe(
            () => {
              alert('Venta actualizada exitosamente');
              this.router.navigate(['/historial-ventas']);
            },
            error => {
              console.error('Error al actualizar la venta', error);
            }
          );
      }
    }
  }
}
