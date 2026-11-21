/* =====================================================
   Dashboard de Ventas - Esquema estrella (SQL Server)
   Ejecutar primero este script.
   ===================================================== */
IF DB_ID('DashboardVentas') IS NULL
    CREATE DATABASE DashboardVentas;
GO
USE DashboardVentas;
GO

DROP TABLE IF EXISTS dbo.fact_ventas;
DROP TABLE IF EXISTS dbo.dim_fecha;
DROP TABLE IF EXISTS dbo.dim_cliente;
DROP TABLE IF EXISTS dbo.dim_producto;
DROP TABLE IF EXISTS dbo.dim_vendedor;
GO

CREATE TABLE dbo.dim_fecha (
    fecha_key   INT         NOT NULL PRIMARY KEY,   -- formato yyyymmdd
    fecha       DATE        NOT NULL,
    anio        INT         NOT NULL,
    trimestre   INT         NOT NULL,
    mes         INT         NOT NULL,
    nombre_mes  VARCHAR(20) NOT NULL,
    dia         INT         NOT NULL,
    dia_semana  VARCHAR(20) NOT NULL
);

CREATE TABLE dbo.dim_cliente (
    cliente_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL,
    segmento   VARCHAR(30)  NOT NULL,   
    zona       VARCHAR(30)  NOT NULL
);

CREATE TABLE dbo.dim_producto (
    producto_id  INT IDENTITY(1,1) PRIMARY KEY,
    nombre       VARCHAR(100)  NOT NULL,
    categoria    VARCHAR(50)   NOT NULL,
    precio_lista DECIMAL(10,2) NOT NULL,
    costo        DECIMAL(10,2) NOT NULL
);

CREATE TABLE dbo.dim_vendedor (
    vendedor_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    zona        VARCHAR(30)  NOT NULL
);

CREATE TABLE dbo.fact_ventas (
    venta_id        INT IDENTITY(1,1) PRIMARY KEY,
    fecha_key       INT NOT NULL REFERENCES dbo.dim_fecha(fecha_key),
    cliente_id      INT NOT NULL REFERENCES dbo.dim_cliente(cliente_id),
    producto_id     INT NOT NULL REFERENCES dbo.dim_producto(producto_id),
    vendedor_id     INT NOT NULL REFERENCES dbo.dim_vendedor(vendedor_id),
    cantidad        INT           NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento       DECIMAL(5,2)  NOT NULL,
    total_venta     DECIMAL(12,2) NOT NULL,
    costo_total     DECIMAL(12,2) NOT NULL
);
GO
