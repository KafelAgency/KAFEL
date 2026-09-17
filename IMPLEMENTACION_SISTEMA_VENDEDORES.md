# 🎯 Sistema de Vendedores y Comisiones - KAFEL

## Descripción General

Sistema completo de gestión de vendedores con comisiones escalonadas, estructura multinivel y dashboards separados por rol.

---

## 📋 Estructura del Sistema

### Tipos de Comisiones

#### **VENTA FÍSICA** (Presencial)
```
Monto Total = 100%
├─ Operaciones: 10%
├─ Inversor (John & Isa): 5%
├─ Fondo KAFEL: 30% (reinversión)
├─ Vendedor: 25-35% (escalonado)
└─ Programador (Miguel): 30%
```

#### **VENTA DIGITAL**
```
Monto Total = 100%
├─ Operaciones: 10%
├─ Inversor (John & Isa): 5%
├─ Fondo KAFEL: 20% (reinversión)
├─ Vendedor: 25-35% (escalonado)
└─ Programador (Miguel): 30%
```

### Escalas de Comisión de Vendedor

| Rango | Comisión | Condición |
|-------|----------|-----------|
| 1-10 ventas | 25% | Vendedor nuevo |
| 11+ ventas | 30% | Vendedor activo |
| Referidos | +5% | Del vendedor que refirió (solo 1 nivel) |

**Nota**: Si un vendedor referido consigue otro vendedor, el original NO gana el 5% adicional, solo lo que venda directamente.

### Estructura de Programador

- **Miguel (Principal)**: 30% de TODAS las ventas (física y digital)
- **Otros Programadores**: 25% de su trabajo + 5% de programadores reclutados
- **Cap de Miguel**: Siempre gana 5% de todos los programadores, sin importar quién los reclute

---

## 🚀 Pasos de Implementación

### 1. Crear la Base de Datos en Supabase

1. Ve a https://supabase.com y accede a tu proyecto KAFEL
2. Abre el **SQL Editor**
3. Copia el contenido de `supabase_schema_vendedores.sql`
4. Ejecuta el SQL (tendrá que ejecutar dos veces si hay errores iniciales)

**Tablas creadas:**
- `vendedores` - Perfil de cada vendedor
- `ventas_nuevo` - Registro de ventas
- `comisiones` - Cálculo de comisiones
- `distribucion_venta` - Desglose financiero

---

### 2. Inicializar Vendedores Base

Ejecuta este SQL en Supabase para crear los vendedores iniciales:

```sql
INSERT INTO vendedores (id, nombre, email, rol, nivel_comision, comision_base, estado) VALUES
('miguel-uuid', 'Miguel', 'miguel@kafel.com', 'programador', 1, 0.30, 'activo'),
('john-uuid', 'John (Inversor)', 'john@kafel.com', 'inversor', 0, 0.05, 'activo'),
('isa-uuid', 'Isa (Inversor)', 'isa@kafel.com', 'inversor', 0, 0.05, 'activo');
```

Luego registra tus vendedores a través del **Dashboard Admin** o manualmente.

---

### 3. Deployar los Dashboards

#### **Dashboard de Vendedor** (`dashboard_vendedores.html`)
```
Funcionalidades:
✓ Login por vendedor
✓ Registro de ventas (física/digital)
✓ Visualización de comisiones
✓ Seguimiento de equipo (vendedores referidos)
✓ Gráficos de comisiones este mes
```

Usa este para:
- Que cada vendedor vea solo sus datos
- Registro de nuevas ventas
- Seguimiento de comisiones

#### **Dashboard Admin** (`dashboard_admin.html`)
```
Funcionalidades:
✓ Vista consolidada de todas las ventas
✓ Ranking de vendedores
✓ Gestión de vendedores
✓ Análisis de comisiones
✓ Filtros por fecha y tipo
```

Usa este para:
- Supervisar a todos los vendedores
- Registrar nuevos vendedores
- Análisis general del negocio

---

## 📊 Flujo de Registro de Venta

