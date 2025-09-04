# Sistema de Gestión de Laboratorios - MVP

SGLAB/
 ├── app/
 │   ├── Controllers/
 │   │    ├── AuthController.php
 │   │    └── UsuarioController.php
 │   ├── Models/
 │   │    ├── Personas.php
 │   │    ├── Usuarios.php
 │   │    └── Perfiles.php
 │   ├── Database/
 │   │    └── ConexionDB.php
 │   └── Factories/
 │        └── UsuarioFactory.php
 ├── public/
 │   ├── index.php
 │   ├── login.php
 │   └── register.php
 ├── .env.example
 ├── composer.json


Sistema para registro y gestión del estado de equipos en laboratorios informáticos, con módulos para estudiantes y administradores.

## 📌 Requerimientos Clave

### 🎯 Requerimientos Funcionales (RF)

1. **Registro Estudiantil**
   - Formulario para reportar estado de equipos (N/S, Nombre, Estado, Descripción)
   - Validación de C.I. (8 dígitos)
   - Registro automático de fecha/hora

2. **Panel Administrativo**
   - Visualización de registros filtrables por fecha/estado
   - Modificación de estados
   - Autenticación segura

3. **Diagnóstico de Equipos**
   - Script PowerShell para recolectar datos técnicos
   - Tarea programada para diagnóstico automático

### 🛡️ Requerimientos No Funcionales (RNF)

1. **Usabilidad**
   - Interfaz intuitiva (<3 clics para acciones principales)
   - Tiempo respuesta <2s

2. **Seguridad**
   - Autenticación con bcrypt
   - Protección contra inyección SQL
   - Validación cliente/servidor

3. **Compatibilidad**
   - Soporte para Chrome, Edge, Firefox
   - Diseño responsive

## 📅 Planificación por Sprints (4 semanas)

### 🚀 Sprint 1: Infraestructura y Diseño

**Entregables:**
- [ ] Diagrama ER y script SQL (`database/schema.sql`)
- [ ] Mockups de interfaces (PDF/FIGMA en `docs/design`)
- [ ] Configuración inicial servidor (`docs/setup.md`)
- [ ] Script base PowerShell (`scripts/diagnostico_base.ps1`)

**Tareas Técnicas:**
1. Diseñar modelo de base de datos
2. Crear prototipos de UI
3. Configurar ambiente LAMP
4. Desarrollar script PS para datos básicos

### 🛠️ Sprint 2: Núcleo del Sistema

**Entregables:**
- [ ] Backend PHP con endpoints (`api/registros.php`)
- [ ] Sistema de autenticación (`lib/auth.php`)
- [ ] Formulario web funcional (`public/formulario.html`)
- [ ] Script PS completo (`scripts/diagnostico_completo.ps1`)

**Tareas Técnicas:**
1. Implementar CRUD para registros
2. Desarrollar módulo de login
3. Crear formulario con validación JS
4. Ampliar script PS con todas las métricas

### ✨ Sprint 3: Integración y Funcionalidades Avanzadas

**Entregables:**
- [ ] Panel administrativo (`admin/index.html`)
- [ ] API para filtros (`api/filtros.php`)
- [ ] Tarea programada PS (`scripts/tarea_programada.ps1`)
- [ ] Documentación API (`docs/api.md`)

**Tareas Técnicas:**
1. Desarrollar interfaz de administración
2. Implementar filtros complejos
3. Configurar tarea programada Windows
4. Documentar endpoints API

### 🚢 Sprint 4: Pruebas y Despliegue

**Entregables:**
- [ ] Suite de pruebas (`tests/`)
- [ ] Script despliegue (`deploy.sh`)
- [ ] Manual de usuario (`docs/manual_usuario.md`)


## 🛠️ Instalación

1. **Requisitos:**
   - Servidor Linux (Ubuntu 22.04+)
   - Apache 2.4, PHP 8.2+, MySQL 8.0+
   - PowerShell 5.1+ (para scripts)

2. **Configuración Inicial:**
```bash
# Clonar repositorio
git clone https://github.com/utu-iti/gestion-laboratorios.git
cd gestion-laboratorios

# Configurar base de datos
mysql -u root -p < database/schema.sql
#Previamente exportar el modelo del proyecto con
mysqldump -u root -p > database/schema.sql

# Permisos
chmod +x scripts/registros.ps1
chmod +x deploy.sh

📂 Estructura de Directorios
/sglab
├── api/               # Endpoints PHP
│   ├── /Core
│   ├── /Controllers
│   ├── /Models
│   ├── /Views
│   └── /Services
├── /config
│       └── /prod
│       └── /test
│       └── /dev               
├── database/          # Esquema SQL
├── docs/              # Documentación
├── public/            # Archivos accesibles web
│   ├── css/
│   ├── js/
│   └── img/   
│   └── index.html
├── scripts/           # Scripts PowerShell
│   └── registro.ps1
├── tests/             # Pruebas automatizadas
└── vendor/            # Liberias necesarias por composer
└── README.md          # Este archivo



├── /public
│   └── index.html
│   └── /asset
│             └── /img   
│             └── /css
│             └── /js                    


```
