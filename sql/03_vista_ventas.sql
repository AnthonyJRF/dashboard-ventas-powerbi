USE DashboardVentas;
GO
CREATE OR ALTER VIEW dbo.vw_ventas_detalle AS
SELECT v.venta_id, d.fecha, d.anio, d.trimestre, d.mes, d.nombre_mes,
       c.nombre AS cliente, c.segmento, c.zona AS zona_cliente,
       p.nombre AS producto, p.categoria,
       s.nombre AS vendedor, s.zona AS zona_vendedor,
       v.cantidad, v.precio_unitario, v.descuento, v.total_venta, v.costo_total,
       v.total_venta - v.costo_total AS utilidad
FROM dbo.fact_ventas v
JOIN dbo.dim_fecha    d ON d.fecha_key   = v.fecha_key
JOIN dbo.dim_cliente  c ON c.cliente_id  = v.cliente_id
JOIN dbo.dim_producto p ON p.producto_id = v.producto_id
JOIN dbo.dim_vendedor s ON s.vendedor_id = v.vendedor_id;
GO
