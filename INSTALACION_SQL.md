# 🔧 Instalación del Sistema KAFEL en Supabase

## ✅ Paso 1: Preparar Supabase

1. Ve a https://supabase.com y abre tu proyecto KAFEL
2. En el menú izquierdo, ve a **SQL Editor**
3. Crea una nueva query (botón azul "New Query")

## ✅ Paso 2: Ejecutar el SQL Limpio

1. **Copia TODO el contenido** de `supabase_schema_limpio.sql`
2. **Pégalo en el SQL Editor** de Supabase
3. Haz clic en el botón verde **"Run"** (esquina superior derecha)

> ⚠️ **IMPORTANTE**: Este SQL:
> - ✅ Borra tablas antiguas de forma segura (DROP CASCADE)
> - ✅ Crea todas las tablas nuevas sin errores
> - ✅ Configura índices para optimización
> - ✅ Establece RLS policies
> - ✅ Inserta datos iniciales (Miguel, Memo, John, Isa)
> - ✅ Muestra verificación al final

## ✅ Paso 3: Verificar que funcionó

Después de ejecutar, deberías ver en los resultados:

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

Si ves estos 7 resultados, ¡está perfecto! ✅

## ✅ Paso 4: Desplegar los Dashboards

### Para Vendedores:
- Abre el archivo `dashboard_vendedores.html`
- O cópialo a un servidor web
- Los vendedores se loguean con su nombre
- Registran ventas automáticamente

### Para Admin:
- Abre el archivo `dashboard_admin_v2.html`
- Tienes acceso completo a:
  - Todas las ventas
  - Gestión de vendedores
  - Distribuciones por mes
  - Gastos operativos
  - Base de clientes

## 🚨 Si hay errores:

### Error: "relation does not exist"
**Solución**: Copia TODO el SQL (incluyendo los DROP TABLE al inicio)

### Error: "syntax error at or near"
**Solución**: Asegúrate de copiar el SQL limpio, no el anterior

### Error: "already exists"
**Solución**: El SQL ya incluye `DROP TABLE IF EXISTS`, ejecuta nuevamente

## 📊 Estructura de Datos Final

### Tablas Principales:
- **vendedores**: Registro de todos (vendedores, programadores, inversores)
- **ventas**: Todas las transacciones (física/digital/donación)
- **comisiones**: Cálculo automático de comisiones
- **clientes**: Base de datos de empresas contactadas
- **gastos**: Gastos operativos mensuales
- **fondo_kafel**: Acumula mes a mes (60% Miguel, 40% Memo)
- **distribucion_venta**: Desglose de cada venta

### Datos Iniciales Cargados:
```
Miguel    (Programador)  - ID: 550e8400-e29b-41d4-a716-446655440000
Memo      (Vendedor)     - ID: 550e8400-e29b-41d4-a716-446655440001
John      (Inversor)     - ID: 550e8400-e29b-41d4-a716-446655440002
Isa       (Inversora)    - ID: 550e8400-e29b-41d4-a716-446655440003
```

## 🎯 Próximos Pasos:

1. **Registrar más vendedores** en `dashboard_admin_v2.html`
2. **Crear clientes** en la sección de clientes
3. **Registrar ventas** desde `dashboard_vendedores.html`
4. **Monitorear comisiones y distribuciones**

---

**Preguntas o problemas**: Intenta copiar nuevamente el SQL limpio del archivo `supabase_schema_limpio.sql`
