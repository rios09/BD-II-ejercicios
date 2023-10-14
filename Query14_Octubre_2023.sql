CREATE DATABASE InsuranceRecords
USE InsuranceRecords

CREATE TABLE CLIENTES(
ID_Cliente int,
PrimerNombre NVARCHAR(16) NOT NULL,
SegundoNombre NVARCHAR(16),
PrimerApellido NVARCHAR(16) NOT NULL,
SegundoApellido NVARCHAR(16) NOT NULL,
Cedula char(16) check(Cedula like '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][A-Z]'),
FechaNacimiento DATE,
Sexo char(1) not null,
Direccion NVARCHAR(50) NOT NULL,
Telefono char(8) NOT NULL,
Estado_Cliente BIT DEFAULT 1,
PRIMARY KEY  (ID_Cliente))


CREATE TABLE COCHES(
Matricula int,
Placa NVARCHAR(10) NOT NULL,	
PRIMARY KEY(Matricula)
)


CREATE TABLE MARCA(
ID_Marca int,
NombreMarca NVARCHAR(10) NOT NULL,
DescMarca NVARCHAR(50) NOT NULL,
PRIMARY KEY(ID_Marca))

CREATE TABLE MODELO(
ID_Modelo int,
NomModelo NVARCHAR(16) NOT NULL,
DescModelo NVARCHAR(50) NOT NULL,
PRIMARY KEY(ID_Modelo)
)

CREATE TABLE ACCIDENTES(
ID_Acc int,
CodigoAcc int,
TipoAcc nvarchar(30) NOT NULL,
FechaAcc DATE,
DescAcc nvarchar(60) NOT NULL,
ResponsableAcc bit default 0,
PRIMARY KEY(ID_Acc)
)

CREATE TABLE SEGUROS(
ID_Seguro int,
TipoSeguro nvarchar(16) not null,
DescSeguro nvarchar (50)not null,
Estada_Seguro BIT DEFAULT 1,
PRIMARY KEY(ID_Seguro)
)

--Insertando algunos datos en la tabla
INSERT INTO CLIENTES VALUES ('1','Fabio','Alejandro','Rios','Flores','001-280800-1014H','2000-08-28','M','Ciudad Sandino','22692633')
INSERT INTO COCHES values(8,'M849546')
INSERT INTO MARCA VALUES('KIA','Hecho En Corea Por KIA MOTORS S.A 2023',1)
INSERT INTO MODELO VALUES('Sportage 2023','Traccion integral activa con modo multiterreno',1,'187')
INSERT INTO ACCIDENTES VALUES('COlision lateral Trasera', GETDATE(),'Cliente no respeta semaforo en rojo',1,1)
INSERT INTO SEGUROS VALUES('Full Cover','Seguro cubre hasta el 80% de los daños',8)

--Creando Procedimientos Almacenados

