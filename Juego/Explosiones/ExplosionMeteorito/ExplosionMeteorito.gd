extends Node2D
class_name ExplosionMeteorito

onready var lista_animacion:Array = $DestruccionAnimation.get_animation_list()

func _ready() -> void:
	$DestruccionAnimation.play(explosion_random())


func explosion_random() -> String:
	randomize()
	var num_anim:int = $DestruccionAnimation.get_animation_list().size()
	var indice_anim:int = randi() % num_anim
	
	return lista_animacion[indice_anim]


func _on_DestruccionAnimation_animation_finished(_anim_name:String) -> void:
	queue_free()
