```mermaid
erDiagram
direction LR

    BI_Tiempo {
        bigint ID_Tiempo PK
        date Fecha
        int Anio
        int Cuatrimestre
        int Mes
        nvarchar(50) Mes_Nombre
        nvarchar(50) Temporada
    }

    BI_Cliente {
        bigint ID_Cliente PK
        nvarchar(255) Dni
        nvarchar(255) Nombre
        nvarchar(255) Apellido
        nvarchar(50) Rango_Etario_Cliente
    }

    BI_Agente {
        bigint Legajo PK
        nvarchar(255) Dni
        nvarchar(255) Nombre
        nvarchar(255) Apellido
        nvarchar(50) Rango_Etario_Agente
    }

    BI_Tipo_Servicio {
        bigint ID_Tipo_Servicio PK
        nvarchar(100) Descripcion
    }

    BI_Canal_Venta {
        bigint ID_Canal_Venta PK
        nvarchar(255) Descripcion
    }

    BI_Estado_Propuesta {
        bigint ID_Estado_Propuesta PK
        nvarchar(255) Descripcion
    }

    BI_Aspecto {
        bigint ID_Aspecto PK
        nvarchar(255) Descripcion
    }

    BI_Hecho_Venta {
        bigint ID_Cliente FK
        bigint Legajo_Agente FK
        bigint ID_Canal_Venta FK
        bigint ID_Tiempo FK
        bigint ID_Tipo_Servicio FK
        decimal Importe_Total
        int Cant_Ventas
    }

    BI_Hecho_Solicitud {
        bigint ID_Cliente FK
        bigint Legajo_Agente FK
        bigint ID_Tiempo_Solicitud FK
        int Anticipacion_Dias
        int Cant_Solicitudes
        decimal Presupuesto_Estimado
    }

    BI_Hecho_Propuesta {
        bigint Legajo_Agente FK
        bigint ID_Estado_Propuesta FK
        bigint ID_Tiempo_Emision FK
        bigint ID_Tiempo_Solicitud FK
        bigint ID_Tiempo_Viaje_Inicio FK
        decimal Importe_Total
        decimal Desvio_Presupuesto
        int Tiempo_Respuesta_Dias
        int Cant_Propuestas
        int Aceptada
    }

    BI_Hecho_Encuesta {
        bigint ID_Cliente FK
        bigint Legajo_Agente FK
        bigint ID_Tiempo FK
        bigint ID_Aspecto FK
        int Puntaje
    }

    %% Relaciones de BI_Hecho_Venta (Estrella 1)
    BI_Cliente ||--o{ BI_Hecho_Venta : "registra"
    BI_Agente ||--o{ BI_Hecho_Venta : "gestiona"
    BI_Canal_Venta ||--o{ BI_Hecho_Venta : "canaliza"
    BI_Tiempo ||--o{ BI_Hecho_Venta : "ocurre en"
    BI_Tipo_Servicio ||--o{ BI_Hecho_Venta : "clasifica"

    %% Relaciones de BI_Hecho_Solicitud (Estrella 2)
    BI_Cliente ||--o{ BI_Hecho_Solicitud : "solicita"
    BI_Agente ||--o{ BI_Hecho_Solicitud : "recibe"
    BI_Tiempo ||--o{ BI_Hecho_Solicitud : "creada en"

    %% Relaciones de BI_Hecho_Propuesta (Estrella 3)
    BI_Agente ||--o{ BI_Hecho_Propuesta : "elabora"
    BI_Estado_Propuesta ||--o{ BI_Hecho_Propuesta : "estado de"
    BI_Tiempo ||--o{ BI_Hecho_Propuesta : "emitida en"
    BI_Tiempo ||--o{ BI_Hecho_Propuesta : "solicitada en"
    BI_Tiempo ||--o{ BI_Hecho_Propuesta : "viaja en"

    %% Relaciones de BI_Hecho_Encuesta (Estrella 4)
    BI_Cliente ||--o{ BI_Hecho_Encuesta : "responde"
    BI_Agente ||--o{ BI_Hecho_Encuesta : "evaluado en"
    BI_Tiempo ||--o{ BI_Hecho_Encuesta : "realizada en"
    BI_Aspecto ||--o{ BI_Hecho_Encuesta : "califica"
```