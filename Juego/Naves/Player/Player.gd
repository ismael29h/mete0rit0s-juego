class_name Player

extends NaveBase

# atributos
export var potencia_motor:int = 20
export var potencia_rotacion:int = 280
export var estela_maxima:int = 500

onready var laser:RayoLaser = $LaserBeam2D setget, get_laser
onready var estela:Estela = $PuntoEstela/Trail2D
onready var motor_sfx:Motor = $MotorSFX
onready var escudo:Escudo = $Escudo setget, get_escudo

var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0


func _ready() -> void:
	DatosJuego.set_player_actual(self)


# setters - getters
func get_laser() -> RayoLaser:
	return laser


func get_escudo() -> Escudo:
	return escudo

# métodos
func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return

	# apagar motor	
	if event.is_action_released("mover_adelante")\
	 or event.is_action_released("mover_atrás"):
		motor_sfx.apagar_motor()


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
	
	# escudo
	if event.is_action_pressed("escudo") and not escudo.get_esta_activado():
		escudo.activar()


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
		# aplicar impulso: adelante-atrás
	apply_central_impulse(empuje.rotated(rotation))
	# aplicar torque de rotación
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	
	#print(rad2deg(rotation))
	#print(empuje.rotated(rotation))

func _process(delta: float) -> void:
	player_input()


func player_input() -> void:
		# empuje, sonido del motor, estela
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potencia_motor, 0)
		estela.set_max_points(estela_maxima)
		motor_sfx.encender_motor()
	elif Input.is_action_pressed("mover_atrás"):
		empuje = Vector2(-potencia_motor, 0)
		estela.set_max_points(0)
		motor_sfx.encender_motor()

	# rotación
	dir_rotacion = 0
	if Input.is_action_pressed("mover_antihorario"):
		dir_rotacion -= 1
	elif Input.is_action_pressed("mover_horario"):
		dir_rotacion += 1


func esta_input_activo() -> bool:
	#if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]
	if estado_actual == ESTADO.MUERTO\
		or estado_actual == ESTADO.SPAWN:
			return false
	
	return true


func desactivar_controles() -> void:
	controlar_estados(ESTADO.SPAWN)
	empuje = Vector2.ZERO
	motor_sfx.apagar_motor()
	laser.set_is_casting(false)
