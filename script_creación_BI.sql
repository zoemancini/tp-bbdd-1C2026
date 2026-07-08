USE GD1C2026;
GO

-- ====================================================================================
-- SCRIPTS DE ELIMINACION PARA PODER CORRER TODO DE CERO
-- ====================================================================================


IF OBJECT_ID('[DB_LOPERS].[v_satisfaccion_promedio_por_agente]', 'V') IS NOT NULL DROP VIEW [DB_LOPERS].[v_satisfaccion_promedio_por_agente];
IF OBJECT_ID('[DB_LOPERS].[v_ranking_aspectos_valorados]', 'V') IS NOT NULL DROP VIEW [DB_LOPERS].[v_ranking_aspectos_valorados];
IF OBJECT_ID('[DB_LOPERS].[v_desvio_presupuesto]', 'V') IS NOT NULL DROP VIEW [DB_LOPERS].[v_desvio_presupuesto];
IF OBJECT_ID('[DB_LOPERS].[v_tiempo_promedio_respuesta]', 'V') IS NOT NULL DROP VIEW [DB_LOPERS].[v_tiempo_promedio_respuesta];
IF OBJECT_ID('[DB_LOPERS].[v_cotizacion_promedio_por_temporada]', 'V') IS NOT NULL DROP VIEW [DB_LOPERS].[v_cotizacion_promedio_por_temporada];
IF OBJECT_ID('[DB_LOPERS].[v_tasa_aceptacion_propuestas]', 'V') IS NOT NULL DROP VIEW [DB_LOPERS].[v_tasa_aceptacion_propuestas];
IF OBJECT_ID('[DB_LOPERS].[v_anticipacion_promedio_solicitudes]', 'V') IS NOT NULL DROP VIEW [DB_LOPERS].[v_anticipacion_promedio_solicitudes];
IF OBJECT_ID('[DB_LOPERS].[v_ranking_solicitudes_por_temporada]', 'V') IS NOT NULL DROP VIEW [DB_LOPERS].[v_ranking_solicitudes_por_temporada];
IF OBJECT_ID('[DB_LOPERS].[v_distribucion_facturacion_cuatrimestral]', 'V') IS NOT NULL DROP VIEW [DB_LOPERS].[v_distribucion_facturacion_cuatrimestral];
IF OBJECT_ID('[DB_LOPERS].[v_ticket_promedio_mensual]', 'V') IS NOT NULL DROP VIEW [DB_LOPERS].[v_ticket_promedio_mensual];


IF OBJECT_ID('[DB_LOPERS].[Migrar_Modelo_BI]', 'P') IS NOT NULL DROP PROCEDURE [DB_LOPERS].[Migrar_Modelo_BI];


