-- ============================================================================
-- KAFEL - SISTEMA DE VENDEDORES Y COMISIONES (VERSIÓN LIMPIA Y FUNCIONAL)
-- Ejecutar en Supabase SQL Editor
-- ============================================================================

-- Primero, eliminar tablas antiguas si existen (en orden inverso)
DROP TABLE IF EXISTS distribucion_venta CASCADE;
DROP TABLE IF EXISTS comisiones CASCADE;
DROP TABLE IF EXISTS ventas CASCADE;
DROP TABLE IF EXISTS ventas_nuevo CASCADE;
DROP TABLE IF EXISTS gastos CASCADE;
DROP TABLE IF EXISTS fondo_kafel CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;
DROP TABLE IF EXISTS vendedores CASCADE;

-- ============================================================================
-- TABLA 1: CLIENTES
-- ============================================================================
CREATE TABLE clientes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_empresa VARCHAR(255) NOT NULL,
    sector VARCHAR(100),
    tipo VARCHAR(50) NOT NULL DEFAULT 'venta' CHECK (tipo IN ('venta', 'donacion')),
    telefono VARCHAR(20),
    email VARCHAR(255),
    fecha_contacto TIMESTAMP DEFAULT NOW(),
    notas TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- TABLA 2: VENDEDORES
-- ============================================================================
CREATE TABLE vendedores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(255) NOT NULL,
    cedula VARCHAR(50) UNIQUE,
    email VARCHAR(255) UNIQUE,
    telefono VARCHAR(20),
    rol VARCHAR(50) NOT NULL DEFAULT 'vendedor' CHECK (rol IN ('vendedor', 'programador', 'inversor', 'admin')),
    es_memo BOOLEAN DEFAULT FALSE,
    estado VARCHAR(50) DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo', 'suspendido')),
    vendedor_referidor_id UUID REFERENCES vendedores(id),
    nivel_comision INTEGER DEFAULT 1,
    comision_base DECIMAL(5, 2) DEFAULT 0.25,
    fecha_contrato TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- TABLA 3: VENTAS
-- ============================================================================
CREATE TABLE ventas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vendedor_id UUID NOT NULL REFERENCES vendedores(id) ON DELETE CASCADE,
    cliente_id UUID REFERENCES clientes(id) ON DELETE SET NULL,
    cliente_nombre VARCHAR(255),
    cliente_telefono VARCHAR(20),
    monto_total DECIMAL(15, 2) NOT NULL,
    tipo_venta VARCHAR(50) NOT NULL DEFAULT 'fisica' CHECK (tipo_venta IN ('fisica', 'digital', 'donacion')),
    estado_pago VARCHAR(50) DEFAULT 'sin_pagar' CHECK (estado_pago IN ('sin_pagar', '40_pagado', '100_pagado', 'entregado')),
    programador_id UUID REFERENCES vendedores(id) ON DELETE SET NULL,
    fecha_venta TIMESTAMP DEFAULT NOW(),
    fecha_pago_40 TIMESTAMP,
    fecha_pago_100 TIMESTAMP,
    fecha_entrega TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- TABLA 4: COMISIONES
-- ============================================================================
CREATE TABLE comisiones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venta_id UUID NOT NULL REFERENCES ventas(id) ON DELETE CASCADE,
    vendedor_id UUID NOT NULL REFERENCES vendedores(id) ON DELETE CASCADE,
    concepto VARCHAR(255) NOT NULL,
    monto DECIMAL(15, 2) NOT NULL,
    porcentaje DECIMAL(5, 2) NOT NULL,
    tipo_comision VARCHAR(50) NOT NULL DEFAULT 'base' CHECK (tipo_comision IN ('base', 'referido', 'programador')),
    estado_pago VARCHAR(50) DEFAULT 'pendiente' CHECK (estado_pago IN ('pendiente', 'parcial', 'pagado')),
    mes_pago VARCHAR(7),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- TABLA 5: GASTOS OPERATIVOS
-- ============================================================================
CREATE TABLE gastos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    concepto VARCHAR(255) NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL,
    cantidad INTEGER DEFAULT 1,
    mes_ano VARCHAR(7) NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- TABLA 6: FONDO KAFEL (Acumulativo)
