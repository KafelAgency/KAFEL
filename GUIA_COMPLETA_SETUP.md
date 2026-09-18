# 🚀 KAFEL - Guía Completa de Setup y Configuración

## 📋 Tabla de Contenidos
1. [Requisitos Previos](#requisitos-previos)
2. [Paso 1: Configurar Supabase](#paso-1-configurar-supabase)
3. [Paso 2: Desplegar los Dashboards](#paso-2-desplegar-los-dashboards)
4. [Paso 3: Verificar Funcionamiento](#paso-3-verificar-funcionamiento)
5. [Guía de Uso](#guía-de-uso)
6. [Estructura del Proyecto](#estructura-del-proyecto)
7. [FAQ y Troubleshooting](#faq-y-troubleshooting)

---

## 📌 Requisitos Previos

- Una cuenta en **Supabase** (gratis en https://supabase.com)
- Un navegador web moderno (Chrome, Firefox, Safari, Edge)
- Acceso a GitHub (opcional, para deployment)

---

## ✅ Paso 1: Configurar Supabase

### 1.1 Crear proyecto en Supabase
1. Ve a https://supabase.com
2. Inicia sesión o crea cuenta
3. Clic en "New Project"
4. Nombra el proyecto: `KAFEL`
5. Copia la **URL** y la **ANON KEY** (las necesitarás después)

### 1.2 Ejecutar el SQL en Supabase
1. En tu proyecto, ve a **SQL Editor** (lado izquierdo)
2. Haz clic en **"New Query"** (botón azul)
3. **Copia TODO** el contenido del archivo `supabase_schema_limpio.sql`
4. **Pégalo** en el SQL Editor
5. Haz clic en **"Run"** (botón verde arriba a la derecha)

### 1.3 Verificar que funcionó
Después de ejecutar, deberías ver estos 7 resultados:
```
table_name
───────────────────
clientes
comisiones
distribucion_venta
fondo_kafel
gastos
vendedores
ventas
```

✅ **Si ves estas 7 tablas, ¡está perfecto!**

### 1.4 Datos iniciales cargados automáticamente
El SQL incluye 4 usuarios de prueba:
- **Miguel** (Programador) - ID: 550e8400-e29b-41d4-a716-446655440000
- **Memo** (Vendedor) - ID: 550e8400-e29b-41d4-a716-446655440001
- **John** (Inversor) - ID: 550e8400-e29b-41d4-a716-446655440002
- **Isa** (Inversora) - ID: 550e8400-e29b-41d4-a716-446655440003

---

## 📱 Paso 2: Desplegar los Dashboards

Tienes 3 opciones:

### **Opción A: GitHub Pages (RECOMENDADO - Gratis y Automático)**

#### 2A.1 Subir archivos a GitHub
1. Ve a tu repositorio: https://github.com/KafelAgency/KAFEL
2. Carga los siguientes archivos en la rama `main`:
   - `index.html`
   - `dashboard_admin_v2.html`
   - `dashboard_vendedores.html`
   - `supabase_schema_limpio.sql` (opcional, para referencia)

#### 2A.2 Activar GitHub Pages
1. Ve a **Settings** → **Pages**
2. En "Source", selecciona **Branch: main**
3. GitHub generará tu URL (ej: `https://kafelagency.github.io/KAFEL/`)

#### 2A.3 Acceder
Tu sistema estará disponible en: `https://kafelagency.github.io/KAFEL/`

✅ **Los CORS se resuelven automáticamente con HTTPS**

---

### **Opción B: Vercel (Alternativa Rápida)**

1. Ve a https://vercel.com
2. Haz clic en "Import Project"
3. Conecta tu repo de GitHub
4. Selecciona la rama `main`
5. Deploy automático en segundos

---

### **Opción C: Netlify (Alternativa Rápida)**

1. Ve a https://netlify.com
2. Haz clic en "Add new site" → "Import an existing project"
3. Conecta GitHub
4. Selecciona repo y rama
5. Deploy automático

---

## ✔️ Paso 3: Verificar Funcionamiento

### 3.1 Acceder al sistema
1. Abre tu URL pública (GitHub Pages, Vercel o Netlify)
2. Verás el landing page con dos botones:
   - **Panel Administrativo** (dashboard_admin_v2.html)
   - **Dashboard Vendedores** (dashboard_vendedores.html)

### 3.2 Panel Administrativo
1. Haz clic en "Panel Administrativo"
2. Verifica que cargue sin errores
3. En el Dashboard deberías ver:
   - Total Vendedores
   - Ventas Este Mes
   - Fondo KAFEL Acumulado
   - Top Vendedores

### 3.3 Dashboard Vendedores
1. Vuelve y haz clic en "Dashboard Vendedores"
2. Aparecerá login con dropdown de vendedores
3. Selecciona "Memo" para probar
4. Deberías ver su dashboard con opciones de registrar ventas

---

## 📖 Guía de Uso

### **Panel Administrativo** (dashboard_admin_v2.html)

**Secciones principales:**

#### 1. 📊 Dashboard
- Vista general del negocio
- Total de vendedores
- Ventas del mes actual
- Fondo KAFEL acumulado
- Top 5 vendedores

#### 2. 💰 Todas las Ventas
- Ver todas las ventas registradas
- **Filtros disponibles:**
  - Fecha (desde - hasta)
  - Tipo de venta (Física, Digital, Donación)
  - Estado de pago (Sin pagar, 40% pagado, 100% pagado, Entregado)

#### 3. 👥 Vendedores
- Listado de todos los vendedores
- Ver detalles completos (click en vendedor)
- Información personal
- Historial de ventas
- Equipo referido
- Eliminar vendedor (requiere contraseña)

#### 4. 📊 Distribuciones
- Visualización de cómo se distribuye cada venta
- **Distribución estándar:**
  - 5% Operaciones
  - 5% Inversor
  - 20% Fondo KAFEL (se acumula)
  - 25-40% Vendedores (según ventas)
  - 30% Programadores
- Gráfica de barras interactiva
- Información del Fondo KAFEL (60% Miguel, 40% Memo)

#### 5. 💸 Gastos
- Registrar nuevos gastos operativos
- Campos: Concepto, Valor Unitario, Cantidad
- Ver gastos del mes actual
- Los gastos se descuentan del 5% de operaciones
- Alerta si gastos > presupuesto

#### 6. 📋 Clientes
- Base de datos de empresas contactadas
- **Filtros:**
  - Nombre de empresa
  - Sector (Alimentos, Ropa, Tecnología, Servicios, Otro)
  - Tipo (Venta o Donación)
- Ver historial de contacto

#### 7. ➕ Registrar Vendedor
- Formulario para agregar nuevos vendedores
- **Campos obligatorios:**
  - Nombre completo
  - Cédula
  - Email
  - Teléfono
- **Campos opcionales:**
  - Vendedor referidor (para bonificación del 5%)
  - Tipo de rol (Vendedor o Programador)

---

### **Dashboard Vendedores** (dashboard_vendedores.html)

**Secciones principales:**

#### 1. 📊 Dashboard
- Mis ventas este mes
- Mi comisión estimada
- Mi equipo referido
- Progreso hacia siguiente nivel

#### 2. 💰 Registrar Venta
- Formulario para registrar nuevas ventas
- **Campos:**
  - Fecha de venta
  - Nombre cliente
  - Monto de venta
  - Tipo (Física, Digital, Donación)
  - Programador asignado
- **Comisión automática:**
  - 1-10 ventas: 25%
  - 11+ ventas: 30%
  - +5% si tiene referidos

#### 3. 📋 Mis Ventas
- Historial de todas mis ventas
- Filtros por tipo y estado
- Ver detalles de cada venta

#### 4. 💸 Comisiones
- Ver todas mis comisiones ganadas
- Desglose por mes
- Estado de pago (Sin pagar, 40%, 100%, Entregado)
- Total acumulado

#### 5. 👥 Mi Equipo
- Ver vendedores que referí
- Estadísticas del equipo
- Bonificación del 5% que gano por sus ventas

---

## 🏗️ Estructura del Proyecto

```
KAFEL/
├── index.html                      # Landing page - Punto de entrada
├── dashboard_admin_v2.html         # Panel administrativo completo
├── dashboard_vendedores.html       # Dashboard para vendedores
├── supabase_schema_limpio.sql      # Schema SQL completo
├── INSTALACION_SQL.md              # Guía de instalación SQL
├── GUIA_COMPLETA_SETUP.md          # Este archivo
└── (otros archivos de desarrollo)
```

---

## 🗄️ Estructura de Base de Datos

### Tabla: `vendedores`
```sql
- id (UUID)
- nombre (TEXT)
- cedula (TEXT)
- email (EMAIL)
- telefono (TEXT)
- rol (TEXT: 'vendedor' o 'programador')
- vendedor_referidor_id (UUID)
- nivel_comision (INT)
- comision_base (DECIMAL)
- estado (TEXT: 'activo' o 'inactivo')
- fecha_contrato (DATE)
```

### Tabla: `ventas`
```sql
- id (UUID)
- vendedor_id (UUID) →FK vendedores
- programador_id (UUID) → FK vendedores
- cliente_nombre (TEXT)
- cliente_id (UUID) → FK clientes
- monto_total (DECIMAL)
- tipo_venta (TEXT: 'fisica', 'digital', 'donacion')
- estado_pago (TEXT: 'sin_pagar', '40_pagado', '100_pagado', 'entregado')
- mes_pago (TEXT: 'YYYY-MM')
- fecha_venta (DATE)
```

### Tabla: `comisiones`
```sql
- id (UUID)
- vendedor_id (UUID)
- venta_id (UUID)
- monto (DECIMAL)
- porcentaje (DECIMAL)
- tipo (TEXT: 'venta', 'referido', 'exceso')
- created_at (TIMESTAMP)
```

### Tabla: `gastos`
```sql
- id (UUID)
- concepto (TEXT)
- valor_unitario (DECIMAL)
- cantidad (INT)
- mes_ano (TEXT: 'YYYY-MM')
- fecha_registro (DATE)
```

### Tabla: `fondo_kafel`
```sql
- id (UUID)
- mes_ano (TEXT: 'YYYY-MM')
- monto_mensual (DECIMAL)
- saldo_anterior (DECIMAL)
- saldo_final (DECIMAL)
```

### Tabla: `clientes`
```sql
- id (UUID)
- nombre_empresa (TEXT)
- sector (TEXT)
- tipo (TEXT: 'venta' o 'donacion')
- telefono (TEXT)
- email (EMAIL)
- fecha_contacto (DATE)
```

### Tabla: `distribucion_venta`
```sql
- id (UUID)
- venta_id (UUID)
- operaciones (DECIMAL)
- inversor (DECIMAL)
- fondo_kafel (DECIMAL)
- vendedor (DECIMAL)
- programador (DECIMAL)
```

---

## 💰 Modelo de Comisiones

### Estructura Financiera de Cada Venta
De cada venta se distribuye:
- **5%** → Operaciones (para gastos)
- **5%** → Inversor
- **20%** → Fondo KAFEL (se acumula, 60% Miguel / 40% Memo)
- **25-40%** → Vendedor (según número de ventas)
- **30%** → Programador

### Comisión del Vendedor
- **1-10 ventas**: 25%
- **11+ ventas**: 30%
- **+5% Adicional**: Si tiene vendedores referidos

### Comisión del Programador
- **Miguel**: 30% todas las ventas
- **Otros programadores**: 25% + 5% por cada vendedor referido

### Comisión por Referido
- El vendedor que refiere gana +5% sobre las ventas de su referido
- Solo aplica un nivel (no recursivo)

### Donaciones
- Se registran pero **NO** generan comisión
- Se usan para tracking de expansión
- Se contabilizan en cliente pero no en ventas

---

## ⚙️ Configuración de Supabase

### Actualizar URLs en los archivos HTML

Si tu Supabase tiene URL diferente, actualiza esto en ambos archivos:

**En `dashboard_admin_v2.html` línea ~450:**
```javascript
const SUPABASE_URL = 'https://tu-proyecto.supabase.co';
const SUPABASE_KEY = 'tu-anon-key-aqui';
```

**En `dashboard_vendedores.html` línea ~290:**
```javascript
const SUPABASE_URL = 'https://tu-proyecto.supabase.co';
const SUPABASE_KEY = 'tu-anon-key-aqui';
```

✅ **Obtén estos valores en Supabase:**
1. Ve a Project Settings → API
2. Copia "Project URL" y "anon public" key

---

## 🔐 Seguridad

### Credenciales de Admin
Para eliminar vendedores se requiere:
- **Usuario**: `Ukeyo`
- **Contraseña**: `24398As+-`

⚠️ **Cambia esto en producción!**

### Row Level Security (RLS)
- Actualmente tiene políticas permisivas (development)
- En producción, configura RLS restrictivo
- Solo usuarios autenticados deben ver datos

---

## 🐛 FAQ y Troubleshooting

### P: ¿Por qué veo errores CORS?
**R:** Esto sucede cuando abres el archivo como `file://`
- ✅ **Solución**: Despliega en GitHub Pages, Vercel o Netlify
- Con HTTPS funciona perfectamente

### P: ¿Por qué no me carga Supabase?
**R:** Probablemente la URL o Key están incorrectas
- ✅ Verifica en Project Settings → API
- Asegúrate de usar `anon public` key (no `service_role`)

### P: ¿Cómo cambio el mes de distribuciones?
**R:** En Panel Admin → Distribuciones
- Hay un selector de mes arriba
- Elige el mes y haz clic en "Cargar"

### P: ¿Qué pasa con las donaciones?
**R:** Las donaciones:
- Se registran en la tabla de ventas
- **NO generan comisión**
- Se usan para tracking de expansión
- Aparecen separadas en reportes

### P: ¿Cómo calcula la comisión automáticamente?
**R:** El sistema calcula comisión cuando:
1. Se registra una venta
2. Se selecciona el tipo y programador
3. Se aplican los porcentajes según ventas previas
4. Se registra en la tabla `comisiones`

### P: ¿Puedo editar una venta ya registrada?
**R:** Actualmente no está implementada la edición
- Elimina y registra de nuevo, o
- Actualiza directamente en Supabase

### P: ¿Qué es el Fondo KAFEL?
**R:** Es un 20% de cada venta que se acumula:
- Se distribuye 60% a Miguel, 40% a Memo
- Sirve como fondo de capital de la empresa
- Se ve en Panel Admin → Distribuciones

### P: ¿Cómo funciona la referencia?
**R:** Cuando registras un vendedor con referidor:
- Gana comisión directa (25-30%)
- El referidor gana +5% adicional
- Solo un nivel (no multinivel)

---

## 🚀 Próximos Pasos (Opcional)

1. **WhatsApp Integration**
   - Implementar notificaciones por WhatsApp
   - Avisar cuando se registra una venta
   - Confirmar pagos de comisión

2. **Email Automation**
   - Enviar reportes mensuales
   - Confirmar registros de vendedor
   - Alertas de pagos pendientes

3. **Análitica Avanzada**
   - Gráficos de tendencias
   - Predicción de comisiones
   - Reportes personalizados

4. **Mobile App**
   - Versión móvil nativa
   - Notificaciones push
   - Acceso offline

5. **Automatización**
   - Triggers automáticos para comisiones
   - Cálculo de pagos automático
   - Reportes generados automáticamente

---

## 📞 Soporte

Si encuentras problemas:

1. **Verifica la consola del navegador** (F12)
2. **Revisa los logs de Supabase**
3. **Asegúrate de tener HTTPS** (no file://)
4. **Limpia caché del navegador**
5. **Prueba en otro navegador**

---

## 📝 Historial de Cambios

**v2.0 - Septiembre 2026**
- Sistema completo de comisiones
- Panel administrativo profesional
- Dashboard de vendedores
- Fondo KAFEL acumulativo
- Soporte para 3 tipos de venta
- Sistema de gastos operativos

**v1.0**
- Schema inicial de base de datos
- Estructura de tablas

---

**Última actualización**: Septiembre 18, 2026
**Desarrollado por**: Claude + Miguel Acevedo
**Licencia**: Privada - KAFEL Agency
