-- Tabla Ciudad
CREATE TABLE ciudad (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL
);

-- Tabla Sucursal
CREATE TABLE sucursal (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    direccion VARCHAR(50) NOT NULL,
    NIT VARCHAR(20) UNIQUE,
    telefono VARCHAR(15) NOT NULL,
    idCiudad INTEGER,
    FOREIGN KEY (idCiudad) REFERENCES ciudad(id)
);

-- Tabla Categoria
CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    descripcion VARCHAR(100)
);

-- Tabla Productos
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    idCategoria INTEGER,
    precio NUMERIC(10,2) NOT NULL,
    stock INTEGER DEFAULT 0,
    FOREIGN KEY (idCategoria) REFERENCES categoria(id)
);

-- Tabla Proveedor
CREATE TABLE proveedor (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    idSucursal INTEGER,
    FOREIGN KEY (idSucursal) REFERENCES sucursal(id)
);

-- Tabla proveedor_producto (relación muchos a muchos)
CREATE TABLE proveedor_producto (
    id SERIAL PRIMARY KEY,
    idProductos INTEGER,
    idProveedor INTEGER,
    FOREIGN KEY (idProductos) REFERENCES productos(id),
    FOREIGN KEY (idProveedor) REFERENCES proveedor(id)
);

-- Tabla Historial de Compras a Proveedores
CREATE TABLE historial_compra (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    valorTotal NUMERIC(10,2) NOT NULL,
    idProveedor INTEGER,
    FOREIGN KEY (idProveedor) REFERENCES proveedor(id)
);

-- Detalles de productos comprados en historial_compra (productos involucrados)
CREATE TABLE detalle_historial_compra (
    id SERIAL PRIMARY KEY,
    idHistorial INTEGER,
    idProducto INTEGER,
    cantidad INTEGER NOT NULL,
    precio_compra NUMERIC(10,2),
    FOREIGN KEY (idHistorial) REFERENCES historial_compra(id),
    FOREIGN KEY (idProducto) REFERENCES productos(id)
);

-- Tabla Cliente
CREATE TABLE cliente (
    documento INTEGER PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    apellidos VARCHAR(45) NOT NULL,
    email VARCHAR(50) UNIQUE,
    direccion VARCHAR(50) NOT NULL
);

-- Tabla Compras Cliente
CREATE TABLE compras_cliente (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    idCliente INTEGER,
    total NUMERIC(10,2),
    FOREIGN KEY (idCliente) REFERENCES cliente(documento)
);

-- Detalles de productos comprados por cliente
CREATE TABLE detalle_compra_cliente (
    id SERIAL PRIMARY KEY,
    idCompra INTEGER,
    idProducto INTEGER,
    cantidad INTEGER NOT NULL,
    precio_unitario NUMERIC(10,2),
    FOREIGN KEY (idCompra) REFERENCES compras_cliente(id),
    FOREIGN KEY (idProducto) REFERENCES productos(id)
);

-- Tabla Inventario
CREATE TABLE inventario (
    id SERIAL PRIMARY KEY,
    idProducto INTEGER,
    cantidad INTEGER NOT NULL,
    idSucursal INTEGER,
    FOREIGN KEY (idProducto) REFERENCES productos(id),
    FOREIGN KEY (idSucursal) REFERENCES sucursal(id)
);

-- Tabla Empleado
CREATE TABLE empleado (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    apellidos VARCHAR(45) NOT NULL,
    email VARCHAR(50) UNIQUE,
    telefono VARCHAR(15),
    cargo VARCHAR(45),
    idSucursal INTEGER,
    FOREIGN KEY (idSucursal) REFERENCES sucursal(id)
);
