class_name EnemigoBase

extends NaveBase

func _ready() -> void:
	canion.set_esta_disparando(true)

# señales
func _on_body_entered(body:Node) -> void:
	._on_body_entered(body) # llamada al método de la clase padre
	if body is Player:
		body.destruir()
		destruir()
