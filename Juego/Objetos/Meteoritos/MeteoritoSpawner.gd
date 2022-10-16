extends Position2D
class_name MeteoritoSpawner

export var direccion:Vector2 = Vector2(2, 1)
export var rango_volumen_meteorito:Vector2 = Vector2(0.5, 2.2)


func _ready():
	yield(owner, "ready")
	spawnear_meteorito()


func spawnear_meteorito() -> void:
	Eventos.emit_signal(
		"lluvia_meteoritos",
		global_position,
		direccion,
		meteorito_aleatorio()
		)


func meteorito_aleatorio() -> float:
	randomize()
	return rand_range(
		rango_volumen_meteorito[0],
		rango_volumen_meteorito[1]
		)
		