-- ============================================================================
CREATE TABLE fondo_kafel (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mes_ano VARCHAR(7) NOT NULL UNIQUE,
    saldo_inicial DECIMAL(15, 2) DEFAULT 0,
    ingresos_venta DECIMAL(15, 2) DEFAULT 0,
    ingresos_sobrantes DECIMAL(15, 2) DEFAULT 0,
    saldo_final DECIMAL(15, 2) DEFAULT 0,
    porcentaje_miguel DECIMAL(5, 2) DEFAULT 60,
    porcentaje_memo DECIMAL(5, 2) DEFAULT 40,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- TABLA 7: DISTRIBUCION VENTA (Desglose)
-- ============================================================================
CREATE TABLE distribucion_venta (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venta_id UUID NOT NULL REFERENCES ventas(id) ON DELETE CASCADE,
    operaciones DECIMAL(15, 2),
    inversor DECIMAL(15, 2),
    fondo_kafel DECIMAL(15, 2),
    vendedor DECIMAL(15, 2),
    programador DECIMAL(15, 2),
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ============================================================================
CREATE INDEX idx_ventas_vendedor_id ON ventas(vendedor_id);
CREATE INDEX idx_ventas_cliente_id ON ventas(cliente_id);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);
CREATE INDEX idx_ventas_estado ON ventas(estado_pago);
CREATE INDEX idx_comisiones_vendedor_id ON comisiones(vendedor_id);
CREATE INDEX idx_comisiones_venta_id ON comisiones(venta_id);
CREATE INDEX idx_comisiones_mes ON comisiones(mes_pago);
CREATE INDEX idx_gastos_mes ON gastos(mes_ano);
CREATE INDEX idx_vendedores_referidor ON vendedores(vendedor_referidor_id);
CREATE INDEX idx_fondo_kafel_mes ON fondo_kafel(mes_ano);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendedores ENABLE ROW LEVEL SECURITY;
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;
ALTER TABLE comisiones ENABLE ROW LEVEL SECURITY;
ALTER TABLE gastos ENABLE ROW LEVEL SECURITY;
ALTER TABLE fondo_kafel ENABLE ROW LEVEL SECURITY;
ALTER TABLE distribucion_venta ENABLE ROW LEVEL SECURITY;

-- Políticas permisivas (desarrollo - cambiar en producción)
CREATE POLICY "clientes_public_read" ON clientes FOR SELECT USING (true);
CREATE POLICY "clientes_public_insert" ON clientes FOR INSERT WITH CHECK (true);
CREATE POLICY "clientes_public_update" ON clientes FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "clientes_public_delete" ON clientes FOR DELETE USING (true);

CREATE POLICY "vendedores_public_read" ON vendedores FOR SELECT USING (true);
CREATE POLICY "vendedores_public_insert" ON vendedores FOR INSERT WITH CHECK (true);
CREATE POLICY "vendedores_public_update" ON vendedores FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "vendedores_public_delete" ON vendedores FOR DELETE USING (true);

CREATE POLICY "ventas_public_read" ON ventas FOR SELECT USING (true);
CREATE POLICY "ventas_public_insert" ON ventas FOR INSERT WITH CHECK (true);
CREATE POLICY "ventas_public_update" ON ventas FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "ventas_public_delete" ON ventas FOR DELETE USING (true);

CREATE POLICY "comisiones_public_read" ON comisiones FOR SELECT USING (true);
CREATE POLICY "comisiones_public_insert" ON comisiones FOR INSERT WITH CHECK (true);
CREATE POLICY "comisiones_public_update" ON comisiones FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "comisiones_public_delete" ON comisiones FOR DELETE USING (true);

CREATE POLICY "gastos_public_read" ON gastos FOR SELECT USING (true);
CREATE POLICY "gastos_public_insert" ON gastos FOR INSERT WITH CHECK (true);
CREATE POLICY "gastos_public_update" ON gastos FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "gastos_public_delete" ON gastos FOR DELETE USING (true);

CREATE POLICY "fondo_kafel_public_read" ON fondo_kafel FOR SELECT USING (true);
CREATE POLICY "fondo_kafel_public_insert" ON fondo_kafel FOR INSERT WITH CHECK (true);
CREATE POLICY "fondo_kafel_public_update" ON fondo_kafel FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "fondo_kafel_public_delete" ON fondo_kafel FOR DELETE USING (true);

CREATE POLICY "distribucion_venta_public_read" ON distribucion_venta FOR SELECT USING (true);
CREATE POLICY "distribucion_venta_public_insert" ON distribucion_venta FOR INSERT WITH CHECK (true);
CREATE POLICY "distribucion_venta_public_update" ON distribucion_venta FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "distribucion_venta_public_delete" ON distribucion_venta FOR DELETE USING (true);

-- ============================================================================
-- DATOS INICIALES
-- ============================================================================
INSERT INTO vendedores (id, nombre, cedula, email, telefono, rol, es_memo, estado, nivel_comision, comision_base) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Miguel', '1111111111', 'miguel@kafel.com', '3001111111', 'programador', false, 'activo', 1, 0.30),
('550e8400-e29b-41d4-a716-446655440001', 'Memo', '2222222222', 'memo@kafel.com', '3002222222', 'vendedor', true, 'activo', 1, 0.40),
('550e8400-e29b-41d4-a716-446655440002', 'John', '3333333333', 'john@kafel.com', '3003333333', 'inversor', false, 'activo', 0, 0.05),
('550e8400-e29b-41d4-a716-446655440003', 'Isa', '4444444444', 'isa@kafel.com', '3004444444', 'inversor', false, 'activo', 0, 0.05)
ON CONFLICT (cedula) DO NOTHING;

-- Inicializar Fondo KAFEL para mes actual
INSERT INTO fondo_kafel (mes_ano, saldo_inicial, porcentaje_miguel, porcentaje_memo)
SELECT TO_CHAR(NOW(), 'YYYY-MM'), 0, 60, 40
WHERE NOT EXISTS (
    SELECT 1 FROM fondo_kafel WHERE mes_ano = TO_CHAR(NOW(), 'YYYY-MM')
);

-- ============================================================================
-- VERIFICACIÓN: Mostrar tablas creadas
-- ============================================================================
SELECT
    table_name
FROM
    information_schema.tables
WHERE
    table_schema = 'public'
    AND table_type = 'BASE TABLE'
ORDER BY
    table_name;