IF OBJECT_ID('[DB_LOPERS].[BI_Hecho_Encuesta]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Hecho_Encuesta];
IF OBJECT_ID('[DB_LOPERS].[BI_Hecho_Propuesta]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Hecho_Propuesta];
IF OBJECT_ID('[DB_LOPERS].[BI_Hecho_Solicitud]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Hecho_Solicitud];
IF OBJECT_ID('[DB_LOPERS].[BI_Hecho_Venta]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Hecho_Venta];


IF OBJECT_ID('[DB_LOPERS].[BI_Aspecto]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Aspecto];
IF OBJECT_ID('[DB_LOPERS].[BI_Estado_Propuesta]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Estado_Propuesta];
IF OBJECT_ID('[DB_LOPERS].[BI_Canal_Venta]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Canal_Venta];
IF OBJECT_ID('[DB_LOPERS].[BI_Tipo_Servicio]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Tipo_Servicio];
IF OBJECT_ID('[DB_LOPERS].[BI_Rango_Etario_Agente]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Rango_Etario_Agente];
IF OBJECT_ID('[DB_LOPERS].[BI_Rango_Etario_Cliente]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Rango_Etario_Cliente];
IF OBJECT_ID('[DB_LOPERS].[BI_Tiempo]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Tiempo];
GO

-- ====================================================================================
-- CREACIÓN DE TABLAS DE DIMENSIONES
-- ====================================================================================

CREATE TABLE [DB_LOPERS].[BI_Tiempo] (
    ID_Tiempo bigint PRIMARY KEY,
    Fecha date NOT NULL,
    Anio int NOT NULL,
    Cuatrimestre int NOT NULL,
    Mes int NOT NULL,
    Mes_Nombre nvarchar(50) NOT NULL,
    Temporada nvarchar(50) NOT NULL
);
GO

CREATE TABLE [DB_LOPERS].[BI_Rango_Etario_Cliente] (
    ID_Rango_Etario int IDENTITY(1,1) PRIMARY KEY,
    Descripcion nvarchar(50) NOT NULL
);
GO

CREATE TABLE [DB_LOPERS].[BI_Rango_Etario_Agente] (
    ID_Rango_Etario int IDENTITY(1,1) PRIMARY KEY,
    Descripcion nvarchar(50) NOT NULL
);
GO

CREATE TABLE [DB_LOPERS].[BI_Tipo_Servicio] (
    ID_Tipo_Servicio bigint PRIMARY KEY,
    Descripcion nvarchar(100) NOT NULL
);
GO

CREATE TABLE [DB_LOPERS].[BI_Canal_Venta] (
    ID_Canal_Venta bigint PRIMARY KEY,
    Descripcion nvarchar(255) NOT NULL
);
GO

CREATE TABLE [DB_LOPERS].[BI_Estado_Propuesta] (
    ID_Estado_Propuesta bigint PRIMARY KEY,
    Descripcion nvarchar(255) NOT NULL
);
GO

CREATE TABLE [DB_LOPERS].[BI_Aspecto] (
    ID_Aspecto bigint PRIMARY KEY,
    Descripcion nvarchar(255) NOT NULL
);
GO


-- ====================================================================================
-- CREACIÓN DE TABLAS DE HECHOS
-- ====================================================================================


CREATE TABLE [DB_LOPERS].[BI_Hecho_Venta] (
    ID_Rango_Etario_Cliente int NOT NULL,
    ID_Rango_Etario_Agente int NOT NULL,
    ID_Canal_Venta bigint NOT NULL,
    ID_Tiempo bigint NOT NULL,
    ID_Tipo_Servicio bigint NOT NULL,
    
    
    Cant_Ventas int NOT NULL,
    Suma_Facturacion decimal(18,2) NOT NULL,

    PRIMARY KEY (ID_Rango_Etario_Cliente, ID_Rango_Etario_Agente, ID_Canal_Venta, ID_Tiempo, ID_Tipo_Servicio),
    CONSTRAINT FK_BI_Hecho_Venta_Cliente FOREIGN KEY (ID_Rango_Etario_Cliente) REFERENCES [DB_LOPERS].[BI_Rango_Etario_Cliente](ID_Rango_Etario),
    CONSTRAINT FK_BI_Hecho_Venta_Agente FOREIGN KEY (ID_Rango_Etario_Agente) REFERENCES [DB_LOPERS].[BI_Rango_Etario_Agente](ID_Rango_Etario),
    CONSTRAINT FK_BI_Hecho_Venta_Canal FOREIGN KEY (ID_Canal_Venta) REFERENCES [DB_LOPERS].[BI_Canal_Venta](ID_Canal_Venta),
    CONSTRAINT FK_BI_Hecho_Venta_Tiempo FOREIGN KEY (ID_Tiempo) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo),
    CONSTRAINT FK_BI_Hecho_Venta_Servicio FOREIGN KEY (ID_Tipo_Servicio) REFERENCES [DB_LOPERS].[BI_Tipo_Servicio](ID_Tipo_Servicio)
);
GO


CREATE TABLE [DB_LOPERS].[BI_Hecho_Solicitud] (
    ID_Rango_Etario_Cliente int NOT NULL,
    ID_Rango_Etario_Agente int NOT NULL,
    ID_Tiempo_Solicitud bigint NOT NULL,
    
    Cant_Solicitudes int NOT NULL,
    Suma_Anticipacion_Dias int NOT NULL,
    Prom_Anticipacion_Dias decimal(18,2) NOT NULL,
    Suma_Presupuesto_Estimado decimal(18,2) NOT NULL,

    PRIMARY KEY (ID_Rango_Etario_Cliente, ID_Rango_Etario_Agente, ID_Tiempo_Solicitud),
    CONSTRAINT FK_BI_Hecho_Solicitud_Cliente FOREIGN KEY (ID_Rango_Etario_Cliente) REFERENCES [DB_LOPERS].[BI_Rango_Etario_Cliente](ID_Rango_Etario),
    CONSTRAINT FK_BI_Hecho_Solicitud_Agente FOREIGN KEY (ID_Rango_Etario_Agente) REFERENCES [DB_LOPERS].[BI_Rango_Etario_Agente](ID_Rango_Etario),
    CONSTRAINT FK_BI_Hecho_Solicitud_Tiempo FOREIGN KEY (ID_Tiempo_Solicitud) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo)
);
GO


CREATE TABLE [DB_LOPERS].[BI_Hecho_Propuesta] (
    ID_Rango_Etario_Agente int NOT NULL,
    ID_Estado_Propuesta bigint NOT NULL,
    ID_Tiempo_Emision bigint NOT NULL,
    ID_Tiempo_Solicitud bigint NOT NULL,
    ID_Tiempo_Viaje_Inicio bigint NOT NULL,
    
    Cant_Propuestas int NOT NULL,
    Cant_Aceptadas int NOT NULL,
    Suma_Cotizacion decimal(18,2) NOT NULL,
    Prom_Cotizacion decimal(18,2) NOT NULL,
    Suma_Desvio_Presupuesto decimal(18,2) NOT NULL,
    Prom_Desvio_Presupuesto decimal(18,2) NOT NULL,
    Suma_Dias_Respuesta int NOT NULL,
    Prom_Dias_Respuesta decimal(18,2) NOT NULL,

    PRIMARY KEY (ID_Rango_Etario_Agente, ID_Estado_Propuesta, ID_Tiempo_Emision, ID_Tiempo_Solicitud, ID_Tiempo_Viaje_Inicio),
    CONSTRAINT FK_BI_Hecho_Propuesta_Agente FOREIGN KEY (ID_Rango_Etario_Agente) REFERENCES [DB_LOPERS].[BI_Rango_Etario_Agente](ID_Rango_Etario),
    CONSTRAINT FK_BI_Hecho_Propuesta_Estado FOREIGN KEY (ID_Estado_Propuesta) REFERENCES [DB_LOPERS].[BI_Estado_Propuesta](ID_Estado_Propuesta),
    CONSTRAINT FK_BI_Hecho_Propuesta_TiempoEmis FOREIGN KEY (ID_Tiempo_Emision) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo),
    CONSTRAINT FK_BI_Hecho_Propuesta_TiempoSol FOREIGN KEY (ID_Tiempo_Solicitud) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo),
    CONSTRAINT FK_BI_Hecho_Propuesta_TiempoViaje FOREIGN KEY (ID_Tiempo_Viaje_Inicio) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo)
);
GO


CREATE TABLE [DB_LOPERS].[BI_Hecho_Encuesta] (
    ID_Rango_Etario_Cliente int NOT NULL,
    ID_Rango_Etario_Agente int NOT NULL,
    ID_Tiempo bigint NOT NULL,
    ID_Aspecto bigint NOT NULL,
    
    Cant_Encuestas int NOT NULL,
    Suma_Puntaje int NOT NULL,
    Prom_Puntaje decimal(18,2) NOT NULL,

    PRIMARY KEY (ID_Rango_Etario_Cliente, ID_Rango_Etario_Agente, ID_Tiempo, ID_Aspecto),
    CONSTRAINT FK_BI_Hecho_Encuesta_Cliente FOREIGN KEY (ID_Rango_Etario_Cliente) REFERENCES [DB_LOPERS].[BI_Rango_Etario_Cliente](ID_Rango_Etario),
    CONSTRAINT FK_BI_Hecho_Encuesta_Agente FOREIGN KEY (ID_Rango_Etario_Agente) REFERENCES [DB_LOPERS].[BI_Rango_Etario_Agente](ID_Rango_Etario),
    CONSTRAINT FK_BI_Hecho_Encuesta_Tiempo FOREIGN KEY (ID_Tiempo) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo),
    CONSTRAINT FK_BI_Hecho_Encuesta_Aspecto FOREIGN KEY (ID_Aspecto) REFERENCES [DB_LOPERS].[BI_Aspecto](ID_Aspecto)
);
GO


-- ====================================================================================
-- PROCESO DE MIGRACIÓN Y CARGA DE DATOS
-- ====================================================================================
CREATE PROCEDURE [DB_LOPERS].Migrar_Modelo_BI
AS
BEGIN
    SET NOCOUNT ON;

    
    DECLARE @MinDate DATE, @MaxDate DATE;
    SELECT @MinDate = MIN(MinF), @MaxDate = MAX(MaxF)
    FROM (
        SELECT MIN(Fecha_Venta) as MinF, MAX(Fecha_Venta) as MaxF FROM [DB_LOPERS].Venta
        UNION ALL
        SELECT MIN(Fecha_Solicitud) as MinF, MAX(Fecha_Solicitud) as MaxF FROM [DB_LOPERS].Solicitud
        UNION ALL
        SELECT MIN(Fecha_Inicio_Tentativa) as MinF, MAX(Fecha_Inicio_Tentativa) as MaxF FROM [DB_LOPERS].Solicitud
        UNION ALL
        SELECT MIN(Fecha_Emision) as MinF, MAX(Fecha_Emision) as MaxF FROM [DB_LOPERS].Propuesta
        UNION ALL
        SELECT MIN(Fecha_Desde) as MinF, MAX(Fecha_Desde) as MaxF FROM [DB_LOPERS].Propuesta
        UNION ALL
        SELECT MIN(Fecha_Encuesta) as MinF, MAX(Fecha_Encuesta) as MaxF FROM [DB_LOPERS].Encuesta
    ) as Dates;

    WHILE @MinDate <= @MaxDate
    BEGIN
        INSERT INTO [DB_LOPERS].BI_Tiempo (ID_Tiempo, Fecha, Anio, Cuatrimestre, Mes, Mes_Nombre, Temporada)
        VALUES (
            CAST(FORMAT(@MinDate, 'yyyyMMdd') AS bigint),
            @MinDate,
            YEAR(@MinDate),
            ((MONTH(@MinDate) - 1) / 4) + 1,
            MONTH(@MinDate),
            CHOOSE(MONTH(@MinDate), 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'),
            CASE 
                WHEN MONTH(@MinDate) IN (1, 2, 3) THEN 'Verano'
                WHEN MONTH(@MinDate) IN (4, 5, 6) THEN 'Otoño'
                WHEN MONTH(@MinDate) IN (7, 8, 9) THEN 'Invierno'
                ELSE 'Primavera' 
            END
        );
        SET @MinDate = DATEADD(day, 1, @MinDate);
    END;

    INSERT INTO [DB_LOPERS].BI_Rango_Etario_Cliente (Descripcion)
    VALUES 
        ('Menores de 25 años inclusive'),
        ('Entre 25 y 35 años inclusive'),
        ('Entre 35 y 50 años inclusive'),
        ('Mayores de 50 años');

    INSERT INTO [DB_LOPERS].BI_Rango_Etario_Agente (Descripcion)
    VALUES 
        ('Entre 25 y 35 años'),
        ('Entre 35 y 50 años'),
        ('Mayores de 50 años');


    INSERT INTO [DB_LOPERS].BI_Canal_Venta (ID_Canal_Venta, Descripcion)
    SELECT ID_Canal_Venta, Descripcion FROM [DB_LOPERS].Canal_Venta;


    INSERT INTO [DB_LOPERS].BI_Estado_Propuesta (ID_Estado_Propuesta, Descripcion)
    SELECT ID_Estado_Propuesta, Descripcion FROM [DB_LOPERS].Estado_Propuesta;


    INSERT INTO [DB_LOPERS].BI_Aspecto (ID_Aspecto, Descripcion)
    SELECT ID_Aspecto, Descripcion FROM [DB_LOPERS].Aspecto;


    INSERT INTO [DB_LOPERS].BI_Tipo_Servicio (ID_Tipo_Servicio, Descripcion)
    VALUES 
        (1, 'Venta Directa'),
        (2, 'Propuesta a Medida');

    
    
    INSERT INTO [DB_LOPERS].BI_Hecho_Venta (ID_Rango_Etario_Cliente, ID_Rango_Etario_Agente, ID_Canal_Venta, ID_Tiempo, ID_Tipo_Servicio, Cant_Ventas, Suma_Facturacion)
    SELECT 
        (SELECT ID_Rango_Etario FROM [DB_LOPERS].BI_Rango_Etario_Cliente WHERE Descripcion = 
            CASE 
                WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 25 THEN 'Menores de 25 años inclusive'
                WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años inclusive'
                WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años inclusive'
                ELSE 'Mayores de 50 años'
            END) AS ID_Rango_Etario_Cliente,
        (SELECT ID_Rango_Etario FROM [DB_LOPERS].BI_Rango_Etario_Agente WHERE Descripcion = 
            CASE 
                WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años'
                WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años'
                ELSE 'Mayores de 50 años'
            END) AS ID_Rango_Etario_Agente,
        v.ID_Canal_Venta,
        CAST(FORMAT(v.Fecha_Venta, 'yyyyMMdd') AS bigint) AS ID_Tiempo,
        CASE WHEN vp.Propuesta_Nro_Propuesta IS NOT NULL THEN 2 ELSE 1 END AS ID_Tipo_Servicio,
        COUNT(*),
        SUM(v.Importe_Total)
    FROM [DB_LOPERS].Venta v
    JOIN [DB_LOPERS].Cliente c ON v.ID_Cliente = c.ID_Cliente
    JOIN [DB_LOPERS].Agente a ON v.Agente_Legajo = a.Legajo
    LEFT JOIN [DB_LOPERS].Venta_Propuesta vp ON v.Nro_Venta = vp.Venta_Nro_Venta
    GROUP BY 
        CASE 
            WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 25 THEN 'Menores de 25 años inclusive'
            WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años inclusive'
            WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años inclusive'
            ELSE 'Mayores de 50 años'
        END,
        CASE 
            WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años'
            WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años'
            ELSE 'Mayores de 50 años'
        END,
        v.ID_Canal_Venta,
        CAST(FORMAT(v.Fecha_Venta, 'yyyyMMdd') AS bigint),
        CASE WHEN vp.Propuesta_Nro_Propuesta IS NOT NULL THEN 2 ELSE 1 END;


    INSERT INTO [DB_LOPERS].BI_Hecho_Solicitud (ID_Rango_Etario_Cliente, ID_Rango_Etario_Agente, ID_Tiempo_Solicitud, Cant_Solicitudes, Suma_Anticipacion_Dias, Prom_Anticipacion_Dias, Suma_Presupuesto_Estimado)
    SELECT 
        (SELECT ID_Rango_Etario FROM [DB_LOPERS].BI_Rango_Etario_Cliente WHERE Descripcion = 
            CASE 
                WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 25 THEN 'Menores de 25 años inclusive'
                WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años inclusive'
                WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años inclusive'
                ELSE 'Mayores de 50 años'
            END),
        (SELECT ID_Rango_Etario FROM [DB_LOPERS].BI_Rango_Etario_Agente WHERE Descripcion = 
            CASE 
                WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años'
                WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años'
                ELSE 'Mayores de 50 años'
            END),
        CAST(FORMAT(s.Fecha_Solicitud, 'yyyyMMdd') AS bigint),
        COUNT(*),
        SUM(DATEDIFF(day, s.Fecha_Solicitud, s.Fecha_Inicio_Tentativa)),
        AVG(CAST(DATEDIFF(day, s.Fecha_Solicitud, s.Fecha_Inicio_Tentativa) AS decimal(18,2))),
        SUM(s.Presupuesto_Estimado)
    FROM [DB_LOPERS].Solicitud s
    JOIN [DB_LOPERS].Cliente c ON s.ID_Cliente = c.ID_Cliente
    JOIN [DB_LOPERS].Agente a ON s.Agente_Legajo = a.Legajo
    GROUP BY 
        CASE 
            WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 25 THEN 'Menores de 25 años inclusive'
            WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años inclusive'
            WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años inclusive'
            ELSE 'Mayores de 50 años'
        END,
        CASE 
            WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años'
            WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años'
            ELSE 'Mayores de 50 años'
        END,
        CAST(FORMAT(s.Fecha_Solicitud, 'yyyyMMdd') AS bigint);


    INSERT INTO [DB_LOPERS].BI_Hecho_Propuesta (ID_Rango_Etario_Agente, ID_Estado_Propuesta, ID_Tiempo_Emision, ID_Tiempo_Solicitud, ID_Tiempo_Viaje_Inicio, Cant_Propuestas, Cant_Aceptadas, Suma_Cotizacion, Prom_Cotizacion, Suma_Desvio_Presupuesto, Prom_Desvio_Presupuesto, Suma_Dias_Respuesta, Prom_Dias_Respuesta)
    SELECT 
        (SELECT ID_Rango_Etario FROM [DB_LOPERS].BI_Rango_Etario_Agente WHERE Descripcion = 
            CASE 
                WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años'
                WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años'
                ELSE 'Mayores de 50 años'
            END),
        p.ID_Estado_Propuesta,
        CAST(FORMAT(p.Fecha_Emision, 'yyyyMMdd') AS bigint),
        CAST(FORMAT(s.Fecha_Solicitud, 'yyyyMMdd') AS bigint),
        CAST(FORMAT(p.Fecha_Desde, 'yyyyMMdd') AS bigint),
        COUNT(*),
        SUM(CASE WHEN LOWER(ep.Descripcion) LIKE '%aceptada%' THEN 1 ELSE 0 END),
        SUM(p.Importe_Total),
        AVG(p.Importe_Total),
        SUM(p.Importe_Total - s.Presupuesto_Estimado),
        AVG(p.Importe_Total - s.Presupuesto_Estimado),
        SUM(DATEDIFF(day, s.Fecha_Solicitud, p.Fecha_Emision)),
        AVG(CAST(DATEDIFF(day, s.Fecha_Solicitud, p.Fecha_Emision) AS decimal(18,2)))
    FROM [DB_LOPERS].Propuesta p
    JOIN [DB_LOPERS].Agente a ON p.Agente_Legajo = a.Legajo
    JOIN [DB_LOPERS].Solicitud s ON p.Solicitud_Nro_Solicitud = s.Nro_Solicitud
    JOIN [DB_LOPERS].Estado_Propuesta ep ON p.ID_Estado_Propuesta = ep.ID_Estado_Propuesta
    GROUP BY 
        CASE 
            WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años'
            WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años'
            ELSE 'Mayores de 50 años'
        END,
        p.ID_Estado_Propuesta,
        CAST(FORMAT(p.Fecha_Emision, 'yyyyMMdd') AS bigint),
        CAST(FORMAT(s.Fecha_Solicitud, 'yyyyMMdd') AS bigint),
        CAST(FORMAT(p.Fecha_Desde, 'yyyyMMdd') AS bigint);

    INSERT INTO [DB_LOPERS].BI_Hecho_Encuesta (ID_Rango_Etario_Cliente, ID_Rango_Etario_Agente, ID_Tiempo, ID_Aspecto, Cant_Encuestas, Suma_Puntaje, Prom_Puntaje)
    SELECT 
        (SELECT ID_Rango_Etario FROM [DB_LOPERS].BI_Rango_Etario_Cliente WHERE Descripcion = 
            CASE 
                WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 25 THEN 'Menores de 25 años inclusive'
                WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años inclusive'
                WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años inclusive'
                ELSE 'Mayores de 50 años'
            END),
        (SELECT ID_Rango_Etario FROM [DB_LOPERS].BI_Rango_Etario_Agente WHERE Descripcion = 
            CASE 
                WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años'
                WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años'
                ELSE 'Mayores de 50 años'
            END),
        CAST(FORMAT(e.Fecha_Encuesta, 'yyyyMMdd') AS bigint),
        de.ID_Aspecto,
        COUNT(*),
        SUM(de.Puntaje),
        AVG(CAST(de.Puntaje AS decimal(18,2)))
    FROM [DB_LOPERS].Encuesta e
    JOIN [DB_LOPERS].Cliente c ON e.ID_Cliente = c.ID_Cliente
    JOIN [DB_LOPERS].Agente a ON e.Agente_Legajo = a.Legajo
    JOIN [DB_LOPERS].Detalle_Encuesta de ON e.Codigo_Encuesta = de.Encuesta_Codigo_Encuesta
    GROUP BY 
        CASE 
            WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 25 THEN 'Menores de 25 años inclusive'
            WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años inclusive'
            WHEN (DATEDIFF(YEAR, c.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(c.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(c.Fecha_Nac) = MONTH(GETDATE()) AND DAY(c.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años inclusive'
            ELSE 'Mayores de 50 años'
        END,
        CASE 
            WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años'
            WHEN (DATEDIFF(YEAR, a.Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(a.Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(a.Fecha_Nac) = MONTH(GETDATE()) AND DAY(a.Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años'
            ELSE 'Mayores de 50 años'
        END,
        CAST(FORMAT(e.Fecha_Encuesta, 'yyyyMMdd') AS bigint),
        de.ID_Aspecto;

END;
GO

EXEC [DB_LOPERS].Migrar_Modelo_BI;
GO


-- ====================================================================================
-- CREACIÓN DE VISTAS
-- ====================================================================================

CREATE VIEW [DB_LOPERS].v_ticket_promedio_mensual AS
SELECT 
    t.Anio AS [Año],
    t.Mes AS [Mes],
    c.Descripcion AS [Rango Etario Cliente],
    cv.Descripcion AS [Canal de Venta],
    CAST(SUM(hv.Suma_Facturacion) / SUM(hv.Cant_Ventas) AS decimal(18,2)) AS [Ticket Promedio]
FROM [DB_LOPERS].BI_Hecho_Venta hv
JOIN [DB_LOPERS].BI_Tiempo t ON hv.ID_Tiempo = t.ID_Tiempo
JOIN [DB_LOPERS].BI_Rango_Etario_Cliente c ON hv.ID_Rango_Etario_Cliente = c.ID_Rango_Etario
JOIN [DB_LOPERS].BI_Canal_Venta cv ON hv.ID_Canal_Venta = cv.ID_Canal_Venta
GROUP BY t.Anio, t.Mes, c.Descripcion, cv.Descripcion;
GO

CREATE VIEW [DB_LOPERS].v_distribucion_facturacion_cuatrimestral AS
SELECT 
    t.Anio AS [Año],
    t.Cuatrimestre AS [Cuatrimestre],
    ts.Descripcion AS [Tipo de Servicio],
    SUM(hv.Suma_Facturacion) AS [Facturacion Total],
    CAST(SUM(hv.Suma_Facturacion) * 100.0 / SUM(SUM(hv.Suma_Facturacion)) OVER(PARTITION BY t.Anio, t.Cuatrimestre) AS decimal(18,2)) AS [Porcentaje Facturación]
FROM [DB_LOPERS].BI_Hecho_Venta hv
JOIN [DB_LOPERS].BI_Tiempo t ON hv.ID_Tiempo = t.ID_Tiempo
JOIN [DB_LOPERS].BI_Tipo_Servicio ts ON hv.ID_Tipo_Servicio = ts.ID_Tipo_Servicio
GROUP BY t.Anio, t.Cuatrimestre, ts.Descripcion;
GO

CREATE VIEW [DB_LOPERS].v_ranking_solicitudes_por_temporada AS
SELECT 
    t.Anio AS [Año],
    t.Temporada AS [Temporada],
    c.Descripcion AS [Rango Etario Cliente],
    SUM(hs.Cant_Solicitudes) AS [Cantidad Solicitudes]
FROM [DB_LOPERS].BI_Hecho_Solicitud hs
JOIN [DB_LOPERS].BI_Tiempo t ON hs.ID_Tiempo_Solicitud = t.ID_Tiempo
JOIN [DB_LOPERS].BI_Rango_Etario_Cliente c ON hs.ID_Rango_Etario_Cliente = c.ID_Rango_Etario
GROUP BY t.Anio, t.Temporada, c.Descripcion;
GO

CREATE VIEW [DB_LOPERS].v_anticipacion_promedio_solicitudes AS
SELECT 
    t.Anio AS [Año],
    t.Cuatrimestre AS [Cuatrimestre],
    c.Descripcion AS [Rango Etario Cliente],
    CAST(SUM(hs.Suma_Anticipacion_Dias) * 1.0 / SUM(hs.Cant_Solicitudes) AS decimal(18,2)) AS [Anticipacion Promedio Dias]
FROM [DB_LOPERS].BI_Hecho_Solicitud hs
JOIN [DB_LOPERS].BI_Tiempo t ON hs.ID_Tiempo_Solicitud = t.ID_Tiempo
JOIN [DB_LOPERS].BI_Rango_Etario_Cliente c ON hs.ID_Rango_Etario_Cliente = c.ID_Rango_Etario
GROUP BY t.Anio, t.Cuatrimestre, c.Descripcion;
GO

CREATE VIEW [DB_LOPERS].v_tasa_aceptacion_propuestas AS
SELECT 
    t.Anio AS [Año],
    t.Cuatrimestre AS [Cuatrimestre],
    CAST((SUM(hp.Cant_Aceptadas) * 100.0 / SUM(hp.Cant_Propuestas)) AS decimal(18,2)) AS [Porcentaje Aceptacion]
FROM [DB_LOPERS].BI_Hecho_Propuesta hp
JOIN [DB_LOPERS].BI_Tiempo t ON hp.ID_Tiempo_Emision = t.ID_Tiempo
GROUP BY t.Anio, t.Cuatrimestre;
GO

CREATE VIEW [DB_LOPERS].v_cotizacion_promedio_por_temporada AS
SELECT 
    t.Anio AS [Año Viaje],
    t.Temporada AS [Temporada Viaje],
    CAST(SUM(hp.Suma_Cotizacion) / SUM(hp.Cant_Propuestas) AS decimal(18,2)) AS [Cotizacion Promedio]
FROM [DB_LOPERS].BI_Hecho_Propuesta hp
JOIN [DB_LOPERS].BI_Tiempo t ON hp.ID_Tiempo_Viaje_Inicio = t.ID_Tiempo
GROUP BY t.Anio, t.Temporada;
GO

CREATE VIEW [DB_LOPERS].v_tiempo_promedio_respuesta AS
SELECT 
    t.Anio AS [Año Solicitud],
    t.Mes AS [Mes Solicitud],
    a.Descripcion AS [Rango Etario Agente],
    CAST(SUM(hp.Suma_Dias_Respuesta) * 1.0 / SUM(hp.Cant_Propuestas) AS decimal(18,2)) AS [Tiempo Promedio Respuesta Dias]
FROM [DB_LOPERS].BI_Hecho_Propuesta hp
JOIN [DB_LOPERS].BI_Tiempo t ON hp.ID_Tiempo_Solicitud = t.ID_Tiempo
JOIN [DB_LOPERS].BI_Rango_Etario_Agente a ON hp.ID_Rango_Etario_Agente = a.ID_Rango_Etario
GROUP BY t.Anio, t.Mes, a.Descripcion;
GO

CREATE VIEW [DB_LOPERS].v_desvio_presupuesto AS
SELECT 
    t.Anio AS [Año Emision],
    t.Cuatrimestre AS [Cuatrimestre Emision],
    CAST(SUM(hp.Suma_Desvio_Presupuesto) / SUM(hp.Cant_Propuestas) AS decimal(18,2)) AS [Desvio Promedio Presupuesto]
FROM [DB_LOPERS].BI_Hecho_Propuesta hp
JOIN [DB_LOPERS].BI_Tiempo t ON hp.ID_Tiempo_Emision = t.ID_Tiempo
GROUP BY t.Anio, t.Cuatrimestre;
GO

CREATE VIEW [DB_LOPERS].v_ranking_aspectos_valorados AS
SELECT 
    t.Anio AS [Año],
    t.Cuatrimestre AS [Cuatrimestre],
    asp.Descripcion AS [Aspecto Evaluado],
    CAST(SUM(he.Suma_Puntaje) * 1.0 / SUM(he.Cant_Encuestas) AS decimal(18,2)) AS [Puntaje Promedio]
FROM [DB_LOPERS].BI_Hecho_Encuesta he
JOIN [DB_LOPERS].BI_Tiempo t ON he.ID_Tiempo = t.ID_Tiempo
JOIN [DB_LOPERS].BI_Aspecto asp ON he.ID_Aspecto = asp.ID_Aspecto
GROUP BY t.Anio, t.Cuatrimestre, asp.Descripcion;
GO

CREATE VIEW [DB_LOPERS].v_satisfaccion_promedio_por_agente AS
SELECT 
    t.Anio AS [Año],
    t.Mes AS [Mes],
    a.Descripcion AS [Rango Etario Agente],
    CAST(SUM(he.Suma_Puntaje) * 1.0 / SUM(he.Cant_Encuestas) AS decimal(18,2)) AS [Satisfaccion Promedio]
FROM [DB_LOPERS].BI_Hecho_Encuesta he
JOIN [DB_LOPERS].BI_Tiempo t ON he.ID_Tiempo = t.ID_Tiempo
JOIN [DB_LOPERS].BI_Rango_Etario_Agente a ON he.ID_Rango_Etario_Agente = a.ID_Rango_Etario
GROUP BY t.Anio, t.Mes, a.Descripcion;
GO

PRINT 'CREACION DE MODELO BI Y MIGRACION FINALIZADA';
GO