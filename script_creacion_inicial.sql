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

create procedure [DB_LOPERS].Migrar_Agente
as
begin
    insert into [DB_LOPERS].Agente (Legajo, Agencia_Nro_Agencia, ID_Localidad, Nombre, Apellido, Dni, Fecha_Nac, Telefono, Mail, Direccion)

    select distinct 
        m.Agente_Legajo,
        m.Agencia_Nro_Agencia,
        l.ID_Localidad,
        m.Agente_Nombre,
        m.Agente_Apellido,
        m.Agente_Dni,
        m.Agente_Fecha_Nac,
        m.Agente_Telefono,
        m.Agente_Mail,
        m.Agente_Direccion
    from gd_esquema.Maestra m 
    join [DB_LOPERS].Localidad l on l.Nombre = m.Agente_Localidad
    where m.Agente_Legajo is not null;
end
go

create procedure [DB_LOPERS].Migrar_Hospedaje
as
begin
    insert into [DB_LOPERS].Hospedaje (ID_Pais, ID_Ciudad, Nombre, Direccion, Incluye_Desayuno, Check_In, Check_Out)

    select distinct 
        p.ID_Pais,
        c.ID_Ciudad,
        m.Hospedaje_Nombre,
        m.Hospedaje_Direccion,
        m.Hospedaje_Incluye_Desayuno,
        m.Hospedaje_Check_In,
        m.Hospedaje_Check_Out
    from gd_esquema.Maestra m
    join [DB_LOPERS].Pais p on p.Nombre = m.Hospedaje_Pais
    join [DB_LOPERS].Ciudad c on c.Nombre = m.Hospedaje_Ciudad
    where m.Hospedaje_Nombre is not null;
end
go

create procedure [DB_LOPERS].Migrar_Habitacion
as
begin
    insert into [DB_LOPERS].Habitacion (ID_Hospedaje, Nombre, Descripcion, Precio_Noche)

    select distinct
        h.ID_Hospedaje,
        m.Habitacion_Nombre,
        m.Habitacion_Descripcion,
        m.Habitacion_Precio_Noche
    from gd_esquema.Maestra m
    join [DB_LOPERS].Hospedaje h on h.Nombre = m.Habitacion_Nombre and h.Direccion = m.Hospedaje_Direccion
    where m.Habitacion_Nombre is not null; 
end
go

create procedure [DB_LOPERS].Migrar_Excursion
as
begin 
    insert into [DB_LOPERS].Excursion (ID_Proveedor, Nombre, Descripcion, Horario, Duracion, Precio)

    select distinct 
        p.ID_Proveedor,
        m.Excursion_Nombre,
        m.Excursion_Descripcion,
        m.Excursion_Horario,
        m.Excursion_Duracion,
        m.Excursion_Precio
    from gd_esquema.Maestra m
    join [DB_LOPERS].Proveedor p on p.Nombre = m.Proveedor_Nombre
    where m.Excursion_Nombre is not null;
end
go

create procedure [DB_LOPERS].Migrar_Vuelo
as
begin
    insert into [DB_LOPERS].Vuelo (Aerolinea_Codigo, Aeropuerto_Salida_Codigo, Aeropuerto_Llegada_Codigo, Fecha_Salida, Horario_Salida, Fecha_Llegada, Horario_Llegada, Duracion, Precio, Incluye_Carry, Incluye_Valija)

    select distinct 
        m.Aerolinea_Codigo,
        m.Aeropuerto_Salida_Codigo,
        m.Aeropuerto_Llegada_Codigo,
        m.Vuelo_Fecha_Salida,
        m.Vuelo_Horario_Salida,
        m.Vuelo_Fecha_Llegada,
        m.Vuelo_Horario_Llegada,
        m.Vuelo_Duracion,
        m.Vuelo_Precio,
        m.Vuelo_Incluye_Carry,
        m.Vuelo_Incluye_Valija
    from gd_esquema.Maestra m
    where m.Vuelo_Fecha_Salida is not null;
end
go

