extends Node2D

export var vida:float = 10.0


func _on_Area2D_body_entered(body):
	if body is Player:
		body.destruir()


func recibir_danio(danio:float) -> void:
	vida -= danio
	if vida <= 0.0:
		queue_free()
