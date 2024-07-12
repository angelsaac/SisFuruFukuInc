﻿# FuruFukuInc
# README 
Instrucciones para Desplegar y Ejecutar el Proyecto de Furui Fuku Inc
Este proyecto consta de tres partes principales: Backend (API en .NET Core), Frontend Web (Angular) y una Aplicación Móvil (Flutter). A continuación, se detallan los pasos para configurar y ejecutar cada componente en un entorno de desarrollo local. Asegúrese de tener instaladas las herramientas necesarias para cada tecnología.

Contenidos
Pre-requisitos
Configuración y Ejecución del Backend (API en .NET Core)
Configuración y Ejecución del Frontend Web (Angular)
Configuración y Ejecución de la Aplicación Móvil (Flutter)
Estructura del Proyecto
Información de Contacto

Pre-requisitos
Backend (API en .NET Core)

.NET SDK (Versión 5.0 o superior)
Visual Studio 2022
SQL Server
Frontend Web (Angular)

Node.js (Versión 14 o superior)
Angular CLI (Versión 15)
Aplicación Móvil (Flutter)

Flutter SDK
Android Studio o Visual Studio Code con extension de flutter

Tomar el archivo de creacionTablas.SQL y ejecutar en SQL SERVER

Clonar el proyecto en carpeta de preferencia https://github.com/angelsaac/SisFuruFukuInc.git
Tomar la carpeta backend y ejecutar en Visual Studio para encender las apis


Para configurar el Angular tomar la carpeta de FrontEnd y ejecutarla con ng serve previamente instalado angular en base a la documentacion que se compartio por correo
Correc npm install
ng serve para inicializarla 

Para Flutter tomar la carpeta Movil y abrirla en Editor de preferencia, una vez instalado el SDK de flutter, correr flutter doctor y alinear los requerimientos
Una vez alineado abrir Visual Studio Code y agregar la extension de flutter y ejecutar 
flutter pub get para generar las depencias y posteriormente flutter run para ejecutar el proyecto
 

Es multiplataforma puede ser WINDOWS, WEB O Android Movil, para android tendra que configurar un emulador con Android Studio y seleccionar el emulador antes de ejecutar el proyecto

nombre-repositorio/
├── backend/        # Proyecto de API en .NET Core
├── frontend/       # Proyecto de Angular
└── mobile/         # Proyecto de Flutter


Información de Contacto
Para cualquier consulta, contactar a:

Nombre del Desarrollador: Angel Isaac Dominguez Gutierrez
Email:  angeldg.developer@gmail.com
Teléfono: 66-74-82-36-02