CREATE PROCEDURE AgregarCliente
@FirstName NVARCHAR(16),
@SecondName NVARCHAR(16),
@LastName NVARCHAR(16),
@SurName NVARCHAR(16),
@ID char(16),
@DOB Date,
@Sex Char(1),
@Address NVARCHAR (50),
@Cel Char(8)
AS 
BEGIN
if (@ID LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][A-Z]')
BEGIN
INSERT INTO CLIENTES([PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[Cedula],[FechaNacimiento],[Sexo],[Direccion], [Telefono])
VALUES(@FirstName, @SecondName, @LastName, @SurName, @ID, @DOB, @Sex, @Address, @Cel)
END
ELSE
BEGIN
Print 'El valor de la cedula no cumple con el formato adecuado'
END
END
--Ejecutando Proceso Almacenado
EXEC AgregarCliente 'Miguel','Andres','Rios','Flores','001-280800-1014h','2018-04-12','M','Ciudad Sandino','85786416'
SELECT * FROM CLIENTES
--=================================

CREATE PROCEDURE AgregarCoche
@Owner int,
@Registration Nvarchar(10)
AS
BEGIN
INSERT INTO COCHES(ID_Cliente, Placa) VALUES(@Owner,@Registration)
END
EXEC AgregarCoche '11','M77960'
Select* from COCHES
--=======================================

CREATE PROCEDURE AgregarMarca
@Brand NVARCHAR(10),
@BrandDesc NVARCHAR(50),
@ID_Registration int
AS
BEGIN
INSERT INTO MARCA(NombreMarca,DescMarca,Matricula) VALUES(@Brand,@BrandDesc,@ID_Registration)
END
EXEC AgregarMarca'Tesla','Tesla, Inc. automóviles eléctricos y tecnología','3'
SELECT * FROM MARCA
--===========================

CREATE PROCEDURE AgregarModelo
@Model NVARCHAR(16),
@ModelDesc NVARCHAR(50),
@ID_Brand int,
@Power int
AS
BEGIN
INSERT INTO MODELO(NomModelo,DescModelo,ID_Marca, Potencia) VALUES(@Model, @ModelDesc,@ID_Brand,@Power)
END
EXEC AgregarModelo 'Model X','SUV completamente eléctrico fabricado por Tesla, Inc','3','670'
SELECT * FROM MODELO
--========================

CREATE PROCEDURE AgregarAccidente
@AccType NVARCHAR(30),
@AccDate Date,
@AccDesc NVARCHAR(60),
@Liable BIT,
@ID_Registration int
AS
BEGIN
INSERT INTO ACCIDENTES(TipoAcc,FechaAcc,DescAcc,ResponsableAcc,Matricula)
VALUES(@AccType,@AccDate,@AccDesc,@Liable,@ID_Registration)
END

EXEC AgregarAccidente 'Colision Lateral Izquierda','2023-07-20','Cliente no respeto señal de alto','1','3'
SELECT * FROM COCHES
SELECT * FROM ACCIDENTES
--===================

CREATE PROCEDURE AgregarSeguro
@InsuranceType NVARCHAR(16),
@InsuranceDesc NVARCHAR(50),
@ClientId int
AS
BEGIN
INSERT INTO SEGUROS (TipoSeguro,DescSeguro,ID_Cliente) VALUES(@InsuranceType,@InsuranceDesc, @ClientId)
END
EXEC AgregarSeguro 'Seguro Daños a Terceros', '1.Pérdida Total Solamente 2.Responsabilidad Civil', '11'
SELECT * FROM SEGUROS
SELECT * FROM CLIENTES

-- DAR DE BAJA
create procedure BajaCliente
@ID int
as
declare @IdCliente as int
set @IdCliente=(select ID_Cliente from CLIENTES where ID_Cliente=@ID)
if(@ID=@IdCliente)
begin
  update CLIENTES set Estado_Cliente=0 where @IdCliente=@ID and
  Estado_Cliente=1
end
else
begin
   print 'Cliente no encontrado'
end

CREATE PROCEDURE BajaSeguro
@ID int
AS
DECLARE @IdSeguro AS INT
SET @IdSeguro = (SELECT ID_Seguro FROM SEGUROS WHERE @IdSeguro = @ID)
IF (@ID = @IdSeguro)
BEGIN
UPDATE SEGUROS SET Estada_Seguro =0 WHERE @IdSeguro = @ID AND Estada_Seguro =1
END
ELSE 
BEGIN
PRINT 'Seguro no encontrado'
END

--ACTUALIZAR / MODIFICAR CLIENTE

CREATE PROCEDURE ActualizarCliente
@ID INT,
@Name NVARCHAR(16), @2NAME NVARCHAR(16), @LastName NVARCHAR (16), @SurName NVARCHAR(16), @Identification CHAR(16), @DOB DATE, @Sex CHAR(1),
@Address NVARCHAR(50), @Cel CHAR(8), @Status BIT
AS
BEGIN
IF(@Identification LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][A-Z]')
BEGIN
UPDATE CLIENTES SET PrimerNombre =@Name, SegundoNombre = @2NAME, PrimerApellido =@LastName, SegundoApellido =@SurName, Cedula= @Identification,
FechaNacimiento =@DOB, Sexo=@Sex, Direccion=@Address, Telefono= @Cel, Estado_Cliente= @Status
WHERE ID_Cliente= @ID
END
END

-- BUSCAR CLIENTE
create procedure SearchClient
@IDC int
as
declare @ClientId as int
set @ClientId=(select ID_Cliente from CLIENTES where ID_Cliente=@IDC)
if(@IDC=@ClientId)
begin
  select * from CLIENTES where ID_Cliente=@IDC and Estado_Cliente=1
end
else
begin
  print 'No se logro encontrar un cliente'
end
DROP PROCEDURE SearchClient
EXEC SearchClient '8'

--MOSTRAR CLIENTES ACTIVOS
CREATE PROCEDURE ActiveClients
AS
SELECT PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, Telefono from CLIENTES WHERE Estado_Cliente=1


--MOSTRAR CLIENTES INACTIVOS
CREATE PROCEDURE InactiveClients
AS
SELECT PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, Telefono from CLIENTES WHERE Estado_Cliente=0

--Hecho por Fabio Rios
