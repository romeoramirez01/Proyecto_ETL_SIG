SELECT d.anio, d.mes, SUM(f.total_neto) AS ventas
FROM FactVentas f
JOIN DimFecha d ON d.id_fecha = f.id_fecha
GROUP BY d.anio, d.mes
ORDER BY d.anio, d.mes;

SELECT TOP 20 p.producto, p.categoria, SUM(f.total_neto) AS ventas
FROM FactVentas f
JOIN DimProducto p ON p.id_producto = f.id_producto
GROUP BY p.producto, p.categoria
ORDER BY ventas DESC;

SELECT c.ciudad, SUM(f.total_neto) AS ventas
FROM FactVentas f
JOIN DimCliente c ON c.id_cliente = f.id_cliente
GROUP BY c.ciudad
ORDER BY ventas DESC;

SELECT TOP 25 c.nombre, c.segmento, SUM(f.total_neto) AS total_facturado
FROM FactVentas f
JOIN DimCliente c ON c.id_cliente = f.id_cliente
GROUP BY c.nombre, c.segmento
ORDER BY total_facturado DESC;