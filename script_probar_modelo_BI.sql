USE GD1C2026;
GO

-- Verificar que la dimensión tiempo se pobló completamente
SELECT COUNT(*) AS [Días Cargados en BI_Tiempo] FROM [DB_LOPERS].BI_Tiempo;

-- Validar la Hechos de Venta cruzando con canales de venta
SELECT c.Descripcion AS Canal, SUM(v.Suma_Facturacion) AS Total_Facturado
FROM [DB_LOPERS].BI_Hecho_Venta v
    JOIN [DB_LOPERS].BI_Canal_Venta c ON v.ID_Canal_Venta = c.ID_Canal_Venta
GROUP BY c.Descripcion;

-- Consultar el Ticket Promedio Mensual
SELECT TOP 5 * FROM [DB_LOPERS].v_ticket_promedio_mensual ORDER BY [Año] DESC, [Mes] DESC;

-- Consultar la Distribución Cuatrimestral de Facturación
SELECT * FROM [DB_LOPERS].v_distribucion_facturacion_cuatrimestral;

-- Consultar Tasa de Aceptación de Propuestas
SELECT * FROM [DB_LOPERS].v_tasa_aceptacion_propuestas;

-- Consultar el Ranking de Aspectos Evaluados
-- Esto te permitirá ver rápidamente cuál fue el aspecto mejor o peor valorado de cada cuatrimestre
SELECT * FROM [DB_LOPERS].v_ranking_aspectos_valorados ORDER BY [Año], [Cuatrimestre], [Puntaje Promedio] DESC;

-- Verificar cantidad de rangos etarios creados (Dimensión Cliente)
SELECT * FROM [DB_LOPERS].BI_Rango_Etario_Cliente;

-- Verificar cantidad de rangos etarios creados (Dimensión Agente)
SELECT * FROM [DB_LOPERS].BI_Rango_Etario_Agente;

-- Dimensión Tipo de Servicio: Validar que existan los dos registros mandatorios
SELECT * FROM [DB_LOPERS].BI_Tipo_Servicio;

-- Dimensión Estado de Propuesta: Validar que se migraron todos los estados
SELECT * FROM [DB_LOPERS].BI_Estado_Propuesta;

-- Validar que se migraron todos los aspectos comerciales evaluados
SELECT * FROM [DB_LOPERS].BI_Aspecto;

-- Verificar volumen y anticipación de viajes promedio
SELECT 
    SUM(Cant_Solicitudes) AS [Total Solicitudes Originales BI],
    CAST(SUM(Suma_Anticipacion_Dias) * 1.0 / SUM(Cant_Solicitudes) AS decimal(18,2)) AS [Anticipación Promedio General (Días)]
FROM [DB_LOPERS].BI_Hecho_Solicitud;

-- Verificar volumen de cotizaciones, desvíos y propuestas aceptadas
SELECT 
    SUM(Cant_Propuestas) AS [Total Propuestas BI],
    SUM(Cant_Aceptadas) AS [Total Propuestas Aceptadas],
    CAST(SUM(Suma_Cotizacion) / SUM(Cant_Propuestas) AS decimal(18,2)) AS [Importe Cotizado Promedio],
    CAST(SUM(Suma_Desvio_Presupuesto) / SUM(Cant_Propuestas) AS decimal(18,2)) AS [Desvío Promedio respecto a lo Estimado]
FROM [DB_LOPERS].BI_Hecho_Propuesta;

-- Verificar cantidad de calificaciones e histórico de puntajes
SELECT 
    SUM(Cant_Encuestas) AS [Total Calificaciones Registradas],
    CAST(SUM(Suma_Puntaje) * 1.0 / SUM(Cant_Encuestas) AS decimal(18,2)) AS [Puntaje Promedio Histórico]
FROM [DB_LOPERS].BI_Hecho_Encuesta;
