extends Area2D

class_name Escudo

var esta_activado:bool = false setget, get_esta_activado

func _ready() -> void:
	controlar_colisionador(true)


func controlar_colisionador(esta_desactivado:bool) -> void:
	$CollisionShape2D.set_deferred("disabled", esta_desactivado)


func activar() -> void:
	esta_activado = true
	controlar_colisionador(false)
	$AnimationPlayer.play("activando")


func get_esta_activado() -> bool:
	return esta_activado


func _on_AnimationPlayer_animation_finished(anim_name:String) -> void:
	if anim_name == "activando":
		$AnimationPlayer.play("activado")
