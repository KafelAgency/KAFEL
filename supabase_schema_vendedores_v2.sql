-- ============================================================================
-- KAFEL - SISTEMA DE VENDEDORES Y COMISIONES v2.0
-- Base de datos completa con todas las tablas necesarias
-- ============================================================================

-- 1. TABLA: CLIENTES
CREATE TABLE IF NOT EXISTS clientes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre_empresa VARCHAR(255) NOT NULL,
    sector VARCHAR(100),
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('venta', 'donacion')),
    telefono VARCHAR(20),
    email VARCHAR(255),
    fecha_contacto TIMESTAMP DEFAULT NOW(),
    notas TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. TABLA: VENDEDORES
CREATE TABLE IF NOT EXISTS vendedores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(255) NOT NULL,
    cedula VARCHAR(50) UNIQUE,
    email VARCHAR(255) UNIQUE,
    telefono VARCHAR(20),
    rol VARCHAR(50) NOT NULL CHECK (rol IN ('vendedor', 'programador', 'inversor', 'admin')),
    es_memo BOOLEAN DEFAULT FALSE,
    estado VARCHAR(50) DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo', 'suspendido')),
    vendedor_referidor_id UUID REFERENCES vendedores(id),
    nivel_comision INTEGER DEFAULT 1,
    comision_base DECIMAL(5,2) DEFAULT 0.25,
    fecha_contrato TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 3. TABLA: VENTAS
CREATE TABLE IF NOT EXISTS ventas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vendedor_id UUID NOT NULL REFERENCES vendedores(id),
    cliente_id UUID REFERENCES clientes(id),
    cliente_nombre VARCHAR(255),
    cliente_telefono VARCHAR(20),
    monto_total DECIMAL(15,2) NOT NULL,
    tipo_venta VARCHAR(50) NOT NULL CHECK (tipo_venta IN ('fisica', 'digital', 'donacion')),
    estado_pago VARCHAR(50) DEFAULT 'sin_pagar' CHECK (estado_pago IN ('sin_pagar', '40_pagado', '100_pagado', 'entregado')),
    programador_id UUID REFERENCES vendedores(id),
    fecha_venta TIMESTAMP DEFAULT NOW(),
    fecha_pago_40 TIMESTAMP,
    fecha_pago_100 TIMESTAMP,
    fecha_entrega TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 4. TABLA: COMISIONES
CREATE TABLE IF NOT EXISTS comisiones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venta_id UUID NOT NULL REFERENCES ventas(id),
    vendedor_id UUID NOT NULL REFERENCES vendedores(id),
    concepto VARCHAR(255) NOT NULL,
    monto DECIMAL(15,2) NOT NULL,
    porcentaje DECIMAL(5,2) NOT NULL,
    tipo_comision VARCHAR(50) NOT NULL CHECK (tipo_comision IN ('base', 'referido', 'programador')),
    estado_pago VARCHAR(50) DEFAULT 'pendiente' CHECK (estado_pago IN ('pendiente', 'parcial', 'pagado')),
    mes_pago VARCHAR(7),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 5. TABLA: GASTOS OPERATIVOS
CREATE TABLE IF NOT EXISTS gastos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    concepto VARCHAR(255) NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    cantidad INTEGER DEFAULT 1,
    mes_ano VARCHAR(7) NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 6. TABLA: FONDO KAFEL
