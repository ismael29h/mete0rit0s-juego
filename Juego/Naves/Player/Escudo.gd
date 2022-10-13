extends Area2D

class_name Escudo

export var energia:float = 10.0
export var desgaste:float = 2.0 # 10/5=2seg


var esta_activado:bool = false setget, get_esta_activado

func _ready() -> void:
	set_process(false)
	controlar_colisionador(true)


func _process(delta) -> void:
	energia -= desgaste * delta
	if energia <= 0.0:
		desactivar()

func controlar_colisionador(esta_desactivado:bool) -> void:
	$CollisionShape2D.set_deferred("disabled", esta_desactivado)


func activar() -> void:
	if energia <= 0.0:
		return

	esta_activado = true
	controlar_colisionador(false)
	$AnimationPlayer.play("activando")


func desactivar() -> void:
	esta_activado = false
	controlar_colisionador(true)
	$AnimationPlayer.play_backwards("activando")
	set_process(false)

func get_esta_activado() -> bool:
	return esta_activado


func _on_AnimationPlayer_animation_finished(anim_name:String) -> void:
	if anim_name == "activando" and esta_activado:
		$AnimationPlayer.play("activado")
		set_process(true)


func _on_area_entered(area):
	$ImpactoEnemigo.play()
	area.queue_free()