create procedure [DB_LOPERS].Migrar_Solicitud
as
begin 
    insert into [DB_LOPERS].Solicitud (Nro_Solicitud, ID_Cliente, Agente_Legajo, Fecha_Solicitud, Fecha_Inicio_Tentativa, Fecha_Fin_Tentativa, Cant_Pasajeros, Observaciones, Presupuesto_Estimado)

    select distinct 
        m.Solicitud_Nro_Solicitud,
        c.ID_Cliente,
        m.Agente_Legajo,
        m.Solicitud_Fecha_Solicitud,
        m.Solicitud_Fecha_Inicio_Tentativa,
        m.Solicitud_Fecha_Fin_Tentativa,
        m.Solicitud_Cant_Pax,
        m.Solicitud_Observaciones,
        m.Solicitud_Presupuesto_Estimado
    from gd_esquema.Maestra m
    join [DB_LOPERS].Cliente c on c.Dni = m.Cliente_Dni
    where m.Solicitud_Nro_Solicitud is not null;
end
go

create procedure [DB_LOPERS].Migrar_Detalle_Solicitud
as 
begin
    insert into [DB_LOPERS].Detalle_Solicitud (Solicitud_Nro_Solicitud, ID_Ciudad, Cant_Dias_Aprox, Observaciones)

    select distinct 
        m.Solicitud_Nro_Solicitud,
        c.ID_Ciudad,
        m.Detalle_Solicitud_Cant_Dias_Aprox,
        m.Detalle_Solicitud_Observaciones
    from gd_esquema.Maestra m
    join [DB_LOPERS].Ciudad c on c.Nombre = m.Detalle_Solicitud_Ciudad
    where m.Detalle_Solicitud_Ciudad is not null;
end 
go


create procedure [DB_LOPERS].Migrar_Estado_Propuesta
as
begin
    insert into [DB_LOPERS].Propuesta (Nro_Propuesta, Solicitud_Nro_Solicitud, Agente_Legajo, ID_Estado_Propuesta, Fecha_Emision, Vigencia_Hasta, Fecha_Desde, Fecha_Hasta, Subtotal, Descuento, Importe_Total)
    select distinct
        m.Propuesta_Nro_Propuesta,
        m.Solicitud_Nro_Solicitud, 
        m.Agente_Legajo, 
        ep.ID_Estado_Propuesta, 
        m.Propuesta_Fecha_Emision, 
        m.Propuesta_Vigencia_Hasta, 
        m.Propuesta_Fecha_Desde, 
        m.Propuesta_Fecha_Hasta, 
        m.Propuesta_Subtotal, 
        m.Propuesta_Descuento, 
        m.Propuesta_Importe_Total
    from gd_esquema.Maestra m
    join [DB_LOPERS].Estado_Propuesta ep on m.Propuesta_Estado = ep.Descripcion
    where m.Propuesta_Nro_Propuesta is not null;
end
go

create procedure [DB_LOPERS].Migrar_Propuesta_Vuelo
as 
begin   
    insert into [DB_LOPERS].Propuesta_Vuelo (Propuesta_Nro_Propuesta, ID_Vuelo, Cant_Pasajes, Precio, Subtotal)
    select distinct
        m.Propuesta_Nro_Propuesta, 
        v.ID_Vuelo, 
        m.Detalle_Propuesta_Vuelo_Cant_Pasajes, 
        m.Detalle_Propuesta_Vuelo_Precio, 
        m.Detalle_Propuesta_Vuelo_Subtotal
    from gd_esquema.Maestra m
    join [DB_LOPERS].Vuelo v on m.Aerolinea_Codigo = v.Aerolinea_Codigo
        and m.Aeropuerto_Salida_Codigo = v.Aeropuerto_Salida_Codigo 
        and m.Aeropuerto_Llegada_Codigo = v.Aeropuerto_Llegada_Codigo 
        and m.Vuelo_Fecha_Salida = v.Fecha_Salida
    where m.Propuesta_Nro_Propuesta is not null and m.Detalle_Propuesta_Vuelo_Precio is not null;
