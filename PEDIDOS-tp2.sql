/* 
    Crear un bloque PL SQL que permita, mediante una transacción, realizar el registro de un pedido con su detalle (renglones).
    El proceso debe contemplar la actualización del stock de los productos pedidos. En caso de producirse un error, la transacción debe ser cancelada.
*/ 
-- Crear secuencia para Pedidos
CREATE SEQUENCE SEQ_PEDIDOS
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

DECLARE
    v_pedido_id NUMBER;
    v_producto_id NUMBER;
    v_cantidad NUMBER;
    v_stock_actual NUMBER;
BEGIN
    SAVEPOINT inicio_transaccion; -- Crear un punto de guardado para la transacción
    
    -- Datos del pedido
    v_pedido_id := SEQ_PEDIDOS.nextval; -- Suponiendo que tienes una secuencia para generar IDs de pedido
    
    -- Bucle para ingresar detalles del pedido
    FOR detalle IN (SELECT renglon, idproducto, cantidad FROM DetallePedidos WHERE NumeroPedido = v_pedido_id)
    LOOP
        v_producto_id := detalle.idproducto;
        v_cantidad := detalle.cantidad;
        
        -- Obtener el stock actual del producto
        SELECT stock INTO v_stock_actual FROM Productos WHERE idproducto = v_producto_id;
        
        -- Verificar si hay suficiente stock
        IF v_stock_actual >= v_cantidad THEN
            -- Actualizar el stock
            UPDATE Productos SET stock = stock - v_cantidad WHERE idproducto = v_producto_id;
        ELSE
            ROLLBACK TO inicio_transaccion; -- Revertir a la transacción inicial en caso de error
            RAISE_APPLICATION_ERROR(-20001, 'No hay suficiente stock para el producto ' || v_producto_id);
        END IF;
    END LOOP;
    
    COMMIT; -- Confirmar la transacción si todo es exitoso
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- Revertir la transacción en caso de error general
        RAISE; -- Propagar la excepción para manejo externo si es necesario
END;
-- revisar
------------------------------------------------------------------------------------------------------------------------------------------------
 /*
    Crear un procedimiento almacenado que permita anular un pedido confirmado. 
    El proceso de anulación debe actualizar los stocks de los artículos del pedido.
 */
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE AnularPedido(p_numero_pedido IN NUMBER) IS
BEGIN
    -- Procedimiento para anular un pedido confirmado y actualizar los stocks.

    -- Verificar si el pedido está confirmado
    DECLARE
        v_estado_pedido VARCHAR2(50);
    BEGIN
    -- Declaramos una variable v_estado_pedido para almacenar el estado del pedido.
        SELECT Estado INTO v_estado_pedido FROM Pedidos WHERE NumeroPedido = p_numero_pedido;
        -- Obtenemos el estado del pedido correspondiente al número de pedido dado.
        
        IF v_estado_pedido <> 'Entregado' THEN
            RAISE_APPLICATION_ERROR(-20001, 'El pedido no está entregado, no se puede anular.');
            -- Si el estado no es "Confirmado", generamos un error indicando que no se puede anular.
        END IF;
    END;

    -- Anular el pedido
    UPDATE Pedidos SET Estado = 'Anulado' WHERE NumeroPedido = p_numero_pedido;
     -- Iteramos a través de los detalles del pedido y actualizamos los stocks de los productos.
    -- Actualizar los stocks de los artículos del pedido
    FOR detalle IN (SELECT idproducto, cantidad FROM DetallePedidos WHERE NumeroPedido = p_numero_pedido)
    LOOP
        UPDATE Productos SET stock = stock + detalle.cantidad WHERE idproducto = detalle.idproducto;
    END LOOP;

    COMMIT;-- Confirmar los cambios en la base de datos
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'No se encontró el pedido con el número especificado.');
        -- Si no se encuentra el pedido, generamos un error indicando que no se encontró.
    WHEN OTHERS THEN
        ROLLBACK; -- Revertir la transacción en caso de error general
        RAISE;-- Propagar la excepción para manejo externo si es necesario
END AnularPedido;

EXECUTE anularpedido(3);

select * from pedidos;
------------------------------------------------------------------------------------------------------------------------------------------------
/*
    Crear una tabla denominada log (idlog, numeroPedido, FechaAnulacion). 
*/
CREATE TABLE log (
    idlog NUMBER PRIMARY KEY,
    numeroPedido NUMBER,
    FechaAnulacion DATE,
    FOREIGN KEY (numeroPedido) REFERENCES Pedidos(NumeroPedido)
);
------------------------------------------------------------------------------------------------------------------------------------------------
/*
    Crear un trigger que permita, al momento de anularse un pedido, registrar en la tabla log, el número de pedido anulado y la fecha de anulación.
*/
-- Crear la secuencia para la tabla log
CREATE SEQUENCE secuencia_log
    START WITH 1
    INCREMENT BY 1;
-- Esta sección crea una secuencia llamada "secuencia_log". Una secuencia es un objeto
-- que genera números únicos en orden consecutivo. Aquí, comenzamos en 1 y aumentamos
-- el valor en 1 cada vez que se solicita un número.

-- Crear el trigger para registrar en la tabla log al anular un pedido
CREATE OR REPLACE TRIGGER AnularPedidoTrigger
AFTER UPDATE OF Estado ON Pedidos
FOR EACH ROW
DECLARE
BEGIN
    -- Este trigger se activará después de que se actualice el campo "Estado" en la tabla "Pedidos".
    IF :NEW.Estado = 'Anulado' AND :OLD.Estado <> 'Anulado' THEN
    -- Si el nuevo estado es "Anulado" y el estado anterior no era "Anulado":
        INSERT INTO log (idlog, numeroPedido, FechaAnulacion)
        VALUES (secuencia_log.nextval, :NEW.NumeroPedido, SYSDATE);
        -- Insertamos un nuevo registro en la tabla "log". Utilizamos "secuencia_log.nextval"
        -- para obtener un nuevo número de secuencia único. Tomamos el número de pedido nuevo (:NEW.NumeroPedido)
        -- y la fecha actual (SYSDATE) y los insertamos en la tabla "log".
    END IF;
END;
UPDATE Pedidos SET Estado = 'Anulado' WHERE NumeroPedido = 10;
SELECT * FROM log;
select * from pedidos;
------------------------------------------------------------------------------------------------------------------------------------------------
/*
    Crear un procedimiento almacenado que permita actualizar el precio de los artículos de un determinado origen en un determinado porcentaje.
*/
CREATE OR REPLACE PROCEDURE ActualizarPrecioPorcentaje(
    p_origen IN VARCHAR2,
    p_porcentaje IN NUMBER
) IS
BEGIN
    -- Este procedimiento actualiza el precio de los productos de un origen específico
    -- en un porcentaje determinado.

    -- Actualizar el precio de los productos del origen especificado
    UPDATE Productos
    SET PrecioUnitario = PrecioUnitario * (1 + p_porcentaje / 100) -- Multiplicamos el precio por (1 + porcentaje/100)
    WHERE Origen = p_origen; -- Aplicamos la actualización solo a los productos del origen indicado

    COMMIT; -- Confirmar los cambios en la base de datos
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- En caso de error, revertir los cambios realizados
        RAISE; -- Propagar la excepción para manejo externo si es necesario
END ActualizarPrecioPorcentaje;

EXECUTE ActualizarPrecioPorcentaje('Local', 8);

SELECT * FROM productos;
--------------------------------------------------------------------------------------------------------------------------------------------