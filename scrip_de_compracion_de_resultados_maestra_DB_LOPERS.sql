-- =============================================
-- COMPARAR RESULTADOS ENTRE MAESTRA Y DB_LOPERS
-- =============================================
-- MAESTRA
-- =============================================
select 'clientes' as entidad, count(*) as filas_maestra from (
    select cliente_dni from gd_esquema.maestra where cliente_dni is not null group by cliente_dni
) as clientes

union all

select 'agentes', count(*) from (
    select agente_legajo from gd_esquema.maestra where agente_legajo is not null group by agente_legajo
) as agentes

union all

select 'vuelos', count(*) from (
    select distinct 
        aerolinea_codigo, aeropuerto_salida_codigo, aeropuerto_llegada_codigo, 
        vuelo_fecha_salida, vuelo_horario_salida, vuelo_fecha_llegada, 
        vuelo_horario_llegada, vuelo_duracion, vuelo_precio, 
        vuelo_incluye_carry, vuelo_incluye_valija 
    from gd_esquema.maestra 
    where vuelo_fecha_salida is not null
) as vuelos

union all

select 'hospedajes', count(*) from (
    select distinct hospedaje_nombre, hospedaje_direccion 
    from gd_esquema.maestra 
    where hospedaje_nombre is not null
) as hospedajes

union all

select 'solicitudes', count(*) from (
    select solicitud_nro_solicitud from gd_esquema.maestra where solicitud_nro_solicitud is not null group by solicitud_nro_solicitud
) as solicitudes

union all

select 'ventas', count(*) from (
    select venta_nro_venta from gd_esquema.maestra where venta_nro_venta is not null group by venta_nro_venta
) as venetas;

-- =============================================
-- DB_LOPERS
-- =============================================
select 'clientes' as entidad, count(*) as filas_migradas from [db_lopers].cliente
union all
select 'agentes', count(*) from [db_lopers].agente
union all
select 'vuelos', count(*) from [db_lopers].vuelo
union all
select 'hospedajes', count(*) from [db_lopers].hospedaje
union all
select 'solicitudes', count(*) from [db_lopers].solicitud
union all
select 'ventas', count(*) from [db_lopers].venta;