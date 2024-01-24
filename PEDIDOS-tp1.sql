-- Crear tabla Clientes
CREATE TABLE Clientes (
    idcliente NUMBER PRIMARY KEY,
    Apellido VARCHAR2(50),
    Nombres VARCHAR2(50),
    Dirección VARCHAR2(100),
    mail VARCHAR2(100)
);
DESCRIBE Clientes;
SELECT * FROM clientes;

-- Crear tabla Proveedores
CREATE TABLE Proveedores (
    idproveedor NUMBER PRIMARY KEY,
    NombreProveedor VARCHAR2(100),
    Dirección VARCHAR2(100),
    email VARCHAR2(100)
);
DESCRIBE Proveedores;
SELECT * FROM proveedores;

-- Crear tabla Vendedor
CREATE TABLE Vendedor (
    idvendedor NUMBER PRIMARY KEY,
    Apellido VARCHAR2(50),
    Nombres VARCHAR2(50),
    email VARCHAR2(100),
    comisión NUMBER
);
DESCRIBE Vendedor;
SELECT * FROM vendedor;

-- Crear tabla Productos
CREATE TABLE Productos (
    idproducto NUMBER PRIMARY KEY,
    Descripción VARCHAR2(200),
    PrecioUnitario NUMBER,
    Stock NUMBER,
    StockMax NUMBER,
    StockMin NUMBER,
    idproveedor NUMBER,
    origen VARCHAR2(50),
    FOREIGN KEY (idproveedor) REFERENCES Proveedores(idproveedor)
);
DESCRIBE Productos;
SELECT * FROM productos;

-- Crear tabla Pedidos
CREATE TABLE Pedidos (
    NumeroPedido NUMBER PRIMARY KEY,
    idcliente NUMBER,
    idvendedor NUMBER,
    fecha DATE,
    Estado VARCHAR2(50),
    FOREIGN KEY (idcliente) REFERENCES Clientes(idcliente),
    FOREIGN KEY (idvendedor) REFERENCES Vendedor(idvendedor)
);
DESCRIBE Pedidos;
SELECT * FROM pedidos;

-- Crear tabla DetallePedidos
CREATE TABLE DetallePedidos (
    NumeroPedido NUMBER,
    renglon NUMBER,
    idproducto NUMBER,
    cantidad NUMBER,
    PrecioUnitario NUMBER,
    Total NUMBER,
    PRIMARY KEY (NumeroPedido, renglon),
    FOREIGN KEY (NumeroPedido) REFERENCES Pedidos(NumeroPedido),
    FOREIGN KEY (idproducto) REFERENCES Productos(idproducto)
);
DESCRIBE DetallePedidos;
SELECT * FROM detallepedidos;


INSERT INTO Clientes (idcliente, Apellido, Nombres, Dirección, mail)
VALUES (1, 'López', 'Juan', 'Calle 123', 'lopezjuan@email.com');
INSERT INTO Clientes (idcliente, Apellido, Nombres, Dirección, mail)
VALUES (2, 'Martínez', 'Ana', 'Avenida 456', 'martinezana@email.com');
INSERT INTO Clientes (idcliente, Apellido, Nombres, Dirección, mail)
VALUES (3, 'Alvarez', 'Ignacio', 'Moreno 846', 'alvarezjuan@email.com');
INSERT INTO Clientes (idcliente, Apellido, Nombres, Dirección, mail)
VALUES (4, 'Moreira', 'Jessica', 'Fransisco 589', 'moreirajessica@email.com');
INSERT INTO Clientes (idcliente, Apellido, Nombres, Dirección, mail)
VALUES (5, 'Avila', 'Daiana', 'Acoyte 454', 'aviladaiana@email.com');
INSERT INTO Clientes (idcliente, Apellido, Nombres, Dirección, mail)
VALUES (6, 'Monzon', 'Jorge', 'Rivadavia 864', 'aviladaiana@email.com');

-- Insertar datos en la tabla Proveedores
INSERT INTO Proveedores (idproveedor, NombreProveedor, Dirección, email)
VALUES (1, 'Proveedor A', 'Calle Proveedor 1', 'proveedora@email.com');
INSERT INTO Proveedores (idproveedor, NombreProveedor, Dirección, email)
VALUES (2, 'Proveedor B', 'Avenida Proveedor 2', 'proveedorb@email.com');
INSERT INTO Proveedores (idproveedor, NombreProveedor, Dirección, email)
VALUES (3, 'Proveedor C', 'Avenida Proveedor 3', 'proveedorc@email.com');

INSERT INTO Vendedor (idvendedor, Apellido, Nombres, email, comisión)
VALUES (1, 'González', 'Pedro', 'gonzalezpedro@email.com', 0.1);
INSERT INTO Vendedor (idvendedor, Apellido, Nombres, email, comisión)
VALUES (2, 'Rodríguez', 'María', 'rofriguezmaria@email.com', 0.15);
INSERT INTO Vendedor (idvendedor, Apellido, Nombres, email, comisión)
VALUES (3, 'Vera', 'Silvia', 'verasilvia@email.com', 0.20);

-- Insertar datos en la tabla Productos
-- Productos del Proveedor 1
INSERT INTO Productos (idproducto, Descripción, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, origen)
VALUES (1, 'Producto A1', 10.99, 50, 100, 10, 1, 'Local');
INSERT INTO Productos (idproducto, Descripción, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, origen)
VALUES (2, 'Producto A2', 20.50, 30, 80, 5, 1, 'Local');
INSERT INTO Productos (idproducto, Descripción, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, origen)
VALUES (3, 'Producto A3', 15.30, 20, 90, 8, 1, 'Local');

-- Productos del Proveedor 2
INSERT INTO Productos (idproducto, Descripción, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, origen)
VALUES (4, 'Producto B1', 15.75, 25, 60, 5, 2, 'Extranjero');
INSERT INTO Productos (idproducto, Descripción, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, origen)
VALUES (5, 'Producto B2', 18.99, 40, 100, 10, 2, 'Extranjero');
INSERT INTO Productos (idproducto, Descripción, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, origen)
VALUES (6, 'Producto B3', 16.99, 50, 80, 15, 2, 'Extranjero');

-- Productos del Proveedor 3
INSERT INTO Productos (idproducto, Descripción, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, origen)
VALUES (7, 'Producto C1', 8.50, 20, 50, 5, 3, 'Local');
INSERT INTO Productos (idproducto, Descripción, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, origen)
VALUES (8, 'Producto C2', 12.25, 35, 70, 15, 3, 'Local');
INSERT INTO Productos (idproducto, Descripción, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, origen)
VALUES (9, 'Producto C3', 10.55, 45, 60, 10, 3, 'Local');
INSERT INTO Productos (idproducto, Descripción, PrecioUnitario, Stock, StockMax, StockMin, idproveedor, origen)
VALUES (10, 'Producto C4', 15.15, 25, 55, 12, 3, 'Local');

-- Pedido 1 (1 renglón)
INSERT INTO Pedidos (NumeroPedido, idcliente, idvendedor, fecha, Estado)
VALUES (1, 1, 1, TO_DATE('2023-08-01', 'YYYY-MM-DD'), 'Pendiente');

-- Detalle del Pedido 1
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (1, 1, 1, 5, 10.99, 54.95);

-- Pedido 2 (2 renglones)
INSERT INTO Pedidos (NumeroPedido, idcliente, idvendedor, fecha, Estado)
VALUES (2, 2, 2, TO_DATE('2023-08-02', 'YYYY-MM-DD'), 'En Proceso');

-- Detalle del Pedido 2 - Renglón 1
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (2, 1, 2, 2, 20.50, 41);

-- Detalle del Pedido 2 - Renglón 2
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (2, 2, 1, 3, 10.99, 32.97);

-- Pedido 3 (3 renglones)
INSERT INTO Pedidos (NumeroPedido, idcliente, idvendedor, fecha, Estado)
VALUES (3, 1, 3, TO_DATE('2023-08-03', 'YYYY-MM-DD'), 'Entregado');

-- Detalle del Pedido 3 - Renglón 1
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (3, 1, 3, 2, 18.75, 81.50);

-- Detalle del Pedido 3 - Renglón 2
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (3, 2, 5, 3, 19.50, 85.50);

-- Detalle del Pedido 3 - Renglón 3
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (3, 3, 7, 1, 19.25, 100.25);


-- Pedido 4 (1 renglón)
INSERT INTO Pedidos (NumeroPedido, idcliente, idvendedor, fecha, Estado)
VALUES (4, 4, 1, TO_DATE('2023-08-04', 'YYYY-MM-DD'), 'Pendiente');

-- Detalle del Pedido 4
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (4, 1, 4, 5, 7.99, 64.90);

-- Pedido 5 (2 renglones)
INSERT INTO Pedidos (NumeroPedido, idcliente, idvendedor, fecha, Estado)
VALUES (5, 5, 2, TO_DATE('2023-08-05', 'YYYY-MM-DD'), 'En Proceso');

-- Detalle del Pedido 5 - Renglón 1
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (5, 1, 5, 2, 26.50, 91);

-- Detalle del Pedido 5 - Renglón 2
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (5, 2, 5, 3, 13.99, 65.97);

-- Pedido 6 (3 renglones)
INSERT INTO Pedidos (NumeroPedido, idcliente, idvendedor, fecha, Estado)
VALUES (6, 1, 3, TO_DATE('2023-08-06', 'YYYY-MM-DD'), 'Entregado');

-- Detalle del Pedido 6 - Renglón 1
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (6, 1, 6, 2, 17.75, 90.50);

-- Detalle del Pedido 6 - Renglón 2
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (6, 2, 6, 3, 10.50, 58.50);

-- Detalle del Pedido 6 - Renglón 3
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (6, 3, 6, 1, 14.25, 42.55);

-- Pedido 7 (1 renglón)
INSERT INTO Pedidos (NumeroPedido, idcliente, idvendedor, fecha, Estado)
VALUES (7, 2, 1, TO_DATE('2023-08-07', 'YYYY-MM-DD'), 'Pendiente');

-- Detalle del Pedido 7
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (7, 1, 1, 5, 17.99, 84.95);

-- Pedido 8 (2 renglones)
INSERT INTO Pedidos (NumeroPedido, idcliente, idvendedor, fecha, Estado)
VALUES (8, 3, 2, TO_DATE('2023-08-08', 'YYYY-MM-DD'), 'En Proceso');

-- Detalle del Pedido 8 - Renglón 1
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (8, 1, 2, 2, 6.50, 41);

-- Detalle del Pedido 8 - Renglón 2
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (8, 2, 1, 3, 13.20, 32.97);


-- Pedido 9 (3 renglones)
INSERT INTO Pedidos (NumeroPedido, idcliente, idvendedor, fecha, Estado)
VALUES (9, 4, 3, TO_DATE('2023-08-09', 'YYYY-MM-DD'), 'Entregado');

-- Detalle del Pedido 9 - Renglón 1
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (9, 1, 3, 2, 11.75, 31.50);

-- Detalle del Pedido 9 - Renglón 2
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (9, 2, 5, 3, 5.50, 30.50);

-- Detalle del Pedido 9 - Renglón 3
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (9, 3, 7, 1, 9.25, 72.66);

-- Pedido 10 (1 renglón)
INSERT INTO Pedidos (NumeroPedido, idcliente, idvendedor, fecha, Estado)
VALUES (10, 5, 1, TO_DATE('2023-08-10', 'YYYY-MM-DD'), 'Pendiente');

-- Detalle del Pedido 10
INSERT INTO DetallePedidos (NumeroPedido, renglon, idproducto, cantidad, PrecioUnitario, Total)
VALUES (10, 1, 1, 5, 10.99, 77.95);

--Realizar las siguientes consultas sobre la base de datos:
--Detalle de clientes que realizaron pedidos entre fechas (apellido, nombres, DNI, correo electrónico).
SELECT c.Apellido, c.Nombres, c.idcliente, c.mail
FROM Clientes c
INNER JOIN Pedidos p ON c.idcliente = p.idcliente
WHERE p.fecha BETWEEN TO_DATE('2023-08-01', 'YYYY-MM-DD') AND TO_DATE('2023-08-10', 'YYYY-MM-DD');

--Detalle de vendedores con la cantidad de pedidos realizados (apellido, nombres, DNI, correo electrónico, CantidadPedidos).
SELECT V.Apellido,V.Nombres,V.idvendedor AS DNI,V.email AS "correo electrónico",COUNT(P.NumeroPedido) AS CantidadPedidos FROM Vendedor V
LEFT JOIN Pedidos P ON V.idvendedor = P.idvendedor
GROUP BY V.idvendedor, V.Apellido, V.Nombres, V.email;

--Detalle de pedidos con un total mayor a un determinado valor umbral (NumeroPedido, fecha, TotalPedido).
SELECT dp.NumeroPedido, p.fecha, SUM(dp.Total) AS TotalPedido
FROM DetallePedidos dp
JOIN Pedidos p ON dp.NumeroPedido = p.NumeroPedido
GROUP BY dp.NumeroPedido, p.fecha
HAVING SUM(dp.Total) > 100.00;

--Lista de productos vendidos entre fechas. (Descripción, CantidadTotal). CantidadTotal se calcula sumando todas las cantidades vendidas del producto.
SELECT
    p.idproducto,
    p.Descripción,
    SUM(dp.cantidad) AS CantidadTotal
FROM
    Productos p
JOIN
    DetallePedidos dp ON p.idproducto = dp.idproducto
JOIN
    Pedidos ped ON dp.NumeroPedido = ped.NumeroPedido
WHERE
    ped.fecha BETWEEN TO_DATE('2023-08-01', 'YYYY-MM-DD') AND TO_DATE('2023-08-10', 'YYYY-MM-DD')
GROUP BY
    p.idproducto, p.Descripción
ORDER BY
    CantidadTotal DESC;

--¿Cuál es el proveedor que realizó más? 
-- El prevedor A con ID 1 fue el que mas realizo con un TotalPedidos de 9.
SELECT
    pr.idproveedor,
    pr.NombreProveedor,
    COUNT(ped.NumeroPedido) AS TotalPedidos
FROM
    Proveedores pr
JOIN
    Productos p ON pr.idproveedor = p.idproveedor
JOIN
    DetallePedidos dp ON p.idproducto = dp.idproducto
JOIN
    Pedidos ped ON dp.NumeroPedido = ped.NumeroPedido
GROUP BY
    pr.idproveedor, pr.NombreProveedor
ORDER BY
    TotalPedidos DESC 
;

--Detalle de clientes registrados que nunca realizaron un pedido. (apellido, nombres, e-mail).
--He agregado un cliente mas para corroborar que esta sentencia es correcta.
SELECT c.Apellido, c.Nombres, c.mail
FROM Clientes c
LEFT JOIN Pedidos p ON c.idcliente = p.idcliente
WHERE p.idcliente IS NULL;


--Detalle de clientes que realizaron menos de dos pedidos. (apellido, nombres, e-mail).
SELECT c.Apellido, c.Nombres, c.mail
FROM Clientes c
LEFT JOIN Pedidos p ON c.idcliente = p.idcliente
GROUP BY c.idcliente, c.Apellido, c.Nombres, c.mail
HAVING COUNT(p.NumeroPedido) < 2;

--Cantidad total vendida por origen de producto.
SELECT p.origen, SUM(dp.cantidad) AS CantidadTotalVendida
FROM Productos p
JOIN DetallePedidos dp ON p.idproducto = dp.idproducto
GROUP BY p.origen;