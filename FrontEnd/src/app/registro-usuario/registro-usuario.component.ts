import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-registro-usuario',
  templateUrl: './registro-usuario.component.html',
  styleUrls: ['./registro-usuario.component.css']
})
export class RegistroUsuarioComponent implements OnInit {
  registroForm: FormGroup;

  constructor(
    private fb: FormBuilder,
    private http: HttpClient,
    private router: Router
  ) {
    this.registroForm = this.fb.group({
      nombreUsuario: ['', [Validators.required, Validators.pattern(/^\S*$/)]],
      nombre: ['', [Validators.required, Validators.pattern(/^[^0-9]*$/)]],
      edad: ['', [Validators.required, Validators.pattern(/^\d+$/)]],
      fechaIngreso: ['', Validators.required],
      puesto: ['Vendedor', Validators.required],
      password: ['', [Validators.required, Validators.minLength(6)]]
    });
  }
  
  goBack(): void {
    this.router.navigate(['/home-supervisor']);
  }

  ngOnInit(): void {}

  onSubmit(): void {
    if (this.registroForm.valid) {
      const token = localStorage.getItem('token');
      const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
      const usuario = this.registroForm.value;
      usuario.acumuladoVentas = 0;

      this.http.post('https://localhost:7128/api/Agentes', usuario, { headers }).subscribe(
        response => {
          alert('Usuario registrado exitosamente');
          this.router.navigate(['/home-supervisor']);
        },
        error => {
          console.error('Error al registrar usuario', error);
          alert('Error al registrar usuario');
        }
      );
    }
  }

  get nombreUsuario() {
    return this.registroForm.get('nombreUsuario');
  }

  get nombre() {
    return this.registroForm.get('nombre');
  }

  get edad() {
    return this.registroForm.get('edad');
  }

  get fechaIngreso() {
    return this.registroForm.get('fechaIngreso');
  }

  get puesto() {
    return this.registroForm.get('puesto');
  }

  get password() {
    return this.registroForm.get('password');
  }
}