end
go

create procedure [DB_LOPERS].Migrar_Propuesta_Hospedaje
as
begin
    insert into [DB_LOPERS].Propuesta_Hospedaje (Propuesta_Nro_Propuesta, ID_Habitacion, Fecha_Desde, Fecha_Hasta, Cantidad_Habitaciones, Precio, Subtotal)
    select distinct 
        m.Propuesta_Nro_Propuesta, 
        h.ID_Habitacion, 
        m.Detalle_Propuesta_Hospedaje_Fecha_Desde, 
        m.Detalle_Propuesta_Hospedaje_Fecha_Hasta, 
        m.Detalle_Propuesta_Hospedaje_Cant, 
        m.Detalle_Propuesta_Hospedaje_Precio, 
        m.Detalle_Propuesta_Hospedaje_Subtotal
    from gd_esquema.Maestra m
    join [DB_LOPERS].Hospedaje ho on m.Hospedaje_Nombre = ho.Nombre and m.Hospedaje_Direccion = ho.Direccion
    join [DB_LOPERS].Habitacion h on m.Habitacion_Nombre = h.Nombre and ho.ID_Hospedaje = h.ID_Hospedaje
    where m.Propuesta_Nro_Propuesta is not null and m.Detalle_Propuesta_Hospedaje_Precio is not null;
end
go

create procedure [DB_LOPERS].Migrar_Venta
as
begin
    insert into [DB_LOPERS].Venta (Nro_Venta, ID_Cliente, Agente_Legajo, ID_Canal_Venta, ID_Medio_Pago, Fecha_Venta, Subtotal, Descuento, Importe_Total)
    select distinct 
        m.Venta_Nro_Venta, 
        c.ID_Cliente, 
        m.Agente_Legajo, 
        cv.ID_Canal_Venta, 
        mp.ID_Medio_Pago, 
        m.Venta_Fecha_Venta, 
        m.Venta_Subtotal, 
        m.Venta_Descuento, 
        m.Venta_Importe_Total
    from gd_esquema.Maestra m
    join [DB_LOPERS].Cliente c on m.Cliente_Dni = c.Dni
    join [DB_LOPERS].Canal_Venta cv on m.Venta_Canal_Venta = cv.Descripcion
    join [DB_LOPERS].Medio_Pago mp on m.Venta_Medio_Pago = mp.Descripcion
    where m.Venta_Nro_Venta is not null;
end
go

create procedure [DB_LOPERS].Migrar_Venta_Propuesta
as
begin
    insert into [DB_LOPERS].Venta_Propuesta (Venta_Nro_Venta, Propuesta_Nro_Propuesta)
    select distinct 
        m.Venta_Nro_Venta, 
        m.Propuesta_Nro_Propuesta
    from gd_esquema.Maestra m
    where m.Venta_Nro_Venta is not null and m.Propuesta_Nro_Propuesta is not null;
end
go

create procedure [DB_LOPERS].Migrar_Venta_Vuelo
as
begin
    insert into [DB_LOPERS].Venta_Vuelo (Venta_Nro_Venta, ID_Vuelo, Cantidad_Pasajes, Precio_Unitario, Subtotal, Cod_Reserva)
    select distinct 
        m.Venta_Nro_Venta, 
        v.ID_Vuelo, 
        m.Detalle_Venta_Vuelo_Cantidad_Pasajes, 
        m.Detalle_Venta_Vuelo_Precio_Unitario, 
        m.Detalle_Venta_Vuelo_Subtotal, 
        m.Detalle_Venta_Vuelo_Cod_Reserva
    from gd_esquema.Maestra m
    join [DB_LOPERS].Vuelo v on m.Aerolinea_Codigo = v.Aerolinea_Codigo 
        and m.Aeropuerto_Salida_Codigo = v.Aeropuerto_Salida_Codigo 
        and m.Aeropuerto_Llegada_Codigo = v.Aeropuerto_Llegada_Codigo 
        and m.Vuelo_Fecha_Salida = v.Fecha_Salida
    where m.Venta_Nro_Venta is not null and m.Detalle_Venta_Vuelo_Precio_Unitario is not null;
