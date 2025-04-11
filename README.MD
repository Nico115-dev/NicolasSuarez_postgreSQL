# 📦 TechZone - Sistema de Gestión de Inventario y Ventas

**TechZone** es una empresa dedicada a la venta de productos tecnológicos como laptops, teléfonos, accesorios y componentes. Este proyecto tiene como objetivo centralizar y automatizar la gestión de inventario, ventas, proveedores y clientes mediante una base de datos relacional en PostgreSQL.

---

## 📚 Tabla de Contenidos

- [🔧 Tecnologías](#-tecnologías)
- [🎯 Objetivos del Sistema](#-objetivos-del-sistema)
- [📁 Estructura de la Base de Datos](#-estructura-de-la-base-de-datos)
  - [Tablas Principales](#tablas-principales)
- [🚀 Cómo usar](#-cómo-usar)
- [📈 Consultas útiles](#-consultas-útiles)
- [📌 Notas adicionales](#-notas-adicionales)

---

## 🔧 Tecnologías

- PostgreSQL 14+
- SQL puro (DDL)
- PgAdmin o cualquier cliente SQL compatible

---

## 🎯 Objetivos del Sistema

1. Automatizar el control de inventario por sucursal.
2. Registrar compras de clientes y compras a proveedores.
3. Mantener un historial completo de ventas y abastecimiento.
4. Gestionar información de proveedores, empleados y sucursales.
5. Obtener reportes de productos más vendidos, stock disponible, etc.

---

## 📁 Estructura de la Base de Datos

### Tablas Principales

| Tabla                      | Descripción                                                  |
|---------------------------|--------------------------------------------------------------|
| `ciudad`                  | Registra las ciudades donde hay sucursales.                  |
| `sucursal`                | Contiene datos de sucursales de TechZone.                    |
| `categoria`               | Categorías de productos (Ej: Teléfonos, Laptops).            |
| `productos`               | Información de los productos en venta.                       |
| `proveedor`               | Datos de proveedores que suministran productos.              |
| `proveedor_producto`      | Relación muchos-a-muchos entre productos y proveedores.       |
| `historial_compra`        | Registra compras hechas a proveedores.                       |
| `detalle_historial_compra`| Detalles de productos incluidos en cada compra a proveedor.  |
| `cliente`                 | Datos personales de los clientes.                            |
| `compras_cliente`         | Historial de compras realizadas por clientes.                |
| `detalle_compra_cliente`  | Productos adquiridos en cada compra de cliente.              |
| `inventario`              | Registra stock por producto y sucursal.                      |
| `empleado`                | Información de los empleados por sucursal.                   |

---

## 🚀 Cómo usar

1. Asegúrate de tener PostgreSQL instalado.
2. Crea una nueva base de datos:
   ```sql
   CREATE DATABASE techzone;
