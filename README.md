# Dashboard de Ventas — SQL Server + Power BI

Proyecto de inteligencia de negocios con un modelo estrella en SQL Server (datos ficticios) y un dashboard en Power BI.

## Estructura
```
sql/
  01_crear_esquema.sql   -- base de datos y tablas (dim_* y fact_ventas)
  02_datos_ejemplo.sql   -- ~5,000 ventas aleatorias (2024 - oct 2026)
  03_vista_ventas.sql    -- vista aplanada opcional
powerbi/
  medidas_DAX.md         -- medidas del dashboard
  dashboard_ventas.pbix  -- (agrega aquí tu archivo)
imagenes/                -- capturas del dashboard
```

## Modelo de datos
`fact_ventas` ← `dim_fecha`, `dim_cliente`, `dim_producto`, `dim_vendedor`

## Cómo reproducirlo
1. En SQL Server Management Studio ejecuta, en orden, `01`, `02` y `03`.
2. En Power BI Desktop: *Obtener datos > SQL Server* → servidor `localhost` (o tu instancia), base `DashboardVentas`, modo **Importar**, selecciona las 5 tablas.
3. Verifica relaciones, marca `dim_fecha` como tabla de fechas y crea las medidas de `powerbi/medidas_DAX.md`.
4. Construye las visualizaciones (ver abajo).

## Visualizaciones sugeridas
- Tarjetas: Ventas Totales, Utilidad, Margen %, Ticket Promedio, Crecimiento YoY %
- Líneas: Ventas por mes (con Ventas Año Anterior)
- Barras: Ventas por categoría, Top 5 productos, ventas por vendedor
- Dona: Ventas por segmento de cliente
- Segmentadores: Año, Zona, Categoría

## Captura del dashboard
![Dashboard](imagenes/dashboard.png)

## Autor
Anthony — Sistemas Inteligentes de Negocio
