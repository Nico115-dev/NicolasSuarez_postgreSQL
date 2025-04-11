-- Queries 


-- 1. Listar los productos con stock menor a 5 unidades
SELECT 
    id,
    nombre,
    stock,
    precio
FROM 
    productos
WHERE 
    stock < 5;


-- 2. Calcular ventas totales de un mes específico.
SELECT 
    SUM(total) AS ventas_totales
FROM 
    compras_cliente
WHERE 
    fecha BETWEEN '2025-04-01' AND '2025-04-03';


-- 3.  Obtener el cliente con más compras realizadas.
SELECT 
    c.documento,
    c.nombre,
    c.apellidos,
    COUNT(cc.id) AS total_compras
FROM 
    cliente c
JOIN 
    compras_cliente cc ON c.documento = cc.idCliente
GROUP BY 
    c.documento, c.nombre, c.apellidos
ORDER BY 
    total_compras DESC
LIMIT 1;


-- 4. Listar los 5 productos más vendidos.
SELECT 
    p.id,
    p.nombre,
    SUM(dcc.cantidad) AS total_vendido
FROM 
    detalle_compra_cliente dcc
JOIN 
    productos p ON dcc.idProducto = p.id
GROUP BY 
    p.id, p.nombre
ORDER BY 
    total_vendido DESC
LIMIT 5;


-- 5.  Consultar ventas realizadas en un rango de fechas de tres Días 
SELECT 
    id,
    fecha,
    idCliente,
    total
FROM 
    compras_cliente
WHERE 
    fecha BETWEEN '2025-03-10' AND '2025-03-12';

-- 5.  Consultar ventas realizadas en un rango de un mes
SELECT 
    id,
    fecha,
    idCliente,
    total
FROM 
    compras_cliente
WHERE 
    fecha >= '2025-04-01' AND fecha < '2025-05-01';


-- 6. Identificar clientes que no han comprado en los últimos 6 meses.
SELECT 
    c.documento,
    c.nombre,
    c.apellidos,
    c.email
FROM 
    cliente c
LEFT JOIN 
    compras_cliente cc ON c.documento = cc.idCliente
GROUP BY 
    c.documento, c.nombre, c.apellidos, c.email
HAVING 
    MAX(cc.fecha) < CURRENT_DATE - INTERVAL '6 months' OR MAX(cc.fecha) IS NULL;