end
go

create procedure [DB_LOPERS].Migrar_Venta_Hospedaje
as
begin
    insert into [DB_LOPERS].Venta_Hospedaje (Venta_Nro_Venta, ID_Habitacion, Fecha_Desde, Fecha_Hasta, Cantidad_Habitaciones, Precio_Unitario, Subtotal, Cod_Reserva)
    select distinct 
        m.Venta_Nro_Venta, 
        h.ID_Habitacion, 
        m.Detalle_Venta_Hospedaje_Fecha_Desde, 
        m.Detalle_Venta_Hospedaje_Fecha_Hasta, 
        m.Detalle_Venta_Hospedaje_Cantidad, 
        m.Detalle_Venta_Hospedaje_Precio_Unitario, 
        m.Detalle_Venta_Hospedaje_Subtotal, 
        m.Detalle_Venta_Hospedaje_Cod_Reserva
    from gd_esquema.Maestra m
    join [DB_LOPERS].Hospedaje ho on m.Hospedaje_Nombre = ho.Nombre and m.Hospedaje_Direccion = ho.Direccion
    join [DB_LOPERS].Habitacion h on m.Habitacion_Nombre = h.Nombre and ho.ID_Hospedaje = h.ID_Hospedaje
    where m.Venta_Nro_Venta is not null and m.Detalle_Venta_Hospedaje_Precio_Unitario is not null;
end
go

create procedure [DB_LOPERS].Migrar_Venta_Excursion
as
begin
    insert into [DB_LOPERS].Venta_Excursion (Venta_Nro_Venta, ID_Excursion, Fecha_Reserva, Cantidad_Excursiones, Precio_Unitario, Subtotal, Cod_Reserva)
    select distinct 
        m.Venta_Nro_Venta, 
        e.ID_Excursion, 
        m.Detalle_Venta_Excursion_Fecha_Reserva, 
        m.Detalle_Venta_Excursion_Cant, 
        m.Detalle_Venta_Excursion_Precio_Unitario, 
        m.Detalle_Venta_Excursion_Subtotal, 
        m.Detalle_Venta_Excursion_Cod_Reserva
    from gd_esquema.Maestra m
    join [DB_LOPERS].Proveedor p on m.Proveedor_Nombre = p.Nombre
    join [DB_LOPERS].Excursion e on m.Excursion_Nombre = e.Nombre and m.Excursion_Horario = e.Horario and p.ID_Proveedor = e.ID_Proveedor
    where m.Venta_Nro_Venta is not null and m.Detalle_Venta_Excursion_Precio_Unitario is not null;
end
go

create procedure [DB_LOPERS].Migrar_Encuesta
as
begin
    insert into [DB_LOPERS].Encuesta (Codigo_Encuesta, ID_Cliente, Agente_Legajo, Fecha_Encuesta, Comentarios)
    select distinct 
        m.Encuesta_Codigo_Encuesta, 
        c.ID_Cliente, 
        m.Agente_Legajo, 
        m.Encuesta_Fecha_Encuesta, 
        m.Encuesta_Comentarios
    from gd_esquema.Maestra m
    join [DB_LOPERS].Cliente c on m.Cliente_Dni = c.Dni
    where m.Encuesta_Codigo_Encuesta is not null;
end
go

create procedure [DB_LOPERS].Migrar_Detalle_Encuesta
as
begin
    insert into [DB_LOPERS].Detalle_Encuesta (Encuesta_Codigo_Encuesta, ID_Aspecto, Puntaje)
    select distinct 
        m.Encuesta_Codigo_Encuesta, 
        a.ID_Aspecto, 
        m.Detalle_Encuesta_Puntaje
    from gd_esquema.Maestra m
    join [DB_LOPERS].Aspecto a on m.Aspecto_Aspecto = a.Descripcion
    where m.Encuesta_Codigo_Encuesta is not null and m.Aspecto_Aspecto is not null;
end
go