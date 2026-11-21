/* =====================================================
   Datos de ejemplo (ficticios) - 5,000 ventas
   ===================================================== */
USE DashboardVentas;
GO
SET LANGUAGE Spanish;   
GO

/* ---------- dim_fecha: 2024-01-01 a 2026-12-31 ---------- */
;WITH f AS (
    SELECT CAST('2024-01-01' AS DATE) AS d
    UNION ALL
    SELECT DATEADD(DAY, 1, d) FROM f WHERE d < '2026-12-31'
)
INSERT INTO dbo.dim_fecha (fecha_key, fecha, anio, trimestre, mes, nombre_mes, dia, dia_semana)
SELECT CONVERT(INT, FORMAT(d, 'yyyyMMdd')), d, YEAR(d), DATEPART(QUARTER, d),
       MONTH(d), DATENAME(MONTH, d), DAY(d), DATENAME(WEEKDAY, d)
FROM f
OPTION (MAXRECURSION 0);

/* ---------- dim_vendedor ---------- */
INSERT INTO dbo.dim_vendedor (nombre, zona) VALUES
('Ana Martínez','Norte'), ('Luis Hernández','Norte'),
('Carla Rivera','Centro'), ('Jorge Castillo','Centro'),
('Marta López','Sur'),   ('Pedro Gómez','Occidente');

/* ---------- dim_cliente (30) ---------- */
INSERT INTO dbo.dim_cliente (nombre, segmento, zona) VALUES
('Comercial Alfa','Corporativo','Norte'),('Distribuidora Beta','Corporativo','Centro'),
('Grupo Delta','Corporativo','Sur'),('Importadora Sigma','Corporativo','Occidente'),
('Tecnoservicios Omega','Corporativo','Norte'),('Supermercados Aurora','Corporativo','Centro'),
('Ferretería El Tornillo','Pyme','Norte'),('Papelería Central','Pyme','Centro'),
('Café La Esquina','Pyme','Sur'),('Boutique Lunaris','Pyme','Occidente'),
('Clínica Vida Plena','Pyme','Norte'),('Taller Mecánico Rápido','Pyme','Centro'),
('Panadería Dulce Hogar','Pyme','Sur'),('Librería Saber','Pyme','Occidente'),
('Restaurante Sabor Criollo','Pyme','Norte'),('Gimnasio FitZone','Pyme','Centro'),
('Juan Pérez','Minorista','Norte'),('María Fernández','Minorista','Centro'),
('Carlos Mejía','Minorista','Sur'),('Sofía Reyes','Minorista','Occidente'),
('Daniel Torres','Minorista','Norte'),('Valeria Cruz','Minorista','Centro'),
('Andrés Flores','Minorista','Sur'),('Lucía Ortega','Minorista','Occidente'),
('Miguel Ramos','Minorista','Norte'),('Elena Vargas','Minorista','Centro'),
('Roberto Salinas','Minorista','Sur'),('Camila Duarte','Minorista','Occidente'),
('Hotel Brisa Azul','Corporativo','Sur'),('Colegio Nuevo Horizonte','Corporativo','Occidente');

/* ---------- dim_producto (12) ---------- */
INSERT INTO dbo.dim_producto (nombre, categoria, precio_lista, costo) VALUES
('Laptop 14"','Tecnología',850.00,620.00),
('Monitor 24"','Tecnología',190.00,130.00),
('Teclado inalámbrico','Tecnología',35.00,19.00),
('Mouse ergonómico','Tecnología',28.00,14.00),
('Silla de oficina','Mobiliario',140.00,85.00),
('Escritorio ejecutivo','Mobiliario',260.00,170.00),
('Archivador metálico','Mobiliario',95.00,58.00),
('Resma de papel','Papelería',6.50,4.00),
('Pack de bolígrafos','Papelería',4.20,2.10),
('Cuaderno profesional','Papelería',3.10,1.60),
('Impresora multifunción','Tecnología',210.00,150.00),
('Tóner compatible','Papelería',48.00,29.00);

/* ---------- fact_ventas: 5,000 filas aleatorias ---------- */
DROP TABLE IF EXISTS #fechas;
SELECT ROW_NUMBER() OVER (ORDER BY fecha_key) AS rn, fecha_key
INTO #fechas
FROM dbo.dim_fecha
WHERE fecha BETWEEN '2024-01-01' AND '2026-10-31';

DECLARE @nf INT = (SELECT COUNT(*) FROM #fechas);

DROP TABLE IF EXISTS #r;
;WITH n AS (
    SELECT TOP (5000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS i
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
)
SELECT i,
       ABS(CHECKSUM(NEWID())) % @nf + 1                      AS fecha_rn,
       ABS(CHECKSUM(NEWID())) % 30 + 1                       AS cliente_id,
       ABS(CHECKSUM(NEWID())) % 12 + 1                       AS producto_id,
       ABS(CHECKSUM(NEWID())) % 6  + 1                       AS vendedor_id,
       ABS(CHECKSUM(NEWID())) % 10 + 1                       AS cantidad,
       CAST((ABS(CHECKSUM(NEWID())) % 4) * 0.05 AS DECIMAL(5,2)) AS descuento
INTO #r
FROM n;

INSERT INTO dbo.fact_ventas
    (fecha_key, cliente_id, producto_id, vendedor_id, cantidad, precio_unitario, descuento, total_venta, costo_total)
SELECT f.fecha_key, r.cliente_id, r.producto_id, r.vendedor_id, r.cantidad, p.precio_lista, r.descuento,
       CAST(r.cantidad * p.precio_lista * (1 - r.descuento) AS DECIMAL(12,2)),
       CAST(r.cantidad * p.costo AS DECIMAL(12,2))
FROM #r r
JOIN #fechas f ON f.rn = r.fecha_rn
JOIN dbo.dim_producto p ON p.producto_id = r.producto_id;

DROP TABLE #r; DROP TABLE #fechas;
GO

-- Verificación rápida
SELECT COUNT(*) AS filas, SUM(total_venta) AS ventas_totales FROM dbo.fact_ventas;
GO
