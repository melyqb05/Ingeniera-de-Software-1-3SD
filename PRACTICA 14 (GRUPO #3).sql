--1. CREACION DE INDICES
CREATE CLUSTERED INDEX IX_CLIENTE_IDCLIENTE ON CLIENTE(IDCLIENTE)
GO

-- b) Indice no agrupado (NONCLUSTERED) para PRODUCTO por NOMBRE
CREATE NONCLUSTERED INDEX IX_PRODUCTO__NOMBRE ON PRODUCTO(NOMBRE)
GO

-- c) Indice unico para CLIENTE por CEDULA
CREATE UNIQUE INDEX IX_CLIENTE_CÉDULA ON CLIENTE(CEDULA)
GO

--2. Listar todos los clientes que hayan realizado ventas de productos que tenga la palabra 'LACTEOS'.
USE DELIVERY;
GO
SELECT DISTINCT
       C.IDCLIENTE,
       C.NOMBRES,
       C.CEDULA
FROM CLIENTE C
JOIN VENTA V ON C.IDCLIENTE=V.IDCLIENTE
JOIN VENTADETALLE VD ON V.IDVENTA=VD.IDVENTA
JOIN PRODUCTO P ON VD.IDPRODUCTO=P.IDPRODUCTO
WHERE P.NOMBRE LIKE '%LACTEOS%';
GO


--3. Consultar los productos que nunca han sido comprados por ningún cliente.
USE DELIVERY;
GO
SELECT * FROM PRODUCTO
WHERE IDPRODUCTO NOT IN
(
SELECT IDPRODUCTO FROM VENTADETALLE
);


--4. Consultar los clientes que han realizado al menos una venta con pago al contado (FPAGO = 1).
USE DELIVERY;
GO

SELECT DISTINCT
       C.IDCLIENTE,
       C.NOMBRES,
       C.CEDULA
FROM CLIENTE C
INNER JOIN VENTA V ON C.IDCLIENTE = V.IDCLIENTE
WHERE V.FPAGO = 1;
SELECT FPAGO, COUNT(*) AS CANTIDAD
FROM VENTA
GROUP BY FPAGO;

--5. Consultar los productos cuyo precio sea mayor al precio promedio de todos los productos.
USE DELIVERY;
GO
SELECT * FROM PRODUCTO
WHERE PRECIO>
(
SELECT AVG(PRECIO)
FROM PRODUCTO
);


--6.Crear una vista que muestre el nombre del cliente, el total de ventas realizadas y el monto total gastado. 
--Realizar una consulta con la vista ordenada por el total gastado en forma descendente.
USE DELIVERY;
GO

ALTER VIEW VW_CLIENTE_VENTA
AS
SELECT
    C.NOMBRES,
    COUNT(V.IDVENTA) AS TOTAL_VENTAS
    
FROM CLIENTE C
JOIN VENTA V ON C.IDCLIENTE = V.IDCLIENTE
GROUP BY C.NOMBRES
GO

SELECT * FROM VW_CLIENTE_VENTA
ORDER BY TOTAL_GASTADO DESC;


--7. Crear una vista que muestre el nombre del producto y la cantidad total vendida, ordenada de mayor a menor. 
--Realizar una consulta con la vista ordenada por el total vendido en forma descendente.
USE DELIVERY;
GO

CREATE VIEW VW_PRODUCTOS_VENDIDO
AS
SELECT P.NOMBRE, SUM(VD.CANT) AS TOTAL_VENDIDO
FROM PRODUCTO P
INNER JOIN VENTADETALLE VD
ON P.IDPRODUCTO= VD.IDPRODUCTO
GROUP BY P.NOMBRE;
GO

SELECT * FROM VW_PRODUCTOS_VENDIDOS
ORDER BY TOTAL_VENDIDO DESC;


--8. Crear una vista que muestre los clientes que solo han realizado ventas al contado. Realizar una consulta con la vista.
USE DELIVERY;
GO

CREATE VIEW VW_CLIENTES__CONTADO
AS
SELECT
C.IDCLIENTE,
C.NOMBRES,
C.CEDULA
FROM CLIENTE C
WHERE NOT EXISTS
(
SELECT * FROM VENTA V
WHERE V.IDCLIENTE=C.IDCLIENTE
AND V.FPAGO<>1
);
GO

SELECT * FROM VW_CLIENTES_CONTADO;


--9. Crear una vista que muestre el mes y año de las compras, el número de ventas realizadas y el total de productos vendidos. 
--Realizar una consulta con la vista.
USE DELIVERY;
GO

CREATE VIEW VW_VENTA_MES_AÑO AS
SELECT
YEAR(V.FECHA_REGISTRO) AS AÑO,
MONTH(V.FECHA_REGISTRO) AS MES,
COUNT(DISTINCT V.IDVENTA) AS NUMERO_VENTAS,
SUM(VD.CANT) AS TOTAL_PRODUCTOS
FROM VENTA V
INNER JOIN VENTADETALLE VD
ON V.IDVENTA=VD.IDVENTA
GROUP BY
YEAR(V.FECHA_REGISTRO),
MONTH(V.FECHA_REGISTRO);
GO
SELECT * FROM VW_RESUMEN_COMPRAS;


--10. Consultar el cliente que ha realizado la venta con el mayor monto total (precio × cantidad) y mostrar su nombre, cedula y el monto total.
USE DELIVERY;
GO

SELECT TOP 1
C.NOMBRES,
C.CEDULA,
SUM(VD.PRECIO * VD.CANT) AS MONTO_TOTAL
FROM CLIENTE C JOIN VENTA V
ON C.IDCLIENTE = V.IDCLIENTE
JOIN VENTADETALLE VD
ON V.IDVENTA = VD.IDVENTA 

GROUP BY
C.NOMBRES,
C.CEDULA,
V.IDVENTA
ORDER BY MONTO_TOTAL DESC;