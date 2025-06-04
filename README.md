# STLAB
Soporte Tècnico de Laboratorios

---

# Detalle de Tareas por Sprint (Versión Ampliada)

## Sprint 1 - Infraestructura y Diseño

### Diagrama ER y SQL
1. Definir entidades principales (Registros, Equipos, Usuarios)
2. Crear relaciones y cardinalidades
3. Escribir script SQL con:
   - Creación de tablas
   - Índices optimizados
   - Usuario admin inicial

### Mockups de Interfaces
1. Diseñar en Figma/Balsamiq:
   - Formulario de registro estudiantil
   - Vista de lista administrativa
   - Pantalla de login
2. Exportar como PDF a `docs/design/`

### Configuración Servidor
1. Documentar requisitos mínimos
2. Crear script de instalación LAMP
3. Configurar permisos básicos

### Script PowerShell Base
1. Obtener datos básicos:
   - Hostname
   - IP
   - Sistema operativo
2. Guardar salida en JSON

---

## Sprint 2 - Núcleo del Sistema

### Backend PHP
1. Implementar endpoints REST:
   - POST /registros (crear)
   - GET /registros (listar)
   - PUT /registros/{id} (actualizar)
2. Validar todos los inputs

### Autenticación
1. Sistema login/logout
2. Protección de rutas admin
3. Manejo de sesiones

### Formulario Web
1. HTML5 semántico
2. Validación con JavaScript
3. Estilos CSS responsivos

### Script PS Completo
1. Ampliar con:
   - CPU, RAM, Disco
   - Conectividad de red
   - Software instalado
2. Formatear salida profesional

---

## Sprint 3 - Integración

### Panel Admin
1. Tabla con:
   - Ordenamiento por columnas
   - Filtros combinados
   - Paginación
2. Gráficos resumen (Chart.js)

### API Filtros
1. Implementar filtrado por:
   - Fechas
   - Estado equipo
   - C.I. estudiante
2. Optimizar consultas SQL

### Tarea Programada
1. Configurar ejecución diaria
2. Enviar reportes por email
3. Logging de ejecuciones

---

## Sprint 4 - Despliegue

### Pruebas Automatizadas
1. Pruebas PHPUnit para:
   - Validaciones
   - Autenticación
   - Consultas DB
2. Pruebas E2E con Cypress

### Script Despliegue
1. Automatizar:
   - Copia de archivos
   - Migraciones DB
   - Configuración
2. Modo rollback

### Documentación Final
1. Manual usuario (PDF)
2. Wiki técnica (Markdown)
3. Video demostración (5 min)

---

Este plan detallado permite:
✅ Trabajo en paralelo por especialidades  
✅ Entregas semanales claras  
✅ Criterios de aceptación definidos  
✅ Seguimiento del progreso  

¿Necesitas que profundice en algún área específica del plan?
