class_name BaseEnemiga
extends Node2D


export var vida:float = 30.0

onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX

var esta_destruida:bool = false


func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aleatoria())


func elegir_animacion_aleatoria() -> String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size()
	var indice_anim_aleatoria:int = randi() % num_anim
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	print(lista_animacion[indice_anim_aleatoria])
	return lista_animacion[indice_anim_aleatoria]


func recibir_danio(danio:float) -> void:
	vida -= danio
	
	if vida <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
		
	impacto_sfx.play()


func destruir() -> void:
	var sprites_pos = [
		$Sprites/SpaceStation1.global_position,
		$Sprites/SpaceStation2.global_position,
		$Sprites/SpaceStation3.global_position,
		$Sprites/SpaceStation4.global_position
	]
	
	Eventos.emit_signal("base_destruida", sprites_pos)
	queue_free()


func _on_AreaColision_body_entered(body:Node) -> void:
	if body.has_method("destruir"):
		body.destruir()
