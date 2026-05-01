

/* Categoria */
INSERT INTO dbo.err_categoria (id_categoria, nombre, motivo_error)
SELECT id_categoria, nombre,
       CASE
           WHEN TRY_CONVERT(INT, id_categoria) IS NULL THEN 'id_categoria no numerico'
           WHEN rn > 1 THEN 'categoria duplicada'
           WHEN nombre IS NULL OR LTRIM(RTRIM(nombre)) = '' THEN 'nombre vacio'
           ELSE 'registro invalido'
       END
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_categoria ORDER BY (SELECT 1)) AS rn
    FROM dbo.stg_categoria
) x
WHERE TRY_CONVERT(INT, id_categoria) IS NULL
   OR rn > 1
   OR nombre IS NULL OR LTRIM(RTRIM(nombre)) = '';

INSERT INTO dbo.Categoria (id_categoria, nombre)
SELECT TRY_CONVERT(INT, id_categoria), NULLIF(LTRIM(RTRIM(nombre)),'')
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_categoria ORDER BY (SELECT 1)) AS rn
    FROM dbo.stg_categoria
) x
WHERE TRY_CONVERT(INT, id_categoria) IS NOT NULL
  AND rn = 1;

/* Cliente */
INSERT INTO dbo.err_cliente (id_cliente, nombre, ciudad, pais, segmento, fecha_registro, motivo_error)
SELECT id_cliente, nombre, ciudad, pais, segmento, fecha_registro,
       CASE
           WHEN TRY_CONVERT(INT, id_cliente) IS NULL THEN 'id_cliente no numerico'
           WHEN nombre IS NULL OR LTRIM(RTRIM(nombre)) = '' THEN 'nombre vacio'
           WHEN TRY_CONVERT(DATE, fecha_registro) IS NULL THEN 'fecha invalida'
           WHEN rn > 1 THEN 'cliente duplicado'
           ELSE 'registro invalido'
       END
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_cliente ORDER BY (SELECT 1)) AS rn
    FROM dbo.stg_cliente
) x
WHERE TRY_CONVERT(INT, id_cliente) IS NULL
   OR nombre IS NULL OR LTRIM(RTRIM(nombre)) = ''
   OR TRY_CONVERT(DATE, fecha_registro) IS NULL
   OR rn > 1;

INSERT INTO dbo.Cliente (id_cliente, nombre, ciudad, pais, segmento, fecha_registro)
SELECT TRY_CONVERT(INT, id_cliente),
       nombre,
       NULLIF(LTRIM(RTRIM(ciudad)), ''),
       UPPER(NULLIF(LTRIM(RTRIM(pais)), '')),
       NULLIF(LTRIM(RTRIM(segmento)), ''),
       TRY_CONVERT(DATE, fecha_registro)
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_cliente ORDER BY (SELECT 1)) AS rn
    FROM dbo.stg_cliente
) x
WHERE TRY_CONVERT(INT, id_cliente) IS NOT NULL
  AND nombre IS NOT NULL AND LTRIM(RTRIM(nombre)) <> ''
  AND TRY_CONVERT(DATE, fecha_registro) IS NOT NULL
  AND rn = 1;

/* Producto */
INSERT INTO dbo.err_producto (id_producto, nombre, id_categoria, marca, activo, motivo_error)
SELECT id_producto, nombre, id_categoria, marca, activo,
       CASE
           WHEN TRY_CONVERT(INT, id_producto) IS NULL THEN 'id_producto no numerico'
           WHEN rn > 1 THEN 'producto duplicado'
           WHEN TRY_CONVERT(INT, id_categoria) IS NULL THEN 'id_categoria no numerico'
           ELSE 'producto con observacion'
       END
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_producto ORDER BY (SELECT 1)) AS rn
    FROM dbo.stg_producto
) x
WHERE TRY_CONVERT(INT, id_producto) IS NULL
   OR rn > 1
   OR TRY_CONVERT(INT, id_categoria) IS NULL;

INSERT INTO dbo.Producto (id_producto, nombre, id_categoria, marca, activo)
SELECT TRY_CONVERT(INT, id_producto),
       NULLIF(LTRIM(RTRIM(nombre)), ''),
       TRY_CONVERT(INT, id_categoria),
       NULLIF(LTRIM(RTRIM(marca)), ''),
       CASE WHEN UPPER(LTRIM(RTRIM(activo))) IN ('1','SI','TRUE') THEN 1
            WHEN UPPER(LTRIM(RTRIM(activo))) IN ('0','NO','FALSE') THEN 0
            ELSE NULL END
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_producto ORDER BY (SELECT 1)) AS rn
    FROM dbo.stg_producto
) x
WHERE TRY_CONVERT(INT, id_producto) IS NOT NULL
  AND rn = 1;

