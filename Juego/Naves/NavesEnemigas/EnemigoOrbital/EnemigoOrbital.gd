extends EnemigoBase
class_name EnemigoOrbital

export var rango_max_ataque:float = 1400.0
export var velocidad:float = 400.0

onready var detector_obstaculo:RayCast2D = $DetectorObstaculo

var estacion_padre:Node2D
var ruta:Path2D
var path_follow:PathFollow2D


func _ready() -> void:
# warning-ignore:return_value_discarded
	Eventos.connect("base_destruida", self, "_on_base_destruida")
	#temporal
	#canion.set_esta_disparando(true)


func _process(delta:float) -> void:
	path_follow.offset += velocidad * delta
	position = path_follow.global_position


func rotar_hacia_player() -> void:
	.rotar_hacia_player()
	if dir_player.length() > rango_max_ataque or detector_obstaculo.is_colliding():
		canion.set_esta_disparando(false)
	else:
		canion.set_esta_disparando(true)


func crear(pos:Vector2, padre:Node2D, ruta_duenia:Path2D) -> void:
	global_position = pos
	estacion_padre = padre
	ruta = ruta_duenia
	path_follow = PathFollow2D.new()
	ruta.add_child(path_follow)
	


func _on_base_destruida(base:Node2D, _pos) -> void:
	#._on_base_destruida(base, _pos)
	if base == estacion_padre:
		destruir()
