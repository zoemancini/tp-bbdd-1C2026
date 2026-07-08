USE GD1C2026;
GO

---------------------------------------------------------------------
-- ELIMINACIÓN DE VISTAS (INDICADORES)
---------------------------------------------------------------------
IF OBJECT_ID('DB_LOPERS.v_ticket_promedio_mensual', 'V') IS NOT NULL
    DROP VIEW [DB_LOPERS].v_ticket_promedio_mensual;

IF OBJECT_ID('DB_LOPERS.v_distribucion_facturacion_cuatrimestral', 'V') IS NOT NULL
    DROP VIEW [DB_LOPERS].v_distribucion_facturacion_cuatrimestral;

IF OBJECT_ID('DB_LOPERS.v_ranking_solicitudes_por_temporada', 'V') IS NOT NULL
    DROP VIEW [DB_LOPERS].v_ranking_solicitudes_por_temporada;

IF OBJECT_ID('DB_LOPERS.v_anticipacion_promedio_solicitudes', 'V') IS NOT NULL
    DROP VIEW [DB_LOPERS].v_anticipacion_promedio_solicitudes;

IF OBJECT_ID('DB_LOPERS.v_tasa_aceptacion_propuestas', 'V') IS NOT NULL
    DROP VIEW [DB_LOPERS].v_tasa_aceptacion_propuestas;

IF OBJECT_ID('DB_LOPERS.v_cotizacion_promedio_por_temporada', 'V') IS NOT NULL
    DROP VIEW [DB_LOPERS].v_cotizacion_promedio_por_temporada;

IF OBJECT_ID('DB_LOPERS.v_tiempo_promedio_respuesta', 'V') IS NOT NULL
    DROP VIEW [DB_LOPERS].v_tiempo_promedio_respuesta;

IF OBJECT_ID('DB_LOPERS.v_desvio_presupuesto', 'V') IS NOT NULL
    DROP VIEW [DB_LOPERS].v_desvio_presupuesto;

IF OBJECT_ID('DB_LOPERS.v_ranking_aspectos_valorados', 'V') IS NOT NULL
    DROP VIEW [DB_LOPERS].v_ranking_aspectos_valorados;

IF OBJECT_ID('DB_LOPERS.v_satisfaccion_promedio_por_agente', 'V') IS NOT NULL
    DROP VIEW [DB_LOPERS].v_satisfaccion_promedio_por_agente;

---------------------------------------------------------------------
-- ELIMINACIÓN DE PROCEDIMIENTOS ALMACENADOS
---------------------------------------------------------------------
IF OBJECT_ID('DB_LOPERS.Migrar_Modelo_BI', 'P') IS NOT NULL
    DROP PROCEDURE [DB_LOPERS].Migrar_Modelo_BI;

---------------------------------------------------------------------
-- ELIMINACIÓN DE TABLAS DE HECHOS (Deben eliminarse primero por las FK)
---------------------------------------------------------------------
IF OBJECT_ID('DB_LOPERS.BI_Hecho_Encuesta', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Hecho_Encuesta;

IF OBJECT_ID('DB_LOPERS.BI_Hecho_Propuesta', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Hecho_Propuesta;

IF OBJECT_ID('DB_LOPERS.BI_Hecho_Solicitud', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Hecho_Solicitud;

IF OBJECT_ID('DB_LOPERS.BI_Hecho_Venta', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Hecho_Venta;

---------------------------------------------------------------------
-- ELIMINACIÓN DE TABLAS DIMENSIONALES
---------------------------------------------------------------------
IF OBJECT_ID('DB_LOPERS.BI_Aspecto', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Aspecto;

IF OBJECT_ID('DB_LOPERS.BI_Estado_Propuesta', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Estado_Propuesta;

IF OBJECT_ID('DB_LOPERS.BI_Canal_Venta', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Canal_Venta;

IF OBJECT_ID('DB_LOPERS.BI_Tipo_Servicio', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Tipo_Servicio;

IF OBJECT_ID('DB_LOPERS.BI_Agente', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Agente;

IF OBJECT_ID('DB_LOPERS.BI_Cliente', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Cliente;

IF OBJECT_ID('DB_LOPERS.BI_Tiempo', 'U') IS NOT NULL
    DROP TABLE [DB_LOPERS].BI_Tiempo;

PRINT 'Modelo BI eliminado correctamente.';
GO
