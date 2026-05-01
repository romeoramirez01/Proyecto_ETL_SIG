USE BD_RETAIL_OLTP;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ETL_DataMart
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM dbo.FactVentas;
        DELETE FROM dbo.DimFecha;
        DELETE FROM dbo.DimProducto;
        DELETE FROM dbo.DimCliente;

        INSERT INTO dbo.DimCliente (
            id_cliente, nombre, ciudad, pais, segmento, fecha_registro
        )
        SELECT DISTINCT
            c.id_cliente,
            c.nombre,
            UPPER(LTRIM(RTRIM(ISNULL(c.ciudad, 'NO DEFINIDA')))),
            UPPER(LTRIM(RTRIM(ISNULL(c.pais, 'SV')))),
            UPPER(LTRIM(RTRIM(ISNULL(c.segmento, 'NO DEFINIDO')))),
            c.fecha_registro
        FROM dbo.Cliente c;

        INSERT INTO dbo.DimProducto (
            id_producto, producto, categoria, marca, activo
        )
        SELECT DISTINCT
            p.id_producto,
            UPPER(LTRIM(RTRIM(ISNULL(p.nombre, 'PRODUCTO SIN NOMBRE')))),
            UPPER(LTRIM(RTRIM(ISNULL(cat.nombre, 'CATEGORIA NO DEFINIDA')))),
            UPPER(LTRIM(RTRIM(ISNULL(p.marca, 'SIN MARCA')))),
            p.activo
        FROM dbo.Producto p
        LEFT JOIN dbo.Categoria cat
            ON p.id_categoria = cat.id_categoria;

        IF OBJECT_ID('tempdb..#PedidoOK') IS NOT NULL DROP TABLE #PedidoOK;
        IF OBJECT_ID('tempdb..#DetalleOK') IS NOT NULL DROP TABLE #DetalleOK;

        SELECT
            p.id_pedido,
            p.id_cliente,
            p.fecha,
            UPPER(LTRIM(RTRIM(ISNULL(p.canal, 'SIN CANAL')))) AS canal,
            UPPER(LTRIM(RTRIM(ISNULL(p.estado, 'SIN ESTADO')))) AS estado,
            UPPER(LTRIM(RTRIM(ISNULL(p.ciudad_entrega, 'NO DEFINIDA')))) AS ciudad_entrega
        INTO #PedidoOK
        FROM dbo.Pedido p
        WHERE UPPER(LTRIM(RTRIM(ISNULL(p.estado, 'SIN ESTADO')))) <> 'ANULADO'
          AND EXISTS (
                SELECT 1
                FROM dbo.Cliente c
                WHERE c.id_cliente = p.id_cliente
          );

        SELECT
            d.id_detalle,
            d.id_pedido,
            d.id_producto,
            d.cantidad,
            d.precio_unitario,
            ISNULL(d.descuento_pct, 0) AS descuento_pct
        INTO #DetalleOK
        FROM dbo.DetallePedido d
        WHERE d.cantidad > 0
          AND d.precio_unitario > 0
          AND ISNULL(d.descuento_pct, 0) BETWEEN 0 AND 1
          AND EXISTS (
                SELECT 1
                FROM #PedidoOK p
                WHERE p.id_pedido = d.id_pedido
          )
          AND EXISTS (
                SELECT 1
                FROM dbo.Producto pr
                WHERE pr.id_producto = d.id_producto
          );

        INSERT INTO dbo.DimFecha (
            id_fecha, fecha, anio, mes, dia, trimestre
        )
        SELECT DISTINCT
            CAST(CONVERT(VARCHAR(8), p.fecha, 112) AS INT),
            p.fecha,
            YEAR(p.fecha),
            MONTH(p.fecha),
            DAY(p.fecha),
            DATEPART(QUARTER, p.fecha)
        FROM #PedidoOK p;

        INSERT INTO dbo.FactVentas (
            id_detalle, id_fecha, id_cliente, id_producto, id_pedido,
            canal, estado, ciudad_entrega,
            cantidad, precio_unitario, descuento_pct,
            subtotal, descuento_valor, total_neto
        )
        SELECT
            d.id_detalle,
            CAST(CONVERT(VARCHAR(8), p.fecha, 112) AS INT),
            p.id_cliente,
            d.id_producto,
            d.id_pedido,
            p.canal,
            p.estado,
            p.ciudad_entrega,
            d.cantidad,
            d.precio_unitario,
            d.descuento_pct,
            ROUND(d.cantidad * d.precio_unitario, 2),
            ROUND((d.cantidad * d.precio_unitario) * d.descuento_pct, 2),
            ROUND((d.cantidad * d.precio_unitario) - ((d.cantidad * d.precio_unitario) * d.descuento_pct), 2)
        FROM #DetalleOK d
        INNER JOIN #PedidoOK p
            ON d.id_pedido = p.id_pedido;

        DROP TABLE #DetalleOK;
        DROP TABLE #PedidoOK;

        COMMIT TRANSACTION;
        PRINT 'ETL completado correctamente';
    END TRY
    BEGIN CATCH
        IF OBJECT_ID('tempdb..#DetalleOK') IS NOT NULL DROP TABLE #DetalleOK;
        IF OBJECT_ID('tempdb..#PedidoOK') IS NOT NULL DROP TABLE #PedidoOK;

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        PRINT 'Error en el ETL';
        PRINT ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO