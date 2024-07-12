import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { HomeSupervisorComponent } from './home-supervisor/home-supervisor.component';
import { ConsultaVentasComponent } from './consulta-ventas/consulta-ventas.component';
import { RegistroUsuarioComponent } from './registro-usuario/registro-usuario.component';
import { HistorialVentasComponent } from './historial-ventas/historial-ventas.component';
import { EditarVentaComponent } from './editar-venta/editar-venta.component';
import { RegistroVentaComponent } from './registro-venta/registro-venta.component'; 
import { EditarVentaVendedorComponent } from './editar-venta-vendedor/editar-venta-vendedor.component';
import { AuthGuard } from './auth.guard';

const routes: Routes = [
  { path: '', component: LoginComponent },
  { path: 'home-supervisor', component: HomeSupervisorComponent, canActivate: [AuthGuard], data: { role: 'Supervisor' } },
  { path: 'consulta-ventas', component: ConsultaVentasComponent, canActivate: [AuthGuard], data: { role: 'Supervisor' } },
  { path: 'historial-ventas', component: HistorialVentasComponent, canActivate: [AuthGuard], data: { role: 'Vendedor' } },
  { path: 'registro-usuario', component: RegistroUsuarioComponent, canActivate: [AuthGuard], data: { role: 'Supervisor' } },
  { path: 'editar-venta/:id', component: EditarVentaComponent, canActivate: [AuthGuard], data: { role: 'Supervisor' } },
  { path: 'registro-venta', component: RegistroVentaComponent, canActivate: [AuthGuard], data: { role: 'Vendedor' } },
  { path: 'editar-venta-vendedor/:id', component: EditarVentaVendedorComponent, canActivate: [AuthGuard], data: { role: 'Vendedor' } }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