/* Pedido */
INSERT INTO dbo.err_pedido (id_pedido, id_cliente, fecha, canal, estado, ciudad_entrega, motivo_error)
SELECT id_pedido, id_cliente, fecha, canal, estado, ciudad_entrega,
       CASE
           WHEN TRY_CONVERT(INT, id_pedido) IS NULL THEN 'id_pedido no numerico'
           WHEN TRY_CONVERT(INT, id_cliente) IS NULL THEN 'id_cliente no numerico'
           WHEN COALESCE(TRY_CONVERT(DATE, fecha), TRY_CONVERT(DATE, fecha, 103)) IS NULL THEN 'fecha invalida'
           WHEN rn > 1 THEN 'pedido duplicado'
           ELSE 'registro invalido'
       END
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_pedido ORDER BY (SELECT 1)) AS rn
    FROM dbo.stg_pedido
) x
WHERE TRY_CONVERT(INT, id_pedido) IS NULL
   OR TRY_CONVERT(INT, id_cliente) IS NULL
   OR COALESCE(TRY_CONVERT(DATE, fecha), TRY_CONVERT(DATE, fecha, 103)) IS NULL
   OR rn > 1;

INSERT INTO dbo.Pedido (id_pedido, id_cliente, fecha, canal, estado, ciudad_entrega)
SELECT TRY_CONVERT(INT, id_pedido),
       TRY_CONVERT(INT, id_cliente),
       COALESCE(TRY_CONVERT(DATE, fecha), TRY_CONVERT(DATE, fecha, 103)),
       UPPER(NULLIF(LTRIM(RTRIM(canal)), '')),
       UPPER(NULLIF(LTRIM(RTRIM(estado)), '')),
       NULLIF(LTRIM(RTRIM(ciudad_entrega)), '')
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_pedido ORDER BY (SELECT 1)) AS rn
    FROM dbo.stg_pedido
) x
WHERE TRY_CONVERT(INT, id_pedido) IS NOT NULL
  AND TRY_CONVERT(INT, id_cliente) IS NOT NULL
  AND COALESCE(TRY_CONVERT(DATE, fecha), TRY_CONVERT(DATE, fecha, 103)) IS NOT NULL
  AND rn = 1;

/* Detalle */
INSERT INTO dbo.err_detalle_pedido (id_detalle, id_pedido, id_producto, cantidad, precio_unitario, descuento_pct, motivo_error)
SELECT id_detalle, id_pedido, id_producto, cantidad, precio_unitario, descuento_pct,
       CASE
           WHEN TRY_CONVERT(INT, id_detalle) IS NULL THEN 'id_detalle no numerico'
           WHEN TRY_CONVERT(INT, id_pedido) IS NULL THEN 'id_pedido no numerico'
           WHEN TRY_CONVERT(INT, id_producto) IS NULL THEN 'id_producto no numerico'
           WHEN TRY_CONVERT(INT, cantidad) IS NULL THEN 'cantidad no numerica'
           WHEN TRY_CONVERT(DECIMAL(12,2), precio_unitario) IS NULL THEN 'precio no numerico'
           WHEN descuento_pct <> '' AND TRY_CONVERT(DECIMAL(8,4), descuento_pct) IS NULL THEN 'descuento no numerico'
           WHEN rn > 1 THEN 'detalle duplicado'
           ELSE 'registro invalido'
       END
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_detalle ORDER BY (SELECT 1)) AS rn
    FROM dbo.stg_detalle_pedido
) x
WHERE TRY_CONVERT(INT, id_detalle) IS NULL
   OR TRY_CONVERT(INT, id_pedido) IS NULL
   OR TRY_CONVERT(INT, id_producto) IS NULL
   OR TRY_CONVERT(INT, cantidad) IS NULL
   OR TRY_CONVERT(DECIMAL(12,2), precio_unitario) IS NULL
   OR (descuento_pct <> '' AND TRY_CONVERT(DECIMAL(8,4), descuento_pct) IS NULL)
   OR rn > 1;

INSERT INTO dbo.DetallePedido (id_detalle, id_pedido, id_producto, cantidad, precio_unitario, descuento_pct)
SELECT TRY_CONVERT(INT, id_detalle),
       TRY_CONVERT(INT, id_pedido),
       TRY_CONVERT(INT, id_producto),
       TRY_CONVERT(INT, cantidad),
       TRY_CONVERT(DECIMAL(12,2), precio_unitario),
       COALESCE(TRY_CONVERT(DECIMAL(8,4), NULLIF(descuento_pct,'')), 0)
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_detalle ORDER BY (SELECT 1)) AS rn
    FROM dbo.stg_detalle_pedido
) x
WHERE TRY_CONVERT(INT, id_detalle) IS NOT NULL
  AND TRY_CONVERT(INT, id_pedido) IS NOT NULL
  AND TRY_CONVERT(INT, id_producto) IS NOT NULL
  AND TRY_CONVERT(INT, cantidad) IS NOT NULL
  AND TRY_CONVERT(DECIMAL(12,2), precio_unitario) IS NOT NULL
  AND rn = 1;