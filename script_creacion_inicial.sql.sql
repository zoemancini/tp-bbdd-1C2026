-- ====================================================================================
-- PARTE 1: DDL - CREACIÓN DE ESQUEMA Y TABLAS
-- ====================================================================================

-- 1. Creación del esquema del grupo (Reemplazar LOS_MEJORES por el nombre real)
CREATE SCHEMA [DB_LOPERS]; 
GO

-- ==========================================
-- TABLAS DE DOMINIO (No tienen Claves Foráneas)
-- ==========================================
-- Creamos la tabla Provincia para normalizar la tabla Agencia y Localidad
create table [DB_LOPERS].Provincia (
    ID_Provincia bigint identity(1,1) primary key,
    Nombre nvarchar(255)
); 
go

create table [DB_LOPERS].Proveedor (
    ID_Proveedor bigint identity(1,1) primary key,
    Nombre nvarchar(255),
    Mail nvarchar(255),
    Telefono nvarchar(255)
); 
go

create table [DB_LOPERS].Alianza (
    ID_Alianza bigint identity(1,1) primary key,
    Nombre nvarchar(255)
); 
go

create table [DB_LOPERS].Pais (
    ID_Pais bigint identity(1,1) primary key,
    Nombre nvarchar(255)

); 
go

create table [DB_LOPERS].Estado_Propuesta (
    ID_Estado_Propuesta bigint identity(1,1) primary key,
    Descripcion nvarchar(255)
); 
go

create table [DB_LOPERS].Canal_Venta (
    ID_Canal_Venta bigint identity(1,1) primary key,
    Descripcion nvarchar(255)
); 
go

create table [DB_LOPERS].Medio_Pago (
    ID_Medio_Pago bigint identity(1,1) primary key,
    Descripcion nvarchar(255)
); 
go

create table [DB_LOPERS].Aspecto (
    ID_Aspecto bigint identity(1,1) primary key,
    Descripcion nvarchar(255)
); 
go

-- ==========================================
-- TABLAS DEPENDIENTES (Tienen Claves Foráneas)
-- ==========================================
create table [DB_LOPERS].Localidad (
    ID_Localidad bigint identity(1,1) primary key,
    ID_Provincia bigint,
    Nombre nvarchar(255),

    foreign key(ID_Provincia) references [DB_LOPERS].Provincia(ID_Provincia)
); 
go

create table [DB_LOPERS].Agencia (
    Nro_Agencia bigint identity(1,1) primary key,
    ID_Localidad bigint,
    Direccion nvarchar(255),
    Telefono nvarchar(255),
    Mail nvarchar(255),
    foreign key (ID_Localidad) references [DB_LOPERS].Localidad(ID_Localidad)
); 
go

create table [DB_LOPERS].Ciudad (
    ID_Ciudad bigint identity(1,1) primary key,
    ID_Pais bigint,
    Nombre nvarchar(255)
    foreign key (ID_Pais) references [DB_LOPERS].Pais(ID_Pais)
); 
go

create table [DB_LOPERS].Aerolinea (
    Codigo bigint identity(1,1) primary key,
    ID_Alianza bigint,
    ID_Pais bigint,
    Nombre nvarchar(255)
    foreign key (ID_Alianza) references [DB_LOPERS].Alianza(ID_Alianza),
    foreign key (ID_Pais) references [DB_LOPERS].Pais(ID_Pais)
); 
go

create table [DB_LOPERS].Aeropuerto (
    Codigo bigint identity(1,1) primary key,
    ID_Pais bigint,
    ID_Ciudad bigint,
    Descripcion nvarchar(200),
    foreign key (ID_Ciudad) references [DB_LOPERS].Ciudad(ID_Ciudad),
    foreign key (ID_Pais) references [DB_LOPERS].Pais(ID_Pais)
); 
go

create table [DB_LOPERS].Cliente (
    ID_Cliente bigint identity(1,1) primary key,
    ID_Localidad bigint,
    Dni nvarchar(255),
    Nombre nvarchar(255),
    Apellido nvarchar(255),
    Tel nvarchar(255),
    Mail nvarchar(255),
    Fecha_Nac date,
    foreign key (ID_Localidad) references [DB_LOPERS].Localidad(ID_Localidad)
); 
go