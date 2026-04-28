```mermaid
erDiagram
direction LR

    AGENCIA {
        bigint Nro_Agencia PK
        nvarchar(255) Direccion
        nvarchar(255) Telefono
        nvarchar(255) Mail
        nvarchar(255) Localidad
        nvarchar(255) Provincia
    }

    AGENTE {
        bigint Legajo PK
        nvarchar(255) Nombre
        nvarchar(255) Apellido
        nvarchar(255) Dni
        date Fecha_Nac
        nvarchar(255) Telefono
        nvarchar(255) Mail
        nvarchar(255) Direccion
        nvarchar(255) Localidad
        nvarchar(255) Provincia
        bigint Agencia_Nro_Agencia FK
    }

    CLIENTE {
        bigint ID_Cliente PK
        nvarchar(255) Dni
        nvarchar(255) Nombre
        nvarchar(255) Apellido
        nvarchar(255) Tel
        nvarchar(255) Mail
        nvarchar(255) Direccion
        date Fecha_Nac
        nvarchar(255) Localidad
        nvarchar(255) Provincia
    }

    PROVEEDOR {
        bigint ID_Proveedor PK
        nvarchar(255) Nombre
        nvarchar(255) Mail
        nvarchar(255) Telefono
    }

    AEROPUERTO {
        nvarchar(10) Codigo PK
        nvarchar(200) Descripcion
        nvarchar(255) Ciudad
        nvarchar(255) Pais
    }

    AEROLINEA {
        nvarchar(255) Codigo PK
        nvarchar(255) Nombre
        nvarchar(255) Pais
        nvarchar(255) Alianza
    }

    VUELO {
        bigint ID_Vuelo PK
        date Fecha_Salida
        nvarchar(50) Horario_Salida
        nvarchar(255) Aerolinea_Codigo FK
        nvarchar(10) Aeropuerto_Salida_Codigo FK
        nvarchar(10) Aeropuerto_Llegada_Codigo FK
        date Fecha_Llegada
        nvarchar(50) Horario_Llegada
        int Duracion
        decimal Precio
        bit Incluye_Carry
        bit Incluye_Valija
    }

    HOSPEDAJE {
        bigint ID_Hospedaje PK
        nvarchar(255) Nombre
        nvarchar(255) Ciudad
        nvarchar(255) Pais
        nvarchar(255) Direccion
        bit Incluye_Desayuno
        nvarchar(50) Check_In
        nvarchar(50) Check_Out
    }

    HABITACION {
        bigint ID_Habitacion PK
        bigint Hospedaje_ID FK
        nvarchar(255) Nombre
        nvarchar(MAX) Descripcion
        decimal Precio_Noche
    }

    EXCURSION {
        bigint ID_Excursion PK
        bigint Proveedor_ID FK
        nvarchar(255) Nombre
        nvarchar(MAX) Descripcion
        nvarchar(50) Horario
        int Duracion
        decimal Precio
    }

    SOLICITUD {
        bigint Nro_Solicitud PK
        bigint ID_Cliente FK
        bigint Agente_Legajo FK
        date Fecha_Solicitud
        date Fecha_Inicio_Tentativa
        date Fecha_Fin_Tentativa
        int Cant_Pasajeros
        nvarchar(MAX) Observaciones
        decimal Presupuesto_Estimado
    }

    DETALLE_SOLICITUD {
        bigint ID_Detalle_Solicitud PK
        bigint Solicitud_Nro_Solicitud FK
        nvarchar(255) Ciudad
        int Cant_Dias_Aprox
        nvarchar(MAX) Observaciones
    }

    PROPUESTA {
        bigint Nro_Propuesta PK
        bigint Solicitud_Nro_Solicitud FK
        bigint Agente_Legajo FK
        date Fecha_Emision
        date Vigencia_Hasta
        date Fecha_Desde
        date Fecha_Hasta
        decimal Subtotal
        decimal Descuento
        decimal Importe_Total
        nvarchar(255) Estado
    }

    PROPUESTA_VUELO {
        bigint ID_Propuesta_Vuelo PK
        bigint Propuesta_Nro_Propuesta FK
        bigint Vuelo_ID FK
        int Cant_Pasajes
        decimal Precio
        decimal Subtotal
    }

    PROPUESTA_HOSPEDAJE {
        bigint ID_Propuesta_Hospedaje PK
        bigint Propuesta_Nro_Propuesta FK
        int Habitacion_ID FK
        date Fecha_Desde
        date Fecha_Hasta
        int Cantidad_Habitaciones
        decimal Precio
        decimal Subtotal
    }

    VENTA {
        bigint Nro_Venta PK
        bigint ID_Cliente FK
        bigint Agente_Legajo FK
        bigint Propuesta_Nro_Propuesta FK
        date Fecha_Venta
        nvarchar(255) Canal_Venta
        nvarchar(255) Medio_Pago
        decimal Subtotal
        decimal Descuento
        decimal Importe_Total
    }

    VENTA_VUELO {
        bigint ID_Venta_Vuelo PK
        bigint Venta_Nro_Venta FK
        bigint Vuelo_ID FK
        int Cantidad_Pasajes
        decimal Precio_Unitario
        decimal Subtotal
        nvarchar(255) Cod_Reserva
    }

    VENTA_HOSPEDAJE {
        bigint ID_Venta_Hospedaje PK
        bigint Venta_Nro_Venta FK
        bigint Habitacion_ID FK
        date Fecha_Desde
        date Fecha_Hasta
        int Cantidad_Habitaciones
        decimal Precio_Unitario
        decimal Subtotal
        nvarchar(255) Cod_Reserva
    }

    VENTA_EXCURSION {
        bigint ID_Venta_Excursion PK
        bigint Venta_Nro_Venta FK
        bigint Excursion_ID FK
        date Fecha_Reserva
        int Cantidad_Excursiones
        decimal Precio_Unitario
        decimal Subtotal
        nvarchar(255) Cod_Reserva
    }

    ASPECTO {
        bigint ID_Aspecto PK
        nvarchar(255) Descripcion
    }

    ENCUESTA {
        bigint Codigo_Encuesta PK
        bigint ID_Cliente FK
        bigint Agente_Legajo FK
        date Fecha_Encuesta
        nvarchar(MAX) Comentarios
    }

    DETALLE_ENCUESTA {
        bigint Encuesta_Codigo_Encuesta PK, FK
        bigint Aspecto_ID PK, FK
        int Puntaje
    }

    AGENCIA ||--o{ AGENTE : "emplea"
    AGENTE ||--o{ SOLICITUD : "gestiona"
    AGENTE ||--o{ PROPUESTA : "arma"
    AGENTE ||--o{ VENTA : "cierra"
    AGENTE ||--o{ ENCUESTA : "es evaluado en"
    CLIENTE ||--o{ SOLICITUD : "realiza"
    CLIENTE ||--o{ VENTA : "compra"
    CLIENTE ||--o{ ENCUESTA : "responde"
    PROVEEDOR ||--o{ EXCURSION : "provee"
    AEROLINEA ||--o{ VUELO : "opera"
    AEROPUERTO ||--o{ VUELO : "es origen de"
    AEROPUERTO ||--o{ VUELO : "es destino de"
    HOSPEDAJE ||--o{ HABITACION : "tiene"
    SOLICITUD ||--o{ DETALLE_SOLICITUD : "contiene"
    SOLICITUD ||--o{ PROPUESTA : "deriva en"
    PROPUESTA ||--o| VENTA : "puede efectivizarse en"
    ENCUESTA ||--o{ DETALLE_ENCUESTA : "compuesta por"
    ASPECTO ||--o{ DETALLE_ENCUESTA : "es evaluado en"
    
    %% Relaciones de Propuesta
    PROPUESTA ||--o{ PROPUESTA_VUELO : "incluye"
    PROPUESTA ||--o{ PROPUESTA_HOSPEDAJE : "incluye"
    VUELO ||--o{ PROPUESTA_VUELO : "cotizado en"
    HABITACION ||--o{ PROPUESTA_HOSPEDAJE : "cotizada en"
    
    %% Relaciones de Venta
    VENTA ||--o{ VENTA_VUELO : "contiene"
    VENTA ||--o{ VENTA_HOSPEDAJE : "contiene"
    VENTA ||--o{ VENTA_EXCURSION : "contiene"
    VUELO ||--o{ VENTA_VUELO : "vendido en"
    HABITACION ||--o{ VENTA_HOSPEDAJE : "vendida en"
    EXCURSION ||--o{ VENTA_EXCURSION : "vendida en"
```