CREATE TABLE IF NOT EXISTS fondo_kafel (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mes_ano VARCHAR(7) NOT NULL UNIQUE,
    saldo_inicial DECIMAL(15,2) DEFAULT 0,
    ingresos_venta DECIMAL(15,2) DEFAULT 0,
    ingresos_sobrantes DECIMAL(15,2) DEFAULT 0,
    saldo_final DECIMAL(15,2) DEFAULT 0,
    porcentaje_miguel DECIMAL(5,2) DEFAULT 60,
    porcentaje_memo DECIMAL(5,2) DEFAULT 40,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 7. TABLA: DISTRIBUCION VENTA (desglose de cada venta)
CREATE TABLE IF NOT EXISTS distribucion_venta (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venta_id UUID NOT NULL REFERENCES ventas(id),
    operaciones DECIMAL(15,2),
    inversor DECIMAL(15,2),
    fondo_kafel DECIMAL(15,2),
    vendedor DECIMAL(15,2),
    programador DECIMAL(15,2),
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

-- Permitir acceso público de lectura para demo (en producción usar Auth)
CREATE POLICY "Permitir lectura pública clientes" ON clientes FOR SELECT USING (true);
CREATE POLICY "Permitir lectura pública vendedores" ON vendedores FOR SELECT USING (true);
CREATE POLICY "Permitir lectura pública ventas" ON ventas FOR SELECT USING (true);
CREATE POLICY "Permitir lectura pública comisiones" ON comisiones FOR SELECT USING (true);
CREATE POLICY "Permitir lectura pública gastos" ON gastos FOR SELECT USING (true);
CREATE POLICY "Permitir lectura pública fondo_kafel" ON fondo_kafel FOR SELECT USING (true);
CREATE POLICY "Permitir lectura pública distribucion_venta" ON distribucion_venta FOR SELECT USING (true);

-- Permitir inserciones
CREATE POLICY "Permitir inserción clientes" ON clientes FOR INSERT WITH CHECK (true);
CREATE POLICY "Permitir inserción vendedores" ON vendedores FOR INSERT WITH CHECK (true);
CREATE POLICY "Permitir inserción ventas" ON ventas FOR INSERT WITH CHECK (true);
CREATE POLICY "Permitir inserción comisiones" ON comisiones FOR INSERT WITH CHECK (true);
CREATE POLICY "Permitir inserción gastos" ON gastos FOR INSERT WITH CHECK (true);
CREATE POLICY "Permitir inserción fondo_kafel" ON fondo_kafel FOR INSERT WITH CHECK (true);
CREATE POLICY "Permitir inserción distribucion_venta" ON distribucion_venta FOR INSERT WITH CHECK (true);

-- Permitir actualizaciones
CREATE POLICY "Permitir actualización clientes" ON clientes FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Permitir actualización vendedores" ON vendedores FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Permitir actualización ventas" ON ventas FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Permitir actualización comisiones" ON comisiones FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Permitir actualización gastos" ON gastos FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Permitir actualización fondo_kafel" ON fondo_kafel FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Permitir actualización distribucion_venta" ON distribucion_venta FOR UPDATE USING (true) WITH CHECK (true);

-- ============================================================================
-- DATOS INICIALES
-- ============================================================================

-- Insertar vendedores principales
INSERT INTO vendedores (id, nombre, cedula, email, telefono, rol, es_memo, estado, nivel_comision, comision_base) VALUES
('miguel-uuid', 'Miguel', '123456', 'miguel@kafel.com', '3001234567', 'programador', FALSE, 'activo', 1, 0.30),
('memo-uuid', 'Memo', '654321', 'memo@kafel.com', '3009876543', 'vendedor', TRUE, 'activo', 1, 0.40),
('john-uuid', 'John', '111111', 'john@kafel.com', '3005555555', 'inversor', FALSE, 'activo', 0, 0.05),
('isa-uuid', 'Isa', '222222', 'isa@kafel.com', '3006666666', 'inversor', FALSE, 'activo', 0, 0.05)
ON CONFLICT (cedula) DO NOTHING;

-- Inicializar Fondo KAFEL para mes actual
INSERT INTO fondo_kafel (mes_ano, saldo_inicial, porcentaje_miguel, porcentaje_memo)
VALUES (TO_CHAR(NOW(), 'YYYY-MM'), 0, 60, 40)
ON CONFLICT (mes_ano) DO NOTHING;

-- ============================================================================
-- FUNCIONES Y TRIGGERS (Opcional - para automatizar cálculos)
-- ============================================================================

-- Función para calcular comisión de vendedor
CREATE OR REPLACE FUNCTION calcular_comision_vendedor(
    p_vendedor_id UUID,
    p_monto DECIMAL,
    p_tipo_venta VARCHAR
) RETURNS TABLE(comision DECIMAL, porcentaje DECIMAL, fondo_kafel_sobrante DECIMAL) AS $$
DECLARE
    v_nivel_comision INTEGER;
    v_es_memo BOOLEAN;
    v_num_ventas INTEGER;
    v_porcentaje_vendedor DECIMAL;
    v_porcentaje_fondo DECIMAL;
BEGIN
    -- Obtener nivel y verificar si es Memo
    SELECT nivel_comision, es_memo INTO v_nivel_comision, v_es_memo
    FROM vendedores
    WHERE id = p_vendedor_id;

    -- Contar ventas del vendedor
    SELECT COUNT(*) INTO v_num_ventas
    FROM ventas
    WHERE vendedor_id = p_vendedor_id AND tipo_venta IN ('fisica', 'digital');

    -- Determinar porcentaje según ventas
    IF v_num_ventas < 11 THEN
        v_porcentaje_vendedor := 0.25;
    ELSE
        v_porcentaje_vendedor := 0.30;
    END IF;

    -- Si es Memo, puede llegar a 40%
    IF v_es_memo THEN
        v_porcentaje_vendedor := 0.40;
    END IF;

    v_porcentaje_fondo := 0;

    RETURN QUERY SELECT
        (p_monto * v_porcentaje_vendedor)::DECIMAL as comision,
        (v_porcentaje_vendedor * 100)::DECIMAL as porcentaje,
        (p_monto * v_porcentaje_fondo)::DECIMAL as fondo_kafel_sobrante;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================
