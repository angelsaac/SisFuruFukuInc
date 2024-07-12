import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-registro-venta',
  templateUrl: './registro-venta.component.html',
  styleUrls: ['./registro-venta.component.css']
})
export class RegistroVentaComponent {
  registroForm: FormGroup;
  isLoading = false;
  
  goBack(): void {
    this.router.navigate(['/historial-ventas']);
  }


  constructor(private fb: FormBuilder, private http: HttpClient, private router: Router) {
    this.registroForm = this.fb.group({
      descripcionArticulo: ['', Validators.required],
      fechaVenta: ['', Validators.required],
      importeTotal: ['', [Validators.required, Validators.pattern(/^\d+(\.\d{1,2})?$/)]],
      estatusVenta: ['', Validators.required]
    });
  }

  onSubmit(): void {
    if (this.registroForm.valid) {
      this.isLoading = true;
      const token = localStorage.getItem('token');
      const idAgente = localStorage.getItem('idAgente');
      if (token && idAgente) {
        const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
        const venta = {
          ...this.registroForm.value,
          iD_Agente: idAgente,
          estatusSupervision: 'En Espera de respuesta'
        };

        this.http.post('https://localhost:7128/api/ReportesVentas', venta, { headers })
          .subscribe(
            () => {
              alert('Venta registrada exitosamente');
              this.router.navigate(['/historial-ventas']);
            },
            error => {
              console.error('Error al registrar la venta', error);
              this.isLoading = false;
            }
          );
      }
    }
  }
}
