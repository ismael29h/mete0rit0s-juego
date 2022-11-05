class_name NaveBase

extends RigidBody2D


export var vida:float = 20.0

var estado_actual:int = ESTADO.SPAWN # 
var numero_explosiones:int = 3

onready var colisionador:CollisionShape2D = $CollisionPlayer
onready var impacto_sfx:AudioStreamPlayer = $ImpactoSFX
onready var canion:Canion = $Canion
onready var barra_salud:ProgressBar = $BarraSalud


# enumerable
enum ESTADO {SPAWN, VIVO, INVENCIBLE, MUERTO}


func _ready() -> void:
	barra_salud.max_value = vida
	barra_salud.value = vida
	controlar_estados(estado_actual)


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
			Eventos.emit_signal("nave_destruida", self, global_position, numero_explosiones)
			#canion.set_puede_disparar(false)
			queue_free()	
		_:
			print('No debería verse esto')
	
	estado_actual = nuevo_estado


func destruir() -> void:
	controlar_estados(ESTADO.MUERTO)


func recibir_danio(danio:float) -> void:
	vida -= danio
	if vida <= 0.0:
		destruir()
	
	barra_salud.controlar_barra(vida, true)
	impacto_sfx.play()
	


# Señales
func _on_AnimationPlayer_animation_finished(anim_name:String) -> void:
	if anim_name == "spawn":
		controlar_estados(ESTADO.VIVO)


func _on_body_entered(body:Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()
