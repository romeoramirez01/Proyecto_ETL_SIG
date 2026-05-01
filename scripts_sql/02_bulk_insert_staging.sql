/*
Cambie la ruta C:\RUTA\DATASET por la carpeta real donde deje los CSV.
*/
BULK INSERT dbo.stg_cliente
FROM 'C:\Users\adilc\Downloads\parcial\parcial\stg_cliente.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);

BULK INSERT dbo.stg_categoria
FROM 'C:\Users\adilc\Downloads\parcial\parcial\stg_categoria.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);

BULK INSERT dbo.stg_producto
FROM 'C:\Users\adilc\Downloads\parcial\parcial\stg_producto.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);

BULK INSERT dbo.stg_pedido
FROM 'C:\Users\adilc\Downloads\parcial\parcial\stg_pedido.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);

BULK INSERT dbo.stg_detalle_pedido
FROM 'C:\Users\adilc\Downloads\parcial\parcial\stg_detalle_pedido.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);