USE GD1C2026;
GO

-- ====================================================================================
-- SCRIPTS DE ELIMINACION PARA PODER CORRER TODO DE CERO
-- ====================================================================================

-- Eliminación de Vistas Analíticas
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

-- Eliminación de Procedimientos de Migración BI
IF OBJECT_ID('[DB_LOPERS].[Migrar_Modelo_BI]', 'P') IS NOT NULL DROP PROCEDURE [DB_LOPERS].[Migrar_Modelo_BI];

-- Eliminación de Tablas de Hechos
IF OBJECT_ID('[DB_LOPERS].[BI_Hecho_Encuesta]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Hecho_Encuesta];
IF OBJECT_ID('[DB_LOPERS].[BI_Hecho_Propuesta]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Hecho_Propuesta];
IF OBJECT_ID('[DB_LOPERS].[BI_Hecho_Solicitud]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Hecho_Solicitud];
IF OBJECT_ID('[DB_LOPERS].[BI_Hecho_Venta]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Hecho_Venta];

-- Eliminación de Tablas de Dimensiones
IF OBJECT_ID('[DB_LOPERS].[BI_Aspecto]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Aspecto];
IF OBJECT_ID('[DB_LOPERS].[BI_Estado_Propuesta]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Estado_Propuesta];
IF OBJECT_ID('[DB_LOPERS].[BI_Canal_Venta]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Canal_Venta];
IF OBJECT_ID('[DB_LOPERS].[BI_Tipo_Servicio]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Tipo_Servicio];
IF OBJECT_ID('[DB_LOPERS].[BI_Agente]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Agente];
IF OBJECT_ID('[DB_LOPERS].[BI_Cliente]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Cliente];
IF OBJECT_ID('[DB_LOPERS].[BI_Tiempo]', 'U') IS NOT NULL DROP TABLE [DB_LOPERS].[BI_Tiempo];
GO


-- ====================================================================================
-- CREACIÓN DE TABLAS DE DIMENSIONES
-- ====================================================================================

-- Dimensión Tiempo (Denormaliza fecha, año, cuatrimestre, mes, nombre del mes y temporada)
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

-- Dimensión Cliente (Denormaliza el rango etario del cliente)
CREATE TABLE [DB_LOPERS].[BI_Cliente] (
                                          ID_Cliente bigint PRIMARY KEY,
                                          Dni nvarchar(255) NOT NULL,
    Nombre nvarchar(255),
    Apellido nvarchar(255),
    Rango_Etario_Cliente nvarchar(50) NOT NULL
    );
GO

-- Dimensión Agente (Denormaliza el rango etario del agente)
CREATE TABLE [DB_LOPERS].[BI_Agente] (
                                         Legajo bigint PRIMARY KEY,
                                         Dni nvarchar(255) NOT NULL,
    Nombre nvarchar(255),
    Apellido nvarchar(255),
    Rango_Etario_Agente nvarchar(50) NOT NULL
    );
GO

-- Dimensión Tipo Servicio (Venta Directa vs Propuesta a Medida)
CREATE TABLE [DB_LOPERS].[BI_Tipo_Servicio] (
                                                ID_Tipo_Servicio bigint PRIMARY KEY,
                                                Descripcion nvarchar(100) NOT NULL
    );
GO

-- Dimensión Canal de Venta
CREATE TABLE [DB_LOPERS].[BI_Canal_Venta] (
                                              ID_Canal_Venta bigint PRIMARY KEY,
                                              Descripcion nvarchar(255) NOT NULL
    );
GO

-- Dimensión Estado Propuesta
CREATE TABLE [DB_LOPERS].[BI_Estado_Propuesta] (
                                                   ID_Estado_Propuesta bigint PRIMARY KEY,
                                                   Descripcion nvarchar(255) NOT NULL
    );
GO

-- Dimensión Aspectos de Encuesta (Aspecto evaluado comercialmente)
CREATE TABLE [DB_LOPERS].[BI_Aspecto] (
                                          ID_Aspecto bigint PRIMARY KEY,
                                          Descripcion nvarchar(255) NOT NULL
    );
GO


-- ====================================================================================
-- CREACIÓN DE TABLAS DE HECHOS
-- ====================================================================================

-- Hecho Ventas (Mide la facturación comercial de la agencia)
CREATE TABLE [DB_LOPERS].[BI_Hecho_Venta] (
                                              ID_Cliente bigint NOT NULL,
                                              Legajo_Agente bigint NOT NULL,
                                              ID_Canal_Venta bigint NOT NULL,
                                              ID_Tiempo bigint NOT NULL,
                                              ID_Tipo_Servicio bigint NOT NULL,
                                              Importe_Total decimal(18,2) NOT NULL,
    Cant_Ventas int DEFAULT 1,
    CONSTRAINT FK_BI_Hecho_Venta_Cliente FOREIGN KEY (ID_Cliente) REFERENCES [DB_LOPERS].[BI_Cliente](ID_Cliente),
    CONSTRAINT FK_BI_Hecho_Venta_Agente FOREIGN KEY (Legajo_Agente) REFERENCES [DB_LOPERS].[BI_Agente](Legajo),
    CONSTRAINT FK_BI_Hecho_Venta_Canal FOREIGN KEY (ID_Canal_Venta) REFERENCES [DB_LOPERS].[BI_Canal_Venta](ID_Canal_Venta),
    CONSTRAINT FK_BI_Hecho_Venta_Tiempo FOREIGN KEY (ID_Tiempo) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo),
    CONSTRAINT FK_BI_Hecho_Venta_Servicio FOREIGN KEY (ID_Tipo_Servicio) REFERENCES [DB_LOPERS].[BI_Tipo_Servicio](ID_Tipo_Servicio)
    );
GO

-- Hecho Solicitudes (Mide el comportamiento de la demanda y anticipación de viajes)
CREATE TABLE [DB_LOPERS].[BI_Hecho_Solicitud] (
                                                  ID_Cliente bigint NOT NULL,
                                                  Legajo_Agente bigint NOT NULL,
                                                  ID_Tiempo_Solicitud bigint NOT NULL,
                                                  Anticipacion_Dias int NOT NULL,
                                                  Cant_Solicitudes int DEFAULT 1,
                                                  Presupuesto_Estimado decimal(18,2) NOT NULL,
    CONSTRAINT FK_BI_Hecho_Solicitud_Cliente FOREIGN KEY (ID_Cliente) REFERENCES [DB_LOPERS].[BI_Cliente](ID_Cliente),
    CONSTRAINT FK_BI_Hecho_Solicitud_Agente FOREIGN KEY (Legajo_Agente) REFERENCES [DB_LOPERS].[BI_Agente](Legajo),
    CONSTRAINT FK_BI_Hecho_Solicitud_Tiempo FOREIGN KEY (ID_Tiempo_Solicitud) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo)
    );
GO

-- Hecho Propuestas (Mide conversión de ventas, cotizaciones, tiempos de respuesta y desvíos)
CREATE TABLE [DB_LOPERS].[BI_Hecho_Propuesta] (
                                                  Legajo_Agente bigint NOT NULL,
                                                  ID_Estado_Propuesta bigint NOT NULL,
                                                  ID_Tiempo_Emision bigint NOT NULL,
                                                  ID_Tiempo_Solicitud bigint NOT NULL,
                                                  ID_Tiempo_Viaje_Inicio bigint NOT NULL,
                                                  Importe_Total decimal(18,2) NOT NULL,
    Desvio_Presupuesto decimal(18,2) NOT NULL,
    Tiempo_Respuesta_Dias int NOT NULL,
    Cant_Propuestas int DEFAULT 1,
    Aceptada int NOT NULL,
    CONSTRAINT FK_BI_Hecho_Propuesta_Agente FOREIGN KEY (Legajo_Agente) REFERENCES [DB_LOPERS].[BI_Agente](Legajo),
    CONSTRAINT FK_BI_Hecho_Propuesta_Estado FOREIGN KEY (ID_Estado_Propuesta) REFERENCES [DB_LOPERS].[BI_Estado_Propuesta](ID_Estado_Propuesta),
    CONSTRAINT FK_BI_Hecho_Propuesta_TiempoEmis FOREIGN KEY (ID_Tiempo_Emision) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo),
    CONSTRAINT FK_BI_Hecho_Propuesta_TiempoSol FOREIGN KEY (ID_Tiempo_Solicitud) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo),
    CONSTRAINT FK_BI_Hecho_Propuesta_TiempoViaje FOREIGN KEY (ID_Tiempo_Viaje_Inicio) REFERENCES [DB_LOPERS].[BI_Tiempo](ID_Tiempo)
    );
GO

-- Hecho Encuestas (Mide valoraciones de atención comercial y satisfacción)
CREATE TABLE [DB_LOPERS].[BI_Hecho_Encuesta] (
                                                 ID_Cliente bigint NOT NULL,
                                                 Legajo_Agente bigint NOT NULL,
                                                 ID_Tiempo bigint NOT NULL,
                                                 ID_Aspecto bigint NOT NULL,
                                                 Puntaje int NOT NULL,
                                                 CONSTRAINT FK_BI_Hecho_Encuesta_Cliente FOREIGN KEY (ID_Cliente) REFERENCES [DB_LOPERS].[BI_Cliente](ID_Cliente),
    CONSTRAINT FK_BI_Hecho_Encuesta_Agente FOREIGN KEY (Legajo_Agente) REFERENCES [DB_LOPERS].[BI_Agente](Legajo),
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

    -- A. Población de la Dimensiones
    -- Dimension Tiempo: obtenemos el rango mínimo y máximo de todas las fechas
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

    -- Dimensión Cliente
INSERT INTO [DB_LOPERS].BI_Cliente (ID_Cliente, Dni, Nombre, Apellido, Rango_Etario_Cliente)
SELECT
    ID_Cliente,
    Dni,
    Nombre,
    Apellido,
    CASE
        WHEN (DATEDIFF(YEAR, Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(Fecha_Nac) = MONTH(GETDATE()) AND DAY(Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 25 THEN 'Menores de 25 años inclusive'
        WHEN (DATEDIFF(YEAR, Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(Fecha_Nac) = MONTH(GETDATE()) AND DAY(Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años inclusive'
        WHEN (DATEDIFF(YEAR, Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(Fecha_Nac) = MONTH(GETDATE()) AND DAY(Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años inclusive'
        ELSE 'Mayores de 50 años'
        END
FROM [DB_LOPERS].Cliente;

-- Dimensión Agente
INSERT INTO [DB_LOPERS].BI_Agente (Legajo, Dni, Nombre, Apellido, Rango_Etario_Agente)
SELECT
    Legajo,
    Dni,
    Nombre,
    Apellido,
    CASE
        WHEN (DATEDIFF(YEAR, Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(Fecha_Nac) = MONTH(GETDATE()) AND DAY(Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 35 THEN 'Entre 25 y 35 años'
        WHEN (DATEDIFF(YEAR, Fecha_Nac, GETDATE()) - CASE WHEN (MONTH(Fecha_Nac) > MONTH(GETDATE())) OR (MONTH(Fecha_Nac) = MONTH(GETDATE()) AND DAY(Fecha_Nac) > DAY(GETDATE())) THEN 1 ELSE 0 END) <= 50 THEN 'Entre 35 y 50 años'
        ELSE 'Mayores de 50 años'
        END
FROM [DB_LOPERS].Agente;

-- Dimensión Canal de Venta
INSERT INTO [DB_LOPERS].BI_Canal_Venta (ID_Canal_Venta, Descripcion)
SELECT ID_Canal_Venta, Descripcion FROM [DB_LOPERS].Canal_Venta;

-- Dimensión Estado Propuesta
INSERT INTO [DB_LOPERS].BI_Estado_Propuesta (ID_Estado_Propuesta, Descripcion)
SELECT ID_Estado_Propuesta, Descripcion FROM [DB_LOPERS].Estado_Propuesta;

-- Dimensión Aspecto
INSERT INTO [DB_LOPERS].BI_Aspecto (ID_Aspecto, Descripcion)
SELECT ID_Aspecto, Descripcion FROM [DB_LOPERS].Aspecto;

-- Dimensión Tipo Servicio
INSERT INTO [DB_LOPERS].BI_Tipo_Servicio (ID_Tipo_Servicio, Descripcion)
VALUES
    (1, 'Venta Directa'),
    (2, 'Propuesta a Medida');


-- B. Migración de Tablas de Hechos

-- Hecho Ventas
INSERT INTO [DB_LOPERS].BI_Hecho_Venta (ID_Cliente, Legajo_Agente, ID_Canal_Venta, ID_Tiempo, ID_Tipo_Servicio, Importe_Total)
SELECT
    v.ID_Cliente,
    v.Agente_Legajo,
    v.ID_Canal_Venta,
    CAST(FORMAT(v.Fecha_Venta, 'yyyyMMdd') AS bigint),
    -- Si la venta está asociada a una propuesta, es "Propuesta a Medida (2)", sino es "Venta Directa (1)"
    CASE WHEN vp.Propuesta_Nro_Propuesta IS NOT NULL THEN 2 ELSE 1 END,
    v.Importe_Total
FROM [DB_LOPERS].Venta v
    LEFT JOIN [DB_LOPERS].Venta_Propuesta vp ON v.Nro_Venta = vp.Venta_Nro_Venta;

-- Hecho Solicitudes
INSERT INTO [DB_LOPERS].BI_Hecho_Solicitud (ID_Cliente, Legajo_Agente, ID_Tiempo_Solicitud, Anticipacion_Dias, Presupuesto_Estimado)
SELECT
    s.ID_Cliente,
    s.Agente_Legajo,
    CAST(FORMAT(s.Fecha_Solicitud, 'yyyyMMdd') AS bigint),
    DATEDIFF(day, s.Fecha_Solicitud, s.Fecha_Inicio_Tentativa),
    s.Presupuesto_Estimado
FROM [DB_LOPERS].Solicitud s;

-- Hecho Propuestas
INSERT INTO [DB_LOPERS].BI_Hecho_Propuesta (Legajo_Agente, ID_Estado_Propuesta, ID_Tiempo_Emision, ID_Tiempo_Solicitud, ID_Tiempo_Viaje_Inicio, Importe_Total, Desvio_Presupuesto, Tiempo_Respuesta_Dias, Aceptada)
SELECT
    p.Agente_Legajo,
    p.ID_Estado_Propuesta,
    CAST(FORMAT(p.Fecha_Emision, 'yyyyMMdd') AS bigint),
    CAST(FORMAT(s.Fecha_Solicitud, 'yyyyMMdd') AS bigint),
    CAST(FORMAT(p.Fecha_Desde, 'yyyyMMdd') AS bigint),
    p.Importe_Total,
    (p.Importe_Total - s.Presupuesto_Estimado),
    DATEDIFF(day, s.Fecha_Solicitud, p.Fecha_Emision),
    CASE WHEN LOWER(ep.Descripcion) LIKE '%aceptada%' THEN 1 ELSE 0 END
FROM [DB_LOPERS].Propuesta p
    JOIN [DB_LOPERS].Solicitud s ON p.Solicitud_Nro_Solicitud = s.Nro_Solicitud
    JOIN [DB_LOPERS].Estado_Propuesta ep ON p.ID_Estado_Propuesta = ep.ID_Estado_Propuesta;

-- Hecho Encuestas
INSERT INTO [DB_LOPERS].BI_Hecho_Encuesta (ID_Cliente, Legajo_Agente, ID_Tiempo, ID_Aspecto, Puntaje)
SELECT
    e.ID_Cliente,
    e.Agente_Legajo,
    CAST(FORMAT(e.Fecha_Encuesta, 'yyyyMMdd') AS bigint),
    de.ID_Aspecto,
    de.Puntaje
FROM [DB_LOPERS].Encuesta e
    JOIN [DB_LOPERS].Detalle_Encuesta de ON e.Codigo_Encuesta = de.Encuesta_Codigo_Encuesta;

END;
GO

-- Ejecutamos la migracion al modelo BI
EXEC [DB_LOPERS].Migrar_Modelo_BI;
GO


-- ====================================================================================
-- CREACIÓN DE VISTAS
-- ====================================================================================

-- Ticket promedio mensual según rango etario del cliente y canal de venta.
CREATE VIEW [DB_LOPERS].v_ticket_promedio_mensual AS
SELECT
    t.Anio AS [Año],
    t.Mes AS [Mes],
    c.Rango_Etario_Cliente AS [Rango Etario Cliente],
    cv.Descripcion AS [Canal de Venta],
    AVG(hv.Importe_Total) AS [Ticket Promedio]
FROM [DB_LOPERS].BI_Hecho_Venta hv
    JOIN [DB_LOPERS].BI_Tiempo t ON hv.ID_Tiempo = t.ID_Tiempo
    JOIN [DB_LOPERS].BI_Cliente c ON hv.ID_Cliente = c.ID_Cliente
    JOIN [DB_LOPERS].BI_Canal_Venta cv ON hv.ID_Canal_Venta = cv.ID_Canal_Venta
GROUP BY t.Anio, t.Mes, c.Rango_Etario_Cliente, cv.Descripcion;
GO

-- Porcentaje de facturación correspondiente a cada tipo de servicio por cuatrimestre y año.
CREATE VIEW [DB_LOPERS].v_distribucion_facturacion_cuatrimestral AS
SELECT
    t.Anio AS [Año],
    t.Cuatrimestre AS [Cuatrimestre],
    ts.Descripcion AS [Tipo de Servicio],
    SUM(hv.Importe_Total) AS [Facturacion Total],
    CAST(SUM(hv.Importe_Total) * 100.0 / SUM(SUM(hv.Importe_Total)) OVER(PARTITION BY t.Anio, t.Cuatrimestre) AS decimal(18,2)) AS [Porcentaje Facturación]
FROM [DB_LOPERS].BI_Hecho_Venta hv
    JOIN [DB_LOPERS].BI_Tiempo t ON hv.ID_Tiempo = t.ID_Tiempo
    JOIN [DB_LOPERS].BI_Tipo_Servicio ts ON hv.ID_Tipo_Servicio = ts.ID_Tipo_Servicio
GROUP BY t.Anio, t.Cuatrimestre, ts.Descripcion;
GO

-- Ranking de solicitudes realizadas por temporadas del año y rango etario del cliente.
CREATE VIEW [DB_LOPERS].v_ranking_solicitudes_por_temporada AS
SELECT
    t.Anio AS [Año],
    t.Temporada AS [Temporada],
    c.Rango_Etario_Cliente AS [Rango Etario Cliente],
    SUM(hs.Cant_Solicitudes) AS [Cantidad Solicitudes]
FROM [DB_LOPERS].BI_Hecho_Solicitud hs
    JOIN [DB_LOPERS].BI_Tiempo t ON hs.ID_Tiempo_Solicitud = t.ID_Tiempo
    JOIN [DB_LOPERS].BI_Cliente c ON hs.ID_Cliente = c.ID_Cliente
GROUP BY t.Anio, t.Temporada, c.Rango_Etario_Cliente;
GO

-- Anticipación promedio de días de la solicitud de viaje por rango etario y cuatrimestre.
CREATE VIEW [DB_LOPERS].v_anticipacion_promedio_solicitudes AS
SELECT
    t.Anio AS [Año],
    t.Cuatrimestre AS [Cuatrimestre],
    c.Rango_Etario_Cliente AS [Rango Etario Cliente],
    CAST(AVG(CAST(hs.Anticipacion_Dias AS decimal(18,2))) AS decimal(18,2)) AS [Anticipacion Promedio Dias]
FROM [DB_LOPERS].BI_Hecho_Solicitud hs
    JOIN [DB_LOPERS].BI_Tiempo t ON hs.ID_Tiempo_Solicitud = t.ID_Tiempo
    JOIN [DB_LOPERS].BI_Cliente c ON hs.ID_Cliente = c.ID_Cliente
GROUP BY t.Anio, t.Cuatrimestre, c.Rango_Etario_Cliente;
GO

-- Tasa de aceptación de propuestas emitidas por cuatrimestre.
CREATE VIEW [DB_LOPERS].v_tasa_aceptacion_propuestas AS
SELECT
    t.Anio AS [Año],
    t.Cuatrimestre AS [Cuatrimestre],
    CAST((SUM(hp.Aceptada) * 100.0 / SUM(hp.Cant_Propuestas)) AS decimal(18,2)) AS [Porcentaje Aceptacion]
FROM [DB_LOPERS].BI_Hecho_Propuesta hp
    JOIN [DB_LOPERS].BI_Tiempo t ON hp.ID_Tiempo_Emision = t.ID_Tiempo
GROUP BY t.Anio, t.Cuatrimestre;
GO

-- Importe promedio de cotización de propuestas agrupado por temporada de inicio de viaje.
CREATE VIEW [DB_LOPERS].v_cotizacion_promedio_por_temporada AS
SELECT
    t.Anio AS [Año Viaje],
    t.Temporada AS [Temporada Viaje],
    CAST(AVG(hp.Importe_Total) AS decimal(18,2)) AS [Cotizacion Promedio]
FROM [DB_LOPERS].BI_Hecho_Propuesta hp
    JOIN [DB_LOPERS].BI_Tiempo t ON hp.ID_Tiempo_Viaje_Inicio = t.ID_Tiempo
GROUP BY t.Anio, t.Temporada;
GO

-- Tiempo promedio de respuesta (en días) entre solicitud y emisión por rango etario de agente y mes.
CREATE VIEW [DB_LOPERS].v_tiempo_promedio_respuesta AS
SELECT
    t.Anio AS [Año Solicitud],
    t.Mes AS [Mes Solicitud],
    a.Rango_Etario_Agente AS [Rango Etario Agente],
    CAST(AVG(CAST(hp.Tiempo_Respuesta_Dias AS decimal(18,2))) AS decimal(18,2)) AS [Tiempo Promedio Respuesta Dias]
FROM [DB_LOPERS].BI_Hecho_Propuesta hp
    JOIN [DB_LOPERS].BI_Tiempo t ON hp.ID_Tiempo_Solicitud = t.ID_Tiempo
    JOIN [DB_LOPERS].BI_Agente a ON hp.Legajo_Agente = a.Legajo
GROUP BY t.Anio, t.Mes, a.Rango_Etario_Agente;
GO

-- Desvío de presupuesto promedio entre el estimado y el propuesto final por cuatrimestre de emisión.
CREATE VIEW [DB_LOPERS].v_desvio_presupuesto AS
SELECT
    t.Anio AS [Año Emision],
    t.Cuatrimestre AS [Cuatrimestre Emision],
    CAST(AVG(hp.Desvio_Presupuesto) AS decimal(18,2)) AS [Desvio Promedio Presupuesto]
FROM [DB_LOPERS].BI_Hecho_Propuesta hp
    JOIN [DB_LOPERS].BI_Tiempo t ON hp.ID_Tiempo_Emision = t.ID_Tiempo
GROUP BY t.Anio, t.Cuatrimestre;
GO

-- Ranking de aspectos evaluados (mejor y peor valorados) por cuatrimestre.
CREATE VIEW [DB_LOPERS].v_ranking_aspectos_valorados AS
SELECT
    t.Anio AS [Año],
    t.Cuatrimestre AS [Cuatrimestre],
    asp.Descripcion AS [Aspecto Evaluado],
    CAST(AVG(CAST(he.Puntaje AS decimal(18,2))) AS decimal(18,2)) AS [Puntaje Promedio]
FROM [DB_LOPERS].BI_Hecho_Encuesta he
    JOIN [DB_LOPERS].BI_Tiempo t ON he.ID_Tiempo = t.ID_Tiempo
    JOIN [DB_LOPERS].BI_Aspecto asp ON he.ID_Aspecto = asp.ID_Aspecto
GROUP BY t.Anio, t.Cuatrimestre, asp.Descripcion;
GO

-- Satisfacción promedio obtenida en encuestas según rango etario del agente y mes.
CREATE VIEW [DB_LOPERS].v_satisfaccion_promedio_por_agente AS
SELECT
    t.Anio AS [Año],
    t.Mes AS [Mes],
    a.Rango_Etario_Agente AS [Rango Etario Agente],
    CAST(AVG(CAST(he.Puntaje AS decimal(18,2))) AS decimal(18,2)) AS [Satisfaccion Promedio]
FROM [DB_LOPERS].BI_Hecho_Encuesta he
    JOIN [DB_LOPERS].BI_Tiempo t ON he.ID_Tiempo = t.ID_Tiempo
    JOIN [DB_LOPERS].BI_Agente a ON he.Legajo_Agente = a.Legajo
GROUP BY t.Anio, t.Mes, a.Rango_Etario_Agente;
GO

PRINT 'CREACION DE MODELO BI Y MIGRACION FINALIZADA';
GO