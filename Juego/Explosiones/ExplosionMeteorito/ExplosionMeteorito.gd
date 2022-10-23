extends Node2D
class_name ExplosionMeteorito

onready var lista_animacion:Array = $DestruccionAnimation.get_animation_list()

func _ready() -> void:
	$DestruccionAnimation.play(explosion_random())
	print(lista_animacion)

func explosion_random() -> String:
	randomize()
	var num_anim:int = $DestruccionAnimation.get_animation_list().size()
	print(num_anim)
	var indice_anim:int = randi() % num_anim
	print(indice_anim)
	print(lista_animacion[indice_anim])
	return lista_animacion[indice_anim]


func _on_DestruccionAnimation_animation_finished(anim_name:String) -> void:
	queue_free()
