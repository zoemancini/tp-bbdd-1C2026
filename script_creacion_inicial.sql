-- ====================================================================================
-- CREACIÓN DE ESQUEMA Y TABLAS
-- ====================================================================================
CREATE SCHEMA [DB_LOPERS]; 
GO

-- ==========================================
-- TABLAS DE DOMINIO
-- ==========================================
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
-- TABLAS DEPENDIENTES
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
    Nombre nvarchar(255), 
    foreign key (ID_Pais) references [DB_LOPERS].Pais(ID_Pais)
); 
go

create table [DB_LOPERS].Aerolinea (
    Codigo nvarchar(255) primary key, 
    ID_Alianza bigint,
    ID_Pais bigint,
    Nombre nvarchar(255), 
    foreign key (ID_Alianza) references [DB_LOPERS].Alianza(ID_Alianza),
    foreign key (ID_Pais) references [DB_LOPERS].Pais(ID_Pais)
); 
go

create table [DB_LOPERS].Aeropuerto (
    Codigo nvarchar(10) primary key, 
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
    Direccion nvarchar(255), 
    Fecha_Nac date,
    foreign key (ID_Localidad) references [DB_LOPERS].Localidad(ID_Localidad)
); 
go

create table [DB_LOPERS].Agente (
    Legajo bigint primary key,
    Agencia_Nro_Agencia bigint,
    ID_Localidad bigint,
    Nombre nvarchar(255),
    Apellido nvarchar(255),
    Dni nvarchar(255),
    Fecha_Nac date,
    Telefono nvarchar(255),
    Mail nvarchar(255),
    Direccion nvarchar(255),
    foreign key (Agencia_Nro_Agencia) references [DB_LOPERS].Agencia(Nro_Agencia),
    foreign key (ID_Localidad) references [DB_LOPERS].Localidad(ID_Localidad)
); 
go

create table [DB_LOPERS].Hospedaje (
    ID_Hospedaje bigint identity(1,1) primary key,
    ID_Pais bigint,
    ID_Ciudad bigint,
    Nombre nvarchar(255),
    Direccion nvarchar(255),
    Incluye_Desayuno bit,
    Check_In nvarchar(50),
    Check_Out nvarchar(50),
    foreign key (ID_Pais) references [DB_LOPERS].Pais(ID_Pais),
    foreign key (ID_Ciudad) references [DB_LOPERS].Ciudad(ID_Ciudad)
); 
go

create table [DB_LOPERS].Habitacion (
    ID_Habitacion bigint identity(1,1) primary key,
    ID_Hospedaje bigint,
    Nombre nvarchar(255),
    Descripcion nvarchar(MAX),
    Precio_Noche decimal(18,2),
    foreign key (ID_Hospedaje) references [DB_LOPERS].Hospedaje(ID_Hospedaje)
); 
go

create table [DB_LOPERS].Excursion (
    ID_Excursion bigint identity(1,1) primary key,
    ID_Proveedor bigint,
    Nombre nvarchar(255),
    Descripcion nvarchar(MAX),
    Horario nvarchar(50),
    Duracion int,
    Precio decimal(18,2),
    foreign key (ID_Proveedor) references [DB_LOPERS].Proveedor(ID_Proveedor)
); 
go

create table [DB_LOPERS].Vuelo (
    ID_Vuelo bigint identity(1,1) primary key,
    Aerolinea_Codigo nvarchar(255), 
    Aeropuerto_Salida_Codigo nvarchar(10),
    Aeropuerto_Llegada_Codigo nvarchar(10),
    Fecha_Salida date,
    Horario_Salida nvarchar(50),
    Fecha_Llegada date,
    Horario_Llegada nvarchar(50),
    Duracion int,
    Precio decimal(18,2), 
    Incluye_Carry bit,
    Incluye_Valija bit,
    foreign key (Aerolinea_Codigo) references [DB_LOPERS].Aerolinea(Codigo), 
    foreign key (Aeropuerto_Salida_Codigo) references [DB_LOPERS].Aeropuerto(Codigo),
    foreign key (Aeropuerto_Llegada_Codigo) references [DB_LOPERS].Aeropuerto(Codigo)
);
go