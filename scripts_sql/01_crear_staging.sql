IF DB_ID('BD_RETAIL_OLTP') IS NULL
    CREATE DATABASE BD_RETAIL_OLTP;
GO

USE  BD_RETAIL_OLTP;
GO

IF OBJECT_ID('dbo.stg_cliente','U') IS NOT NULL DROP TABLE dbo.stg_cliente;
IF OBJECT_ID('dbo.stg_categoria','U') IS NOT NULL DROP TABLE dbo.stg_categoria;
IF OBJECT_ID('dbo.stg_producto','U') IS NOT NULL DROP TABLE dbo.stg_producto;
IF OBJECT_ID('dbo.stg_pedido','U') IS NOT NULL DROP TABLE dbo.stg_pedido;
IF OBJECT_ID('dbo.stg_detalle_pedido','U') IS NOT NULL DROP TABLE dbo.stg_detalle_pedido;

CREATE TABLE dbo.stg_cliente (
    id_cliente VARCHAR(30),
    nombre VARCHAR(120),
    ciudad VARCHAR(80),
    pais VARCHAR(20),
    segmento VARCHAR(40),
    fecha_registro VARCHAR(30)
);

CREATE TABLE dbo.stg_categoria (
    id_categoria VARCHAR(30),
    nombre VARCHAR(120)
);

CREATE TABLE dbo.stg_producto (
    id_producto VARCHAR(30),
    nombre VARCHAR(150),
    id_categoria VARCHAR(30),
    marca VARCHAR(80),
    activo VARCHAR(20)
);

CREATE TABLE dbo.stg_pedido (
    id_pedido VARCHAR(30),
    id_cliente VARCHAR(30),
    fecha VARCHAR(30),
    canal VARCHAR(40),
    estado VARCHAR(40),
    ciudad_entrega VARCHAR(80)
);

CREATE TABLE dbo.stg_detalle_pedido (
    id_detalle VARCHAR(30),
    id_pedido VARCHAR(30),
    id_producto VARCHAR(30),
    cantidad VARCHAR(30),
    precio_unitario VARCHAR(30),
    descuento_pct VARCHAR(30)
);