-- ============ TABLAS NUEVAS PARA SISTEMA DE VENDEDORES Y COMISIONES ============

-- Tabla: vendedores
CREATE TABLE IF NOT EXISTS vendedores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre TEXT NOT NULL,
  email TEXT UNIQUE,
  telefono TEXT,
  rol TEXT CHECK (rol IN ('vendedor', 'programador')) DEFAULT 'vendedor',
  vendedor_referidor_id UUID REFERENCES vendedores(id) ON DELETE SET NULL,
  programador_principal_id UUID REFERENCES vendedores(id) ON DELETE SET NULL,
  nivel_comision INT DEFAULT 1,
  comision_base NUMERIC DEFAULT 0.25,
  estado TEXT DEFAULT 'activo',
  fecha_registro TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tabla: ventas mejorada
CREATE TABLE IF NOT EXISTS ventas_nuevo (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vendedor_id UUID NOT NULL REFERENCES vendedores(id),
  programador_id UUID REFERENCES vendedores(id),
  cliente_nombre TEXT,
  cliente_telefono TEXT,
  monto_total NUMERIC NOT NULL,
  tipo_venta TEXT CHECK (tipo_venta IN ('fisica', 'digital')) NOT NULL,
  estado TEXT DEFAULT 'completada',
  fecha_venta TIMESTAMP DEFAULT NOW(),
  fecha_pago TIMESTAMP,
  pagado BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tabla: comisiones calculadas
CREATE TABLE IF NOT EXISTS comisiones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  venta_id UUID NOT NULL REFERENCES ventas_nuevo(id) ON DELETE CASCADE,
  vendedor_id UUID NOT NULL REFERENCES vendedores(id),
  concepto TEXT,
  monto NUMERIC NOT NULL,
  porcentaje NUMERIC NOT NULL,
  tipo_comision TEXT CHECK (tipo_comision IN ('base', 'referido', 'programador_base', 'programador_referido')) DEFAULT 'base',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tabla: distribución financiera
CREATE TABLE IF NOT EXISTS distribucion_venta (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  venta_id UUID NOT NULL REFERENCES ventas_nuevo(id) ON DELETE CASCADE,
  concepto TEXT,
  porcentaje NUMERIC NOT NULL,
  monto NUMERIC NOT NULL,
  destinatario TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============ INDICES PARA PERFORMANCE ============
CREATE INDEX idx_vendedores_rol ON vendedores(rol);
CREATE INDEX idx_vendedores_referidor ON vendedores(vendedor_referidor_id);
CREATE INDEX idx_ventas_nuevo_vendedor ON ventas_nuevo(vendedor_id);
CREATE INDEX idx_ventas_nuevo_programador ON ventas_nuevo(programador_id);
CREATE INDEX idx_ventas_nuevo_estado ON ventas_nuevo(estado);
CREATE INDEX idx_comisiones_venta ON comisiones(venta_id);
CREATE INDEX idx_comisiones_vendedor ON comisiones(vendedor_id);

-- ============ ROW LEVEL SECURITY ============
ALTER TABLE vendedores ENABLE ROW LEVEL SECURITY;
ALTER TABLE ventas_nuevo ENABLE ROW LEVEL SECURITY;
ALTER TABLE comisiones ENABLE ROW LEVEL SECURITY;
ALTER TABLE distribucion_venta ENABLE ROW LEVEL SECURITY;

-- Políticas públicas para lectura/escritura (cambiar según necesidad de seguridad)
CREATE POLICY "vendedores_read" ON vendedores FOR SELECT USING (true);
CREATE POLICY "vendedores_write" ON vendedores FOR INSERT WITH CHECK (true);
CREATE POLICY "vendedores_update" ON vendedores FOR UPDATE USING (true);

CREATE POLICY "ventas_nuevo_read" ON ventas_nuevo FOR SELECT USING (true);
CREATE POLICY "ventas_nuevo_write" ON ventas_nuevo FOR INSERT WITH CHECK (true);
CREATE POLICY "ventas_nuevo_update" ON ventas_nuevo FOR UPDATE USING (true);

CREATE POLICY "comisiones_read" ON comisiones FOR SELECT USING (true);
CREATE POLICY "comisiones_write" ON comisiones FOR INSERT WITH CHECK (true);

CREATE POLICY "distribucion_read" ON distribucion_venta FOR SELECT USING (true);
CREATE POLICY "distribucion_write" ON distribucion_venta FOR INSERT WITH CHECK (true);
