import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './login/login.component';
import { HistorialVentasComponent } from './historial-ventas/historial-ventas.component';
import { HomeSupervisorComponent } from './home-supervisor/home-supervisor.component';
import { RegistroUsuarioComponent } from './registro-usuario/registro-usuario.component';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AuthService } from './auth.service';
import { AuthGuard } from './auth.guard';
import { EditarVentaComponent } from './editar-venta/editar-venta.component';
import { ConsultaVentasComponent } from './consulta-ventas/consulta-ventas.component';
import { RegistroVentaComponent } from './registro-venta/registro-venta.component';
import { EditarVentaVendedorComponent } from './editar-venta-vendedor/editar-venta-vendedor.component';


@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    HistorialVentasComponent,
    HomeSupervisorComponent,
    RegistroUsuarioComponent,
    EditarVentaComponent,
    ConsultaVentasComponent,
    RegistroVentaComponent,
    EditarVentaVendedorComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    CommonModule,
  ],
  providers: [AuthService, AuthGuard],
  bootstrap: [AppComponent]
})
export class AppModule { }
