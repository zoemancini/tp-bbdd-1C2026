-- ====================================================================================
-- CREACIÓN DE ESQUEMA Y TABLAS
-- ====================================================================================
create schema [DB_LOPERS];
go

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
    Nro_Agencia bigint primary key,
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

create table [DB_LOPERS].Solicitud (
    Nro_Solicitud bigint primary key,
    ID_Cliente bigint,
    Agente_Legajo bigint,
    Fecha_Solicitud date,
    Fecha_Inicio_Tentativa date,
    Fecha_Fin_Tentativa date,
    Cant_Pasajeros int,
    Observaciones nvarchar(MAX),
    Presupuesto_Estimado decimal(18,2),
    foreign key (ID_Cliente) references [DB_LOPERS].Cliente(ID_Cliente),
    foreign key (Agente_Legajo) references [DB_LOPERS].Agente(Legajo)
);
go

create table [DB_LOPERS].Detalle_Solicitud (
    ID_Detalle_Solicitud bigint identity(1,1) primary key,
    Solicitud_Nro_Solicitud bigint,
    ID_Ciudad bigint,
    Cant_Dias_Aprox int,
    Observaciones nvarchar(MAX),
    foreign key (Solicitud_Nro_Solicitud) references [DB_LOPERS].Solicitud(Nro_Solicitud),
    foreign key (ID_Ciudad) references [DB_LOPERS].Ciudad(ID_Ciudad)
);
go

create table [DB_LOPERS].Propuesta (
    Nro_Propuesta bigint primary key, 
    Solicitud_Nro_Solicitud bigint,
    Agente_Legajo bigint,
    ID_Estado_Propuesta bigint,
    Fecha_Emision date,
    Vigencia_Hasta date,
    Fecha_Desde date,
    Fecha_Hasta date,
    Subtotal decimal(18,2),
    Descuento decimal(18,2),
    Importe_Total decimal(18,2),
    foreign key (Solicitud_Nro_Solicitud) references [DB_LOPERS].Solicitud(Nro_Solicitud),
    foreign key (Agente_Legajo) references [DB_LOPERS].Agente(Legajo),
    foreign key (ID_Estado_Propuesta) references [DB_LOPERS].Estado_Propuesta(ID_Estado_Propuesta)
);
go

create table [DB_LOPERS].Propuesta_Vuelo (
    ID_Propuesta_Vuelo bigint identity(1,1) primary key,
    Propuesta_Nro_Propuesta bigint,
    ID_Vuelo bigint,
    Cant_Pasajes int,
    Precio decimal(18,2),
    Subtotal decimal(18,2),
    foreign key (Propuesta_Nro_Propuesta) references [DB_LOPERS].Propuesta(Nro_Propuesta),
    foreign key (ID_Vuelo) references [DB_LOPERS].Vuelo(ID_Vuelo)
);
go

create table [DB_LOPERS].Propuesta_Hospedaje (
    ID_Propuesta_Hospedaje bigint identity(1,1) primary key,
    Propuesta_Nro_Propuesta bigint,
    ID_Habitacion bigint, 
    Fecha_Desde date,
    Fecha_Hasta date,
    Cantidad_Habitaciones int,
    Precio decimal(18,2),
    Subtotal decimal(18,2),
    foreign key (Propuesta_Nro_Propuesta) references [DB_LOPERS].Propuesta(Nro_Propuesta),
    foreign key (ID_Habitacion) references [DB_LOPERS].Habitacion(ID_Habitacion)
);
go

create table [DB_LOPERS].Venta (
    Nro_Venta bigint primary key, 
    ID_Cliente bigint,
    Agente_Legajo bigint,
    ID_Canal_Venta bigint,
    ID_Medio_Pago bigint,
    Fecha_Venta date,
    Subtotal decimal(18,2),
    Descuento decimal(18,2),
    Importe_Total decimal(18,2),
    foreign key (ID_Cliente) references [DB_LOPERS].Cliente(ID_Cliente),
    foreign key (Agente_Legajo) references [DB_LOPERS].Agente(Legajo),
    foreign key (ID_Canal_Venta) references [DB_LOPERS].Canal_Venta(ID_Canal_Venta),
    foreign key (ID_Medio_Pago) references [DB_LOPERS].Medio_Pago(ID_Medio_Pago)
);
go

create table [DB_LOPERS].Venta_Propuesta (
    ID_Venta_Propuesta bigint identity(1,1) primary key,
    Venta_Nro_Venta bigint,
    Propuesta_Nro_Propuesta bigint,
    foreign key (Venta_Nro_Venta) references [DB_LOPERS].Venta(Nro_Venta),
    foreign key (Propuesta_Nro_Propuesta) references [DB_LOPERS].Propuesta(Nro_Propuesta)
);
go

create table [DB_LOPERS].Venta_Vuelo (
    ID_Venta_Vuelo bigint identity(1,1) primary key,
    Venta_Nro_Venta bigint,
    ID_Vuelo bigint,
    Cantidad_Pasajes int,
    Precio_Unitario decimal(18,2),
    Subtotal decimal(18,2),
    Cod_Reserva nvarchar(255),
    foreign key (Venta_Nro_Venta) references [DB_LOPERS].Venta(Nro_Venta),
    foreign key (ID_Vuelo) references [DB_LOPERS].Vuelo(ID_Vuelo)
);
go

create table [DB_LOPERS].Venta_Hospedaje (
    ID_Venta_Hospedaje bigint identity(1,1) primary key,
    Venta_Nro_Venta bigint,
    ID_Habitacion bigint,
    Fecha_Desde date,
    Fecha_Hasta date,
    Cantidad_Habitaciones int,
    Precio_Unitario decimal(18,2),
    Subtotal decimal(18,2),
    Cod_Reserva nvarchar(255),
    foreign key (Venta_Nro_Venta) references [DB_LOPERS].Venta(Nro_Venta),
    foreign key (ID_Habitacion) references [DB_LOPERS].Habitacion(ID_Habitacion)
);
go

create table [DB_LOPERS].Venta_Excursion (
    ID_Venta_Excursion bigint identity(1,1) primary key,
    Venta_Nro_Venta bigint,
    ID_Excursion bigint,
    Fecha_Reserva date,
    Cantidad_Excursiones int,
    Precio_Unitario decimal(18,2),
    Subtotal decimal(18,2),
    Cod_Reserva nvarchar(255),
    foreign key (Venta_Nro_Venta) references [DB_LOPERS].Venta(Nro_Venta),
    foreign key (ID_Excursion) references [DB_LOPERS].Excursion(ID_Excursion)
);
go

create table [DB_LOPERS].Encuesta (
    Codigo_Encuesta bigint primary key, 
    ID_Cliente bigint,
    Agente_Legajo bigint,
    Fecha_Encuesta date,
    Comentarios nvarchar(MAX),
    foreign key (ID_Cliente) references [DB_LOPERS].Cliente(ID_Cliente),
    foreign key (Agente_Legajo) references [DB_LOPERS].Agente(Legajo)
);
go

create table [DB_LOPERS].Detalle_Encuesta (
    Encuesta_Codigo_Encuesta bigint,
    ID_Aspecto bigint,
    Puntaje int,
    primary key (Encuesta_Codigo_Encuesta, ID_Aspecto),
    foreign key (Encuesta_Codigo_Encuesta) references [DB_LOPERS].Encuesta(Codigo_Encuesta),
    foreign key (ID_Aspecto) references [DB_LOPERS].Aspecto(ID_Aspecto)
);
go

-- ====================================================================================
-- DML - STORED PROCEDURES DE MIGRACIÓN
-- ====================================================================================
create procedure [DB_LOPERS].Migrar_Provincia 
as
begin 
    insert into [DB_LOPERS].Provincia (Nombre)

    select distinct Agencia_Provincia
    from gd_esquema.Maestra
    where Agencia_Provincia is not null

    union

    select distinct Agente_Provincia
    from gd_esquema.Maestra
    where Agente_Provincia is not null

    union

    select distinct Cliente_Provincia 
    from gd_esquema.Maestra
    where Cliente_Provincia is not null;
end
go

create procedure [DB_LOPERS].Migrar_Pais
as
begin
    insert into [DB_LOPERS].Pais (Nombre)

    select distinct Aeropuerto_Llegada_Pais
    from gd_esquema.Maestra
    where Aeropuerto_Llegada_Pais is not null

    union

    select distinct Aeropuerto_Salida_Pais
    from gd_esquema.Maestra
    where Aeropuerto_Salida_Pais is not null

    union

    select distinct Aerolinea_Pais
    from gd_esquema.Maestra
    where Aerolinea_Pais is not null

    union 

    select distinct Hospedaje_Pais
    from gd_esquema.Maestra
    where Hospedaje_Pais is not null;

end
go

create procedure [DB_LOPERS].Migrar_Canal_Venta
as 
begin 
    insert into [DB_LOPERS].Canal_Venta (Descripcion)

    select distinct Venta_Canal_Venta
    from gd_esquema.Maestra
    where Venta_Canal_Venta is not null;
end
go

create procedure [DB_LOPERS].Migrar_Medio_Pago
as
begin
    insert into [DB_LOPERS].Medio_Pago (Descripcion)

    select distinct Venta_Medio_Pago
    from gd_esquema.Maestra
    where Venta_Medio_Pago is not null;
end
go

create procedure [DB_LOPERS].Migrar_Estado_Propuesta
as
begin
    insert into [DB_LOPERS].Estado_Propuesta (Descripcion)

    select distinct Propuesta_Estado
    from gd_esquema.Maestra
    where Propuesta_Estado is not null;
end
go

create procedure [DB_LOPERS].Migrar_Alianza
as
begin
    insert into [DB_LOPERS].Alianza (Nombre)

    select distinct Aerolinea_Alianza
    from gd_esquema.Maestra
    where Aerolinea_Alianza is not null;
end
go

create procedure [DB_LOPERS].Migrar_Aspecto
as
begin
    insert into [DB_LOPERS].Aspecto (Descripcion)

    select distinct Aspecto_Aspecto
    from gd_esquema.Maestra
    where Aspecto_Aspecto is not null;
end
go

create procedure [DB_LOPERS].Migrar_Proveedor
as
begin
    insert into [DB_LOPERS].Proveedor (Nombre, Mail, Telefono)

    select distinct Proveedor_Nombre, Proveedor_Mail, Proveedor_Telefono
    from gd_esquema.Maestra
    where Proveedor_Nombre is not null;
end
go

create procedure [DB_LOPERS].Migrar_Agencia
as
begin
    insert into [DB_LOPERS].Agencia (Nro_Agencia, ID_Localidad, Direccion, Telefono, Mail)

    select distinct 
        m.Agencia_Nro_Agencia,
        l.ID_Localidad,
        m.Agencia_Direccion,
        m.Agencia_Telefono,
        m.Agencia_Mail
    from gd_esquema.Maestra m
    join [DB_LOPERS].Localidad l on m.Agencia_Localidad = l.Nombre
    where m.Agencia_Nro_Agencia is not null;
end
go

create procedure [DB_LOPERS].Migrar_Aeropuerto
as
begin 
    insert into [DB_LOPERS].Aeropuerto (Codigo, ID_Pais, ID_Ciudad, Descripcion)

    select distinct 
        m.Aeropuerto_Salida_Codigo,
        p.ID_Pais,
        c.ID_Ciudad,
        m.Aeropuerto_Salida_Descripcion
    from gd_esquema.Maestra m
    join [DB_LOPERS].Pais p on m.Aeropuerto_Salida_Pais = p.Nombre
    join [DB_LOPERS].Ciudad c on m.Aeropuerto_Salida_Ciudad = c.Nombre
    where m.Aeropuerto_Salida_Codigo is not null

    union 

    select distinct 
        m.Aeropuerto_Llegada_Codigo,
        p.ID_Pais,
        c.ID_Ciudad,
        m.Aeropuerto_Llegada_Descripcion
    from gd_esquema.Maestra m
    join [DB_LOPERS].Pais p on m.Aeropuerto_Llegada_Pais = p.Nombre
    join [DB_LOPERS].Ciudad c on m.Aeropuerto_Llegada_Ciudad = c.Nombre
    where m.Aeropuerto_Llegada_Codigo is not null;

end
go

create procedure [DB_LOPERS].Migrar_Clientes
as 
begin 
    insert into [DB_LOPERS].Cliente (ID_Localidad, Dni, Nombre, Apellido, Tel, Mail, Direccion, Fecha_Nac)

    select distinct 
        l.ID_Localidad,
        m.Cliente_Dni,
        m.Cliente_Nombre,
        m.Cliente_Apellido,
        m.Cliente_Tel,
        m.Cliente_Mail,
        m.Cliente_Direccion,
        m.Cliente_Fecha_Nac
    from gd_esquema.Maestra m
    join [DB_LOPERS].Localidad l on Cliente_Localidad = l.Nombre
end
go

