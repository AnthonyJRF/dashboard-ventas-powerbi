# Medidas DAX

Crea una tabla para medidas (Modelado > Nueva tabla: `Medidas = {1}`) y agrega estas medidas ahí.

```DAX
Ventas Totales = SUM(fact_ventas[total_venta])

Costo Total = SUM(fact_ventas[costo_total])

Utilidad = [Ventas Totales] - [Costo Total]

Margen % = DIVIDE([Utilidad], [Ventas Totales])

Unidades Vendidas = SUM(fact_ventas[cantidad])

Num Transacciones = COUNTROWS(fact_ventas)

Ticket Promedio = DIVIDE([Ventas Totales], [Num Transacciones])

Ventas Año Anterior =
CALCULATE([Ventas Totales], SAMEPERIODLASTYEAR(dim_fecha[fecha]))

Crecimiento YoY % =
DIVIDE([Ventas Totales] - [Ventas Año Anterior], [Ventas Año Anterior])

Ventas YTD =
TOTALYTD([Ventas Totales], dim_fecha[fecha])
```

**Importante:** marca `dim_fecha` como tabla de fechas (clic derecho en la tabla > *Marcar como tabla de fechas* > columna `fecha`).

Relaciones (1 a muchos, de la dimensión hacia hechos):
`dim_fecha[fecha_key]`, `dim_cliente[cliente_id]`, `dim_producto[producto_id]`, `dim_vendedor[vendedor_id]` → `fact_ventas`.
