extends Position2D
class_name MeteoritoSpawner

export var direccion:Vector2 = Vector2(2, 1)



func _ready():
	yield(owner, "ready")
	spawnear_meteorito()


func spawnear_meteorito() -> void:
	Eventos.emit_signal("lluvia_meteoritos", global_position, direccion)

