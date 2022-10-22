extends RigidBody2D

class_name Player

export var potencia_motor:int = 20
export var potencia_rotacion:int = 280
export var estela_maxima:int = 100
export var vida:float = 15.0

var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0
var estado_actual:int = ESTADO.SPAWN # 

onready var canion:Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D setget, get_laser
onready var estela:Estela = $PuntoEstela/Trail2D
onready var motor_sfx:Motor = $MotorSFX
onready var colisionador:CollisionShape2D = $CollisionPlayer
onready var impacto_sfx:AudioStreamPlayer = $ImpactoSFX
onready var escudo:Escudo = $Escudo setget, get_escudo

# enumerable
enum ESTADO {SPAWN, VIVO, INVENCIBLE, MUERTO}


func controlar_estados(nuevo_estado:int) -> void:
	match nuevo_estado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(true)
			Eventos.emit_signal("nave_destruida", global_position, 3)
			queue_free()	
		_:
			print('No debería verse esto')
	
	estado_actual = nuevo_estado


func esta_input_activo() -> bool:
	#if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]
	if estado_actual == ESTADO.MUERTO\
		or estado_actual == ESTADO.SPAWN:
			return false
	
	return true


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

# AnimationPlayer
func _on_AnimationPlayer_animation_finished(anim_name:String) -> void:
	if anim_name == "spawn":
		controlar_estados(ESTADO.VIVO)


func destruir() -> void:
	controlar_estados(ESTADO.MUERTO)


func recibir_danio(danio:float) -> void:
	vida -= danio
	if vida <= 0:
		destruir()
	impacto_sfx.play()


func get_laser() -> RayoLaser:
	return laser


func get_escudo() -> Escudo:
	return escudo
