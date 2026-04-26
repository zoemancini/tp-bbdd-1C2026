erDiagram
direction LR
	AGENCIA {
		bigint Nro_Agencia PK ""  
		nvarchar(255) Direccion  ""  
		nvarchar(255) Telefono  ""  
		nvarchar(255) Mail  ""  
		nvarchar(255) Localidad  ""  
		nvarchar(255) Provincia  ""  
    }

	AGENTE {
		bigint Legajo PK ""  
		nvarchar(255) Nombre  ""  
		nvarchar(255) Apellido  ""  
		nvarchar(255) Dni  ""  
		date Fecha_Nac  ""  
		nvarchar(255) Telefono  ""  
		nvarchar(255) Mail  ""  
		nvarchar(255) Direccion  ""  
		nvarchar(255) Localidad  ""  
		nvarchar(255) Provincia  ""  
		bigint Agencia_Nro_Agencia FK ""  
	}

	CLIENTE {
		nvarchar(255) Dni PK ""  
		nvarchar(255) Nombre  ""  
		nvarchar(255) Apellido  ""  
		nvarchar(255) Tel  ""  
		nvarchar(255) Mail  ""  
		nvarchar(255) Direccion  ""  
		date Fecha_Nac  ""  
		nvarchar(255) Localidad  ""  
		nvarchar(255) Provincia  ""  
	}

	PROVEEDOR {
		int ID_Proveedor PK ""  
		nvarchar(255) Nombre  ""  
		nvarchar(255) Mail  ""  
		nvarchar(255) Telefono  ""  
	}

	AEROPUERTO {
		nvarchar(10) Codigo PK ""  
		nvarchar(200) Descripcion  ""  
		nvarchar(255) Ciudad  ""  
		nvarchar(255) Pais  ""  
	}

	AEROLINEA {
		nvarchar(255) Codigo PK ""  
		nvarchar(255) Nombre  ""  
		nvarchar(255) Pais  ""  
		nvarchar(255) Alianza  ""  
	}

	VUELO {
		bigint ID_Vuelo PK ""  
		date Fecha_Salida  ""  
		nvarchar(50) Horario_Salida  ""  
		nvarchar(255) Aerolinea_Codigo FK ""  
		nvarchar(10) Aeropuerto_Salida_Codigo FK ""  
		nvarchar(10) Aeropuerto_Llegada_Codigo FK ""  
		date Fecha_Llegada  ""  
		nvarchar(50) Horario_Llegada  ""  
		int Duracion  ""  
		decimal Precio  ""  
		bit Incluye_Carry  ""  
		bit Incluye_Valija  ""  
	}

	HOSPEDAJE {
		int ID_Hospedaje PK ""  
		nvarchar(255) Nombre  ""  
		nvarchar(255) Ciudad  ""  
		nvarchar(255) Pais  ""  
		nvarchar(255) Direccion  ""  
		bit Incluye_Desayuno  ""  
		nvarchar(50) Check_In  ""  
		nvarchar(50) Check_Out  ""  
	}

	HABITACION {
		int ID_Habitacion PK ""  
		int Hospedaje_ID FK ""  
		nvarchar(255) Nombre  ""  
		nvarchar(MAX) Descripcion  ""  
		decimal Precio_Noche  ""  
	}

	EXCURSION {
		int ID_Excursion PK ""  
		int Proveedor_ID FK ""  
		nvarchar(255) Nombre  ""  
		nvarchar(MAX) Descripcion  ""  
		nvarchar(50) Horario  ""  
		int Duracion  ""  
		decimal Precio  ""  
	}

	SOLICITUD {
		bigint Nro_Solicitud PK ""  
		nvarchar(255) Cliente_Dni FK ""  
		bigint Agente_Legajo FK ""  
		date Fecha_Solicitud  ""  
		date Fecha_Inicio_Tentativa  ""  
		date Fecha_Fin_Tentativa  ""  
		int Cant_Pax  ""  
		nvarchar(MAX) Observaciones  ""  
		decimal Presupuesto_Estimado  ""  
	}

	DETALLE_SOLICITUD {
		bigint ID_Detalle_Solicitud PK ""  
		bigint Solicitud_Nro_Solicitud FK ""  
		nvarchar(255) Ciudad  ""  
		int Cant_Dias_Aprox  ""  
		nvarchar(MAX) Observaciones  ""  
	}

	PROPUESTA {
		bigint Nro_Propuesta PK ""  
		bigint Solicitud_Nro_Solicitud FK ""  
		bigint Agente_Legajo FK ""  
		date Fecha_Emision  ""  
		date Vigencia_Hasta  ""  
		date Fecha_Desde  ""  
		date Fecha_Hasta  ""  
		decimal Subtotal  ""  
		decimal Descuento  ""  
		decimal Importe_Total  ""  
		nvarchar(255) Estado  ""  
	}

	DETALLE_PROPUESTA {
		bigint ID_Detalle_Propuesta PK ""  
		bigint Propuesta_Nro_Propuesta FK ""  
		bigint Vuelo_ID FK ""  
		int Habitacion_ID FK ""  
		int Vuelo_Cant_Pasajes  ""  
		decimal Vuelo_Precio  ""  
		decimal Vuelo_Subtotal  ""  
		date Hospedaje_Fecha_Desde  ""  
		date Hospedaje_Fecha_Hasta  ""  
		int Hospedaje_Cant  ""  
		decimal Hospedaje_Precio  ""  
		decimal Hospedaje_Subtotal  ""  
	}

	VENTA {
		bigint Nro_Venta PK ""  
		bigint Agencia_Nro_Agencia FK ""  
		nvarchar(255) Cliente_Dni FK ""  
		bigint Agente_Legajo FK ""  
		bigint Propuesta_Nro_Propuesta FK ""  
		date Fecha_Venta  ""  
		nvarchar(255) Canal_Venta  ""  
		nvarchar(255) Medio_Pago  ""  
		decimal Subtotal  ""  
		decimal Descuento  ""  
		decimal Importe_Total  ""  
	}

	DETALLE_VENTA {
		bigint ID_Detalle_Venta PK ""  
		bigint Venta_Nro_Venta FK ""  
		bigint Vuelo_ID FK ""  
		int Habitacion_ID FK ""  
		int Excursion_ID FK ""  
		int Vuelo_Cantidad_Pasajes  ""  
		decimal Vuelo_Precio_Unitario  ""  
		decimal Vuelo_Subtotal  ""  
		nvarchar(255) Vuelo_Cod_Reserva  ""  
		date Hospedaje_Fecha_Desde  ""  
		date Hospedaje_Fecha_Hasta  ""  
		int Hospedaje_Cantidad  ""  
		decimal Hospedaje_Precio_Unitario  ""  
		decimal Hospedaje_Subtotal  ""  
		nvarchar(255) Hospedaje_Cod_Reserva  ""  
		date Excursion_Fecha_Reserva  ""  
		int Excursion_Cant  ""  
		decimal Excursion_Precio_Unitario  ""  
		decimal Excursion_Subtotal  ""  
		nvarchar(255) Excursion_Cod_Reserva  ""  
	}

	ASPECTO {
		int ID_Aspecto PK ""  
		nvarchar(255) Descripcion  ""  
	}

	ENCUESTA {
		bigint Codigo_Encuesta PK ""  
		nvarchar(255) Cliente_Dni FK ""  
		bigint Agente_Legajo FK ""  
		date Fecha_Encuesta  ""  
		nvarchar(MAX) Comentarios  ""  
	}

	DETALLE_ENCUESTA {
		bigint Encuesta_Codigo_Encuesta PK,FK ""  
		int Aspecto_ID PK,FK ""  
		int Puntaje  ""  
	}

	AGENCIA||--o{AGENTE:"emplea"
	AGENCIA||--o{VENTA:"registra"
	AGENTE||--o{SOLICITUD:"gestiona"
	AGENTE||--o{PROPUESTA:"arma"
	AGENTE||--o{VENTA:"cierra"
	AGENTE||--o{ENCUESTA:"es evaluado en"
	CLIENTE||--o{SOLICITUD:"realiza"
	CLIENTE||--o{VENTA:"compra"
	CLIENTE||--o{ENCUESTA:"responde"
	PROVEEDOR||--o{EXCURSION:"provee"
	AEROLINEA||--o{VUELO:"opera"
	AEROPUERTO||--o{VUELO:"es origen de"
	AEROPUERTO||--o{VUELO:"es destino de"
	HOSPEDAJE||--o{HABITACION:"tiene"
	SOLICITUD||--o{DETALLE_SOLICITUD:"contiene"
	SOLICITUD||--o{PROPUESTA:"deriva en"
	PROPUESTA||--o{DETALLE_PROPUESTA:"incluye"
	PROPUESTA||--o|VENTA:"puede efectivizarse en"
	VENTA||--o{DETALLE_VENTA:"contiene"
	ENCUESTA||--o{DETALLE_ENCUESTA:"compuesta por"
	ASPECTO||--o{DETALLE_ENCUESTA:"es evaluado en"
	VUELO||--o{DETALLE_PROPUESTA:"cotizado en"
	HABITACION||--o{DETALLE_PROPUESTA:"cotizada en"
	VUELO||--o{DETALLE_VENTA:"vendido en"
	HABITACION||--o{DETALLE_VENTA:"vendida en"
	EXCURSION||--o{DETALLE_VENTA:"vendida en"