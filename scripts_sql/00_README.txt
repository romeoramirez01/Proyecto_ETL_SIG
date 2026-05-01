GUIA COMPLETA PARA DESARROLLAR DATA MART DESDE CARGA MASIVA

Este paquete fue generado para desarrollar una guía simulando datos de procesos, pasándolo a un datamart.

Archivos de datos:
- stg_cliente.csv: 12000+ registros
- stg_categoria.csv: 10050+ registros
- stg_producto.csv: 15000+ registros
- stg_pedido.csv: 70000+ registros
- stg_detalle_pedido.csv: 250000+ registros

Todos los archivos de datos tienen más de 10 mil registros.

Flujo:
1. Crear staging
2. Cargar CSV con BULK INSERT
3. Separar errores en tablas err_*
4. Poblar transaccional imperfecto
5. Limpiar con Python
6. Construir Dimensiones y FactVentas
7. Ejecutar consultas de Data Mart