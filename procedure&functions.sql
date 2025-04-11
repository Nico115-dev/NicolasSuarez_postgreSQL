-- Procesos con funciones

-- 1. Un procedimiento almacenado para registrar una venta.
CREATE OR REPLACE PROCEDURE registrar_venta(
    p_id_cliente INTEGER,
    p_productos jsonb, .
    p_total NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_compra INTEGER;
    v_id_producto INTEGER;
    v_cantidad INTEGER;
    v_precio_unitario NUMERIC;
    v_nuevo_stock INTEGER;
BEGIN

    INSERT INTO compras_cliente (fecha, idCliente, total)
    VALUES (CURRENT_DATE, p_id_cliente, p_total)
    RETURNING id INTO v_id_compra;
    FOR i IN 0..jsonb_array_length(p_productos) - 1 LOOP
        v_id_producto := (p_productos -> i ->> 'idProducto')::INTEGER;
        v_cantidad := (p_productos -> i ->> 'cantidad')::INTEGER;
        SELECT precio INTO v_precio_unitario
        FROM productos
        WHERE id = v_id_producto;
        INSERT INTO detalle_compra_cliente (idCompra, idProducto, cantidad, precio_unitario)
        VALUES (v_id_compra, v_id_producto, v_cantidad, v_precio_unitario);
        UPDATE inventario
        SET cantidad = cantidad - v_cantidad
        WHERE idProducto = v_id_producto AND idSucursal = (SELECT idSucursal FROM empleado WHERE id = (SELECT idSucursal FROM empleado WHERE idCliente = p_id_cliente LIMIT 1));
    END LOOP;
    COMMIT;
END;
$$;


-- 2. Validar que el cliente exista
CREATE OR REPLACE PROCEDURE registrar_venta(
    p_id_cliente INTEGER,
    p_productos jsonb, 
    p_total NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_compra INTEGER;
    v_id_producto INTEGER;
    v_cantidad INTEGER;
    v_precio_unitario NUMERIC;
    v_nuevo_stock INTEGER;
    v_cliente_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM cliente WHERE documento = p_id_cliente) INTO v_cliente_existe;

    IF NOT v_cliente_existe THEN
        RAISE EXCEPTION 'El cliente con documento % no existe.', p_id_cliente;
    END IF;

    INSERT INTO compras_cliente (fecha, idCliente, total)
    VALUES (CURRENT_DATE, p_id_cliente, p_total)
    RETURNING id INTO v_id_compra;

    FOR i IN 0..jsonb_array_length(p_productos) - 1 LOOP
        v_id_producto := (p_productos -> i ->> 'idProducto')::INTEGER;
        v_cantidad := (p_productos -> i ->> 'cantidad')::INTEGER;

        SELECT precio INTO v_precio_unitario
        FROM productos
        WHERE id = v_id_producto;

        INSERT INTO detalle_compra_cliente (idCompra, idProducto, cantidad, precio_unitario)
        VALUES (v_id_compra, v_id_producto, v_cantidad, v_precio_unitario);

        UPDATE inventario
        SET cantidad = cantidad - v_cantidad
        WHERE idProducto = v_id_producto AND idSucursal = (SELECT idSucursal FROM empleado WHERE id = (SELECT idSucursal FROM empleado WHERE idCliente = p_id_cliente LIMIT 1));
    END LOOP;
    COMMIT;
END;
$$;

-- 3. Verificar que el stock sea suficiente antes de procesar la venta.
CREATE OR REPLACE PROCEDURE registrar_venta(
    p_id_cliente INTEGER,
    p_productos jsonb,  
    p_total NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_compra INTEGER;
    v_id_producto INTEGER;
    v_cantidad INTEGER;
    v_precio_unitario NUMERIC;
    v_stock_actual INTEGER;
    v_cliente_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM cliente WHERE documento = p_id_cliente) INTO v_cliente_existe;

    IF NOT v_cliente_existe THEN
        RAISE EXCEPTION 'El cliente con documento % no existe.', p_id_cliente;
    END IF;

    BEGIN

        INSERT INTO compras_cliente (fecha, idCliente, total)
        VALUES (CURRENT_DATE, p_id_cliente, p_total)
        RETURNING id INTO v_id_compra;

        FOR i IN 0..jsonb_array_length(p_productos) - 1 LOOP
            v_id_producto := (p_productos -> i ->> 'idProducto')::INTEGER;
            v_cantidad := (p_productos -> i ->> 'cantidad')::INTEGER;

            SELECT cantidad INTO v_stock_actual
            FROM inventario
            WHERE idProducto = v_id_producto
            AND idSucursal = (SELECT idSucursal FROM empleado WHERE id = (SELECT idSucursal FROM empleado WHERE idCliente = p_id_cliente LIMIT 1));

            IF v_stock_actual < v_cantidad THEN
                RAISE EXCEPTION 'No hay suficiente stock para el producto % (Stock disponible: %, cantidad solicitada: %)', 
                                 v_id_producto, v_stock_actual, v_cantidad;
            END IF;

            SELECT precio INTO v_precio_unitario
            FROM productos
            WHERE id = v_id_producto;

            INSERT INTO detalle_compra_cliente (idCompra, idProducto, cantidad, precio_unitario)
            VALUES (v_id_compra, v_id_producto, v_cantidad, v_precio_unitario);

            UPDATE inventario
            SET cantidad = cantidad - v_cantidad
            WHERE idProducto = v_id_producto
            AND idSucursal = (SELECT idSucursal FROM empleado WHERE id = (SELECT idSucursal FROM empleado WHERE idCliente = p_id_cliente LIMIT 1));
        END LOOP;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END;
END;
$$;


-- 4. Si no hay stock suficiente, Notificar por medio de un mensaje en consola usando RAISE.
CREATE OR REPLACE PROCEDURE registrar_venta(
    p_id_cliente INTEGER,
    p_productos jsonb, 
    p_total NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_compra INTEGER;
    v_id_producto INTEGER;
    v_cantidad INTEGER;
    v_precio_unitario NUMERIC;
    v_stock_actual INTEGER;
    v_cliente_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM cliente WHERE documento = p_id_cliente) INTO v_cliente_existe;

    IF NOT v_cliente_existe THEN
        RAISE EXCEPTION 'El cliente con documento % no existe.', p_id_cliente;
    END IF;

    BEGIN

        INSERT INTO compras_cliente (fecha, idCliente, total)
        VALUES (CURRENT_DATE, p_id_cliente, p_total)
        RETURNING id INTO v_id_compra;

        FOR i IN 0..jsonb_array_length(p_productos) - 1 LOOP

            v_id_producto := (p_productos -> i ->> 'idProducto')::INTEGER;
            v_cantidad := (p_productos -> i ->> 'cantidad')::INTEGER;

            SELECT cantidad INTO v_stock_actual
            FROM inventario
            WHERE idProducto = v_id_producto
            AND idSucursal = (SELECT idSucursal FROM empleado WHERE id = (SELECT idSucursal FROM empleado WHERE idCliente = p_id_cliente LIMIT 1));

            IF v_stock_actual < v_cantidad THEN
                RAISE NOTICE 'No hay suficiente stock para el producto % (Stock disponible: %, cantidad solicitada: %)', 
                             v_id_producto, v_stock_actual, v_cantidad;
            END IF;

            SELECT precio INTO v_precio_unitario
            FROM productos
            WHERE id = v_id_producto;

            INSERT INTO detalle_compra_cliente (idCompra, idProducto, cantidad, precio_unitario)
            VALUES (v_id_compra, v_id_producto, v_cantidad, v_precio_unitario);

            UPDATE inventario
            SET cantidad = cantidad - v_cantidad
            WHERE idProducto = v_id_producto
            AND idSucursal = (SELECT idSucursal FROM empleado WHERE id = (SELECT idSucursal FROM empleado WHERE idCliente = p_id_cliente LIMIT 1));
        END LOOP;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END;

END;
$$;

-- 5. Si hay stock, se realiza el registro de la venta.
CREATE OR REPLACE PROCEDURE registrar_venta(
    p_id_cliente INTEGER,
    p_productos jsonb,
    p_total NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_compra INTEGER;
    v_id_producto INTEGER;
    v_cantidad INTEGER;
    v_precio_unitario NUMERIC;
    v_stock_actual INTEGER;
    v_cliente_existe BOOLEAN;
    v_stock_insuficiente BOOLEAN := FALSE; 
BEGIN

    SELECT EXISTS(SELECT 1 FROM cliente WHERE documento = p_id_cliente) INTO v_cliente_existe;

    IF NOT v_cliente_existe THEN
        RAISE EXCEPTION 'El cliente con documento % no existe.', p_id_cliente;
    END IF;

    BEGIN
        FOR i IN 0..jsonb_array_length(p_productos) - 1 LOOP
            v_id_producto := (p_productos -> i ->> 'idProducto')::INTEGER;
            v_cantidad := (p_productos -> i ->> 'cantidad')::INTEGER;

            SELECT cantidad INTO v_stock_actual
            FROM inventario
            WHERE idProducto = v_id_producto
            AND idSucursal = (SELECT idSucursal FROM empleado WHERE id = (SELECT idSucursal FROM empleado WHERE idCliente = p_id_cliente LIMIT 1));

            IF v_stock_actual < v_cantidad THEN
                RAISE NOTICE 'No hay suficiente stock para el producto % (Stock disponible: %, cantidad solicitada: %)', 
                             v_id_producto, v_stock_actual, v_cantidad;
                v_stock_insuficiente := TRUE; 
            END IF;
        END LOOP;

        IF v_stock_insuficiente THEN
            RAISE NOTICE 'No se puede procesar la venta debido a stock insuficiente en alguno de los productos.';
            RETURN;
        END IF;

        INSERT INTO compras_cliente (fecha, idCliente, total)
        VALUES (CURRENT_DATE, p_id_cliente, p_total)
        RETURNING id INTO v_id_compra;

        FOR i IN 0..jsonb_array_length(p_productos) - 1 LOOP
            v_id_producto := (p_productos -> i ->> 'idProducto')::INTEGER;
            v_cantidad := (p_productos -> i ->> 'cantidad')::INTEGER;

            SELECT precio INTO v_precio_unitario
            FROM productos
            WHERE id = v_id_producto;

            INSERT INTO detalle_compra_cliente (idCompra, idProducto, cantidad, precio_unitario)
            VALUES (v_id_compra, v_id_producto, v_cantidad, v_precio_unitario);

            UPDATE inventario
            SET cantidad = cantidad - v_cantidad
            WHERE idProducto = v_id_producto
            AND idSucursal = (SELECT idSucursal FROM empleado WHERE id = (SELECT idSucursal FROM empleado WHERE idCliente = p_id_cliente LIMIT 1));
        END LOOP;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END;

END;
$$;
