-- Inserts 

-- Insertar ciudades
INSERT INTO ciudad (nombre) VALUES
('Bucaramanga'),
('Cúcuta'),
('Barrancabermeja'),
('Floridablanca'),
('Piedecuesta');

-- Insertar sucursales
INSERT INTO sucursal (nombre, direccion, NIT, telefono, idCiudad) VALUES
('Sucursal Bucaramanga', 'Calle 123 #45-67', '900123456-7', '123456789', 1),
('Sucursal Cúcuta', 'Avenida 7 #89-01', '900234567-8', '234567890', 2),
('Sucursal Barrancabermeja', 'Carrera 10 #11-22', '900345678-9', '345678901', 3),
('Sucursal Floridablanca', 'Calle 5 #67-89', '900456789-0', '456789012', 4),
('Sucursal Piedecuesta', 'Avenida 3 #45-67', '900567890-1', '567890123', 5);

-- Insertar categorías
INSERT INTO categoria (nombre, descripcion) VALUES
('Electrónica', 'Dispositivos electrónicos y gadgets'),
('Muebles', 'Mobiliario para hogar y oficina'),
('Ropa', 'Prendas de vestir y accesorios'),
('Alimentos', 'Productos alimenticios y bebidas'),
('Herramientas', 'Equipos y herramientas para construcción');

-- Insertar productos
INSERT INTO productos (nombre, idCategoria, precio, stock) VALUES
('Smartphone XYZ', 1, 499.99, 50),
('Sofa Comfort', 2, 299.99, 20),
('Camisa Polo', 3, 19.99, 100),
('Cereal Integral', 4, 3.99, 4),
('Taladro Eléctrico', 5, 49.99, 30);


-- Insertar proveedores
INSERT INTO proveedor (nombre, telefono, idSucursal) VALUES
('Proveedor A', '321654987', 1),
('Proveedor B', '654987321', 2),
('Proveedor C', '987321654', 3),
('Proveedor D', '123456789', 4),
('Proveedor E', '234567890', 5);

-- Insertar relaciones proveedor-producto
INSERT INTO proveedor_producto (idProductos, idProveedor) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insertar historial de compras
INSERT INTO historial_compra (fecha, valorTotal, idProveedor) VALUES
('2025-04-01', 1000.00, 1),
('2025-04-02', 1500.00, 2),
('2025-04-03', 2000.00, 3),
('2025-04-04', 2500.00, 4),
('2025-04-05', 3000.00, 5);

-- Insertar detalles de compras
INSERT INTO detalle_historial_compra (idHistorial, idProducto, cantidad, precio_compra) VALUES
(1, 1, 10, 450.00),
(2, 2, 15, 280.00),
(3, 3, 20, 18.00),
(4, 4, 25, 3.50),
(5, 5, 30, 45.00);
