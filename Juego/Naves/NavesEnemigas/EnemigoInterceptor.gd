class_name EnemigoInterceptor
extends EnemigoBase

enum ESTADO_IA {IDLE, ATACANDOQ, ATACANDOP, PERSECUCION}

var estado_ia_actual:int = ESTADO_IA.IDLE


func controlar_estados_ia(nuevo_estado: int) -> void:
	match nuevo_estado:
		ESTADO_IA.IDLE:
			canion.set_esta_disparando(false)
		ESTADO_IA.ATACANDOQ:
			canion.set_esta_disparando(true)
		ESTADO_IA.ATACANDOP:
			canion.set_esta_disparando(true)
		ESTADO_IA.PERSECUCION:
			canion.set_esta_disparando(false)
		_:
			print("Error de estado")

	estado_ia_actual = nuevo_estado



# señales
func _on_AreaDisparo_body_entered(body):
	print("AreaDisparo-entro")
	controlar_estados_ia(ESTADO_IA.ATACANDOQ)


func _on_AreaDisparo_body_exited(body):
	print("AreaDisparo-salgo")
	controlar_estados_ia(ESTADO_IA.ATACANDOP)


func _on_AreaDeteccion_body_entered(body):
	print("AreaDeteccion-entro")
	controlar_estados_ia(ESTADO_IA.ATACANDOP)


func _on_AreaDeteccion_body_exited(body):
	print("AreaDeteccino-salgo")
	controlar_estados_ia(ESTADO_IA.PERSECUCION)
