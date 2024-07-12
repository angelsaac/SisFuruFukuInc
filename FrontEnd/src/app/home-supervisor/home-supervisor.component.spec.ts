import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HomeSupervisorComponent } from './home-supervisor.component';

describe('HomeSupervisorComponent', () => {
  let component: HomeSupervisorComponent;
  let fixture: ComponentFixture<HomeSupervisorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ HomeSupervisorComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(HomeSupervisorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