1. **Vendedor abre** `dashboard_vendedores.html`
2. **Selecciona su usuario** en el login
3. **Va a "Registrar Venta"** y completa:
   - Nombre del cliente
   - Teléfono
   - Monto total
   - Tipo (Física o Digital)
   - Programador (opcional)
4. **El sistema calcula automáticamente:**
   - Comisión del vendedor (25% o 30%)
   - Comisión de referidos si tiene
   - Distribución de fondos
5. **Se registra en Supabase**

---

## 🧮 Ejemplo Práctico

### Venta Física de $100,000

**Cliente:** Empresa ABC  
**Tipo:** Física (Presencial)  
**Vendedor:** Juan (10 ventas = 25%)

**Distribución:**
```
Monto Total: $100,000

Operaciones:        10% = $10,000
Inversor (J&I):      5% = $5,000
Fondo KAFEL:        30% = $30,000
├─ Juan (Vendedor): 25% = $25,000
└─ Miguel (Prog):   30% = $30,000
```

**Si Juan tiene un referido (Carlos):**
- Juan recibe: $25,000 (su venta)
- Además: +$2,500 (5% de 50K de Carlos, si Carlos vende)

---

## 🔑 Claves de Acceso

Las credenciales de Supabase están embebidas en los HTML:
- **URL**: `wmjmsdofvmhfnqkzmbsx.supabase.co`
- **API Key**: Se encuentra en los archivos

> ⚠️ IMPORTANTE: En producción, usa variables de entorno y Supabase Auth

---

## 📈 Metricas Disponibles

### Para Vendedores
- Total vendido este mes
- Mi comisión (base + referidos)
- Número de ventas
- Comisión de mi equipo
- Desglose por tipo (física/digital)

### Para Administrador
- Total vendedores activos
- Ventas consolidadas
- Fondo KAFEL acumulado
- Comisiones pagadas
- Top vendedores
- Análisis física vs digital

---

## ⚙️ Personalización

### Cambiar Porcentajes

**En `dashboard_vendedores.html` (línea ~350):**
```javascript
calcularComisiones(monto, tipoVenta) {
    const fisica = tipoVenta === 'fisica';
    return {
        operaciones: monto * 0.10,    // ← Operaciones
        inversor: monto * 0.05,        // ← Inversor
        fondoKafel: monto * (fisica ? 0.30 : 0.20),  // ← Fondo
        vendedor: monto * this.getPorcentajeVendedor(),
        programador: monto * 0.30      // ← Programador
    };
}
```

### Cambiar Escala de Vendedor

**En `dashboard_vendedores.html` (línea ~375):**
```javascript
getPorcentajeVendedor() {
    const numVentas = this.currentVendedor.nivel_comision || 1;
    if (numVentas >= 11) return 0.30;  // ← Cambiar 11 o 0.30
    return 0.25;                        // ← Cambiar 0.25
}
```

---

## 🐛 Troubleshooting

### "No aparece en el login de vendedor"
→ Asegúrate de que el vendedor está registrado en la tabla `vendedores` con `rol = 'vendedor'`

### "Error de conexión a Supabase"
→ Verifica que las credenciales sean correctas en el HTML

### "Las comisiones no se calculan"
→ Revisa que la venta se haya registrado en `ventas_nuevo` y que se insertó en `comisiones`

### "No veo mis referidos"
→ Asegúrate de que están registrados con tu ID en `vendedor_referidor_id`

---

## 📱 Próximos Pasos

- [ ] Integrar con WhatsApp para notificaciones de ventas
- [ ] Generar reportes PDF de comisiones
- [ ] Dashboard móvil optimizado
- [ ] Sistema de pagos (transferencia de comisiones)
- [ ] Histórico de comisiones por mes
- [ ] Predicción de ganancias

---

## 📞 Contacto

Para preguntas sobre el sistema, contacta a Miguel o John en KAFEL.

**Versión:** 1.0  
**Última actualización:** Septiembre 2026
