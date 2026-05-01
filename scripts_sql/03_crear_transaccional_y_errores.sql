IF OBJECT_ID('dbo.err_cliente','U') IS NOT NULL DROP TABLE dbo.err_cliente;
IF OBJECT_ID('dbo.err_categoria','U') IS NOT NULL DROP TABLE dbo.err_categoria;
IF OBJECT_ID('dbo.err_producto','U') IS NOT NULL DROP TABLE dbo.err_producto;
IF OBJECT_ID('dbo.err_pedido','U') IS NOT NULL DROP TABLE dbo.err_pedido;
IF OBJECT_ID('dbo.err_detalle_pedido','U') IS NOT NULL DROP TABLE dbo.err_detalle_pedido;

IF OBJECT_ID('dbo.Cliente','U') IS NOT NULL DROP TABLE dbo.Cliente;
IF OBJECT_ID('dbo.Categoria','U') IS NOT NULL DROP TABLE dbo.Categoria;
IF OBJECT_ID('dbo.Producto','U') IS NOT NULL DROP TABLE dbo.Producto;
IF OBJECT_ID('dbo.Pedido','U') IS NOT NULL DROP TABLE dbo.Pedido;
IF OBJECT_ID('dbo.DetallePedido','U') IS NOT NULL DROP TABLE dbo.DetallePedido;

CREATE TABLE dbo.err_cliente (
    id_cliente VARCHAR(30), nombre VARCHAR(120), ciudad VARCHAR(80), pais VARCHAR(20), segmento VARCHAR(40),
    fecha_registro VARCHAR(30), motivo_error VARCHAR(200), fecha_carga DATETIME DEFAULT GETDATE()
);

CREATE TABLE dbo.err_categoria (
    id_categoria VARCHAR(30), nombre VARCHAR(120), motivo_error VARCHAR(200), fecha_carga DATETIME DEFAULT GETDATE()
);

CREATE TABLE dbo.err_producto (
    id_producto VARCHAR(30), nombre VARCHAR(150), id_categoria VARCHAR(30), marca VARCHAR(80), activo VARCHAR(20),
    motivo_error VARCHAR(200), fecha_carga DATETIME DEFAULT GETDATE()
);

CREATE TABLE dbo.err_pedido (
    id_pedido VARCHAR(30), id_cliente VARCHAR(30), fecha VARCHAR(30), canal VARCHAR(40), estado VARCHAR(40), ciudad_entrega VARCHAR(80),
    motivo_error VARCHAR(200), fecha_carga DATETIME DEFAULT GETDATE()
);

CREATE TABLE dbo.err_detalle_pedido (
    id_detalle VARCHAR(30), id_pedido VARCHAR(30), id_producto VARCHAR(30), cantidad VARCHAR(30), precio_unitario VARCHAR(30), descuento_pct VARCHAR(30),
    motivo_error VARCHAR(200), fecha_carga DATETIME DEFAULT GETDATE()
);

CREATE TABLE dbo.Cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    ciudad VARCHAR(80) NULL,
    pais VARCHAR(20) NULL,
    segmento VARCHAR(40) NULL,
    fecha_registro DATE NULL
);

CREATE TABLE dbo.Categoria (
    id_categoria INT PRIMARY KEY,
    nombre VARCHAR(120) NULL
);

CREATE TABLE dbo.Producto (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(150) NULL,
    id_categoria INT NULL,
    marca VARCHAR(80) NULL,
    activo BIT NULL,
 CONSTRAINT fk_producto_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES categoria(id_categoria)
);

CREATE TABLE dbo.Pedido (
    id_pedido INT PRIMARY KEY,
    id_cliente INT NULL,
    fecha DATE NULL,
    canal VARCHAR(40) NULL,
    estado VARCHAR(40) NULL,
    ciudad_entrega VARCHAR(80) NULL,
CONSTRAINT fk_pedido_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente)
);

CREATE TABLE dbo.DetallePedido (
    id_detalle INT PRIMARY KEY,
    id_pedido INT NULL,
    id_producto INT NULL,
    cantidad INT NULL,
    precio_unitario DECIMAL(12,2) NULL,
    descuento_pct DECIMAL(8,4) NULL,
   CONSTRAINT fk_detalle_pedido
    FOREIGN KEY (id_pedido)
    REFERENCES pedido(id_pedido),

    CONSTRAINT fk_detalle_producto
    FOREIGN KEY (id_producto)
    REFERENCES producto(id_producto)
);