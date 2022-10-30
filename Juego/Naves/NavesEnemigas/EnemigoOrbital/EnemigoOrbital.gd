extends EnemigoBase
class_name EnemigoOrbital

export var rango_max_ataque:float = 1400.0

var estacion_padre:Node2D


func _ready() -> void:
	Eventos.connect("base_destruida", self, "_on_base_destruida")
	#temporal
	canion.set_esta_disparando(true)


func rotar_hacia_player() -> void:
	.rotar_hacia_player()
	if dir_player.length() > rango_max_ataque:
		canion.set_esta_disparando(false)
	else:
		canion.set_esta_disparando(true)


func crear(pos:Vector2, padre:Node2D) -> void:
	global_position = pos
	estacion_padre = padre


func _on_base_destruida(base:Node2D, _pos) -> void:
	if base == estacion_padre:
		destruir()
