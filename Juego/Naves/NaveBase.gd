class_name NaveBase

extends RigidBody2D


export var vida:float = 20.0

var estado_actual:int = ESTADO.SPAWN # 

onready var colisionador:CollisionShape2D = $CollisionPlayer
onready var impacto_sfx:AudioStreamPlayer = $ImpactoSFX
onready var canion:Canion = $Canion


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
			Eventos.emit_signal("nave_destruida", self, global_position, 3)
			#canion.set_puede_disparar(false)
			queue_free()	
		_:
			print('No debería verse esto')
	
	estado_actual = nuevo_estado


func destruir() -> void:
	controlar_estados(ESTADO.MUERTO)


func recibir_danio(danio:float) -> void:
	vida -= danio
	if vida <= 0:
		destruir()
	impacto_sfx.play()


# Señales
func _on_AnimationPlayer_animation_finished(anim_name:String) -> void:
	if anim_name == "spawn":
		controlar_estados(ESTADO.VIVO)
