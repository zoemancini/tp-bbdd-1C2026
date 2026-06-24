USE GD1C2026;
GO

-- Verificar que la dimensión tiempo se pobló completamente
SELECT COUNT(*) AS [Días Cargados en BI_Tiempo] FROM [DB_LOPERS].BI_Tiempo;

-- Validar que existan registros clasificados en las dimensiones analíticas de Clientes
SELECT Rango_Etario_Cliente, COUNT(*) AS [Clientes por Rango]
FROM [DB_LOPERS].BI_Cliente
GROUP BY Rango_Etario_Cliente;

-- Validar la Hechos de Venta cruzando con canales de venta
SELECT c.Descripcion AS Canal, SUM(v.Importe_Total) AS Total_Facturado
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

-- Verificar cantidad y distribución por rango etario
SELECT Rango_Etario_Agente, COUNT(*) AS [Cantidad de Agentes]
FROM [DB_LOPERS].BI_Agente
GROUP BY Rango_Etario_Agente;

-- Dimensión Tipo de Servicio: Validar que existan los dos registros mandatorios
SELECT * FROM [DB_LOPERS].BI_Tipo_Servicio;

-- Dimensión Estado de Propuesta: Validar que se migraron todos los estados
SELECT * FROM [DB_LOPERS].BI_Estado_Propuesta;

-- Validar que se migraron todos los aspectos comerciales evaluados
SELECT * FROM [DB_LOPERS].BI_Aspecto;

-- Verificar volumen y anticipación de viajes promedio
SELECT
    COUNT(*) AS [Total Solicitudes BI],
    AVG(Anticipacion_Dias) AS [Anticipación Promedio General (Días)]
FROM [DB_LOPERS].BI_Hecho_Solicitud;

-- Verificar volumen de cotizaciones, desvíos y propuestas aceptadas
SELECT
    COUNT(*) AS [Total Propuestas BI],
    SUM(Aceptada) AS [Total Propuestas Aceptadas],
    AVG(Importe_Total) AS [Importe Cotizado Promedio],
    AVG(Desvio_Presupuesto) AS [Desvío Promedio respecto a lo Estimado]
FROM [DB_LOPERS].BI_Hecho_Propuesta;

-- Verificar cantidad de calificaciones e histórico de puntajes
SELECT
    COUNT(*) AS [Total Calificaciones Registradas],
    MIN(Puntaje) AS [Puntaje Mínimo],
    MAX(Puntaje) AS [Puntaje Máximo],
    CAST(AVG(CAST(Puntaje AS decimal(18,2))) AS decimal(18,2)) AS [Puntaje Promedio Histórico]
FROM [DB_LOPERS].BI_Hecho_Encuesta;
