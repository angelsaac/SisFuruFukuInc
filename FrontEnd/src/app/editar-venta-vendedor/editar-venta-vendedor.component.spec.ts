import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditarVentaVendedorComponent } from './editar-venta-vendedor.component';

describe('EditarVentaVendedorComponent', () => {
  let component: EditarVentaVendedorComponent;
  let fixture: ComponentFixture<EditarVentaVendedorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditarVentaVendedorComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EditarVentaVendedorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
