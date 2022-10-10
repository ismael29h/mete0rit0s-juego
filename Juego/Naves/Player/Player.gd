extends RigidBody2D

class_name Player

export var potencia_motor:int = 20
export var potencia_rotacion:int = 280
export var estela_maxima:int = 100


var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

onready var canion:Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D
onready var estela:Estela = $PuntoEstela/Trail2D


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
		# aplicar impulso: adelante-atrás
	apply_central_impulse(empuje.rotated(rotation))
	# aplicar torque de rotación
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	
	# interesante - buscar
	#print(rad2deg(rotation))
	#print(empuje.rotated(rotation))

#func _process(delta: float) -> void:
	#player_input()
	


#func player_input() -> void:
func _unhandled_input(event: InputEvent) -> void:
	# empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potencia_motor, 0)
		estela.set_max_points(estela_maxima)
	elif Input.is_action_pressed("mover_atrás"):
		empuje = Vector2(-potencia_motor, 0)
		estela.set_max_points(0)

	# rotación
	dir_rotacion = 0
	if Input.is_action_pressed("mover_antihorario"):
		dir_rotacion -= 1
	elif Input.is_action_pressed("mover_horario"):
		dir_rotacion += 1

	# disparar
	if Input.is_action_pressed("disparo_principal"):	
		# el disparo principal no se realizará si el disparo secundario está activo
		if not laser.is_casting:
			canion.set_esta_disparando(true)
	if Input.is_action_just_released("disparo_principal"):
		canion.set_esta_disparando(false)

	# disparo secundario
	if Input.is_action_just_pressed("disparo_secundario"):
		if laser.is_casting:
			laser.set_is_casting(false)
		else:
			# el disparo secundario anula el disparo principal
			canion.set_esta_disparando(false)
			laser.set_is_casting(true)
		
