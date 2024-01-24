-- Sección 1: Creación de la base de datos DWPedidos y tablas dimensionales y de hechos

-- Creacion de la base de datos DWPedidos
CREATE DATABASE DWPedidos;

-- Secuencias
CREATE SEQUENCE seq_dimfechas
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE SEQUENCE seq_dimproductos
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE SEQUENCE seq_factpedidos
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE SEQUENCE seq_dimclientes
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
  
-- Tabla DIMFechas
CREATE TABLE DIMFechas (
    id_Fec INTEGER,
    fecha DATE,
    dia INTEGER,
    mes INTEGER,
    año INTEGER
);

-- Disparador para generar valores de id_Fec
CREATE OR REPLACE TRIGGER trigger_dimfechas
BEFORE INSERT ON DIMFechas
FOR EACH ROW
BEGIN
    SELECT seq_dimfechas.NEXTVAL
    INTO :NEW.id_Fec
    FROM dual;
END;
/

-- Tabla DIMProductos
CREATE TABLE DIMProductos (
    id_pro INTEGER,
    idproducto INTEGER,
    descripcion VARCHAR(50),
    nombreproveedor VARCHAR(50)
);

-- Disparador para generar valores de id_pro
CREATE OR REPLACE TRIGGER trigger_dimproductos
BEFORE INSERT ON DIMProductos
FOR EACH ROW
BEGIN
    SELECT seq_dimproductos.NEXTVAL
    INTO :NEW.id_pro
    FROM dual;
END;
/

-- Tabla DIMClientes
CREATE TABLE DIMClientes (
    id_cli INTEGER,
    idcliente INTEGER,
    nombre VARCHAR(50)
);

-- Disparador para generar valores de id_cli
CREATE OR REPLACE TRIGGER trigger_dimclientes
BEFORE INSERT ON DIMClientes
FOR EACH ROW
BEGIN
    SELECT seq_dimclientes.NEXTVAL
    INTO :NEW.id_cli
    FROM dual;
END;
/

-- En la tabla DIMClientes
ALTER TABLE DIMClientes
ADD CONSTRAINT pk_dimclientes PRIMARY KEY (id_cli);

-- En la tabla DIMProductos
ALTER TABLE DIMProductos
ADD CONSTRAINT pk_dimproductos PRIMARY KEY (id_pro);

-- En la tabla DIMFechas
ALTER TABLE DIMFechas
ADD CONSTRAINT pk_dimfechas PRIMARY KEY (id_Fec);

-- Tabla FACTPedidos
CREATE TABLE FACTPedidos (
    id_cli INTEGER,
    id_pro INTEGER,
    id_fec INTEGER,
    cantidad INTEGER,
    total INTEGER
);

-- Crear relaciones entre las tablas
ALTER TABLE FACTPedidos
ADD CONSTRAINT fk_dimclientes
FOREIGN KEY (id_cli)
REFERENCES DIMClientes(id_cli);

ALTER TABLE FACTPedidos
ADD CONSTRAINT fk_dimproductos
FOREIGN KEY (id_pro)
REFERENCES DIMProductos(id_pro);

ALTER TABLE FACTPedidos
ADD CONSTRAINT fk_dimfechas
FOREIGN KEY (id_fec)
REFERENCES DIMFechas(id_Fec);

-- Sección 2: Procedimientos almacenados para carga de datos (Proceso ETL)

-- Procedimiento para cargar la tabla DIMFechas
CREATE OR REPLACE PROCEDURE CargarDIMFechas AS
BEGIN
    FOR r IN (SELECT DISTINCT fecha, EXTRACT(DAY FROM fecha) AS dia, EXTRACT(MONTH FROM fecha) AS mes, EXTRACT(YEAR FROM fecha) AS año FROM Pedidos)
    LOOP
        INSERT INTO DIMFechas (fecha, dia, mes, año) VALUES (r.fecha, r.dia, r.mes, r.año);
    END LOOP;
END;
/
-- Ejecutar el procedimiento
BEGIN
    CargarDIMFechas;
    COMMIT;
END;
/

-- Procedimiento para cargar la tabla DIMProductos
CREATE OR REPLACE PROCEDURE CargarDIMProductos AS
BEGIN
    FOR r IN (SELECT DISTINCT idproducto, Descripción, idproveedor AS nombreproveedor FROM Productos)
    LOOP
        INSERT INTO DIMProductos (idproducto, descripcion, nombreproveedor) VALUES (r.idproducto, r.Descripción, r.nombreproveedor);
    END LOOP;
    COMMIT;
END;
/
-- Ejecutar el procedimiento
BEGIN
    CargarDIMProductos;
    COMMIT;
END;
/
-- Procedimiento para cargar la tabla DIMClientes
CREATE OR REPLACE PROCEDURE CargarDIMClientes AS
BEGIN
    FOR r IN (SELECT DISTINCT idcliente, Apellido || ' ' || Nombres AS nombre FROM Clientes)
    LOOP
        INSERT INTO DIMClientes (idcliente, nombre) VALUES (r.idcliente, r.nombre);
    END LOOP;
    COMMIT;
END;
/
-- Ejecutar el procedimiento
BEGIN
    CargarDIMClientes;
    COMMIT;
END;
/

-- Procedimiento para cargar la tabla FACTPedidos
CREATE OR REPLACE PROCEDURE CargarFACTPedidos AS
BEGIN
    FOR r IN (SELECT p.idcliente, pr.idproducto, f.id_Fec, dp.cantidad, dp.Total
              FROM Pedidos p
              JOIN DetallePedidos dp ON p.NumeroPedido = dp.NumeroPedido
              JOIN DIMClientes c ON p.idcliente = c.idcliente
              JOIN DIMProductos pr ON dp.idproducto = pr.idproducto
              JOIN DIMFechas f ON TO_DATE(p.fecha, 'DD-MON-YY') = f.fecha)
    LOOP
        INSERT INTO FACTPedidos (id_cli, id_pro, id_fec, cantidad, total) VALUES (r.idcliente, r.idproducto, r.id_Fec, r.cantidad, r.Total);
    END LOOP;
END;
/
-- Ejecutar el procedimiento
BEGIN
    CargarFACTPedidos;
    COMMIT;
END;
/

