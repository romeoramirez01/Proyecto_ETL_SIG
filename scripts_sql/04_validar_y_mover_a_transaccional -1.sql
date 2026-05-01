USE BD_RETAIL_OLTP;
GO

/* =========================================
   CREACION DE TABLAS DEL DATA MART
   ========================================= */

IF OBJECT_ID('dbo.FactVentas', 'U') IS NOT NULL
    DROP TABLE dbo.FactVentas;
GO

IF OBJECT_ID('dbo.DimFecha', 'U') IS NOT NULL
    DROP TABLE dbo.DimFecha;
GO

IF OBJECT_ID('dbo.DimProducto', 'U') IS NOT NULL
    DROP TABLE dbo.DimProducto;
GO

IF OBJECT_ID('dbo.DimCliente', 'U') IS NOT NULL
    DROP TABLE dbo.DimCliente;
GO

CREATE TABLE dbo.DimCliente (
    id_cliente INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    segmento VARCHAR(100) NOT NULL,
    fecha_registro DATE NULL
);
GO

CREATE TABLE dbo.DimProducto (
    id_producto INT NOT NULL PRIMARY KEY,
    producto VARCHAR(200) NOT NULL,
    categoria VARCHAR(200) NOT NULL,
    marca VARCHAR(150) NOT NULL,
    activo BIT NULL
);
GO

CREATE TABLE dbo.DimFecha (
    id_fecha INT NOT NULL PRIMARY KEY,
    fecha DATE NOT NULL,
    anio INT NOT NULL,
    mes INT NOT NULL,
    dia INT NOT NULL,
    trimestre INT NOT NULL
);
GO

CREATE TABLE dbo.FactVentas (
    id_detalle INT NOT NULL PRIMARY KEY,
    id_fecha INT NOT NULL,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    id_pedido INT NOT NULL,
    canal VARCHAR(100) NULL,
    estado VARCHAR(100) NULL,
    ciudad_entrega VARCHAR(100) NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    descuento_pct DECIMAL(8,4) NOT NULL,
    subtotal DECIMAL(14,2) NOT NULL,
    descuento_valor DECIMAL(14,2) NOT NULL,
    total_neto DECIMAL(14,2) NOT NULL,

    CONSTRAINT FK_FactVentas_DimFecha
        FOREIGN KEY (id_fecha) REFERENCES dbo.DimFecha(id_fecha),

    CONSTRAINT FK_FactVentas_DimCliente
        FOREIGN KEY (id_cliente) REFERENCES dbo.DimCliente(id_cliente),

    CONSTRAINT FK_FactVentas_DimProducto
        FOREIGN KEY (id_producto) REFERENCES dbo.DimProducto(id_producto)
);
GO

