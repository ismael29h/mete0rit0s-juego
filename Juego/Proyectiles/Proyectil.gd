extends Area2D

class_name Proyectil


export var danio:float = 2.0

var velocidad:Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	position += velocidad * delta


# constructor
func crear(pos:Vector2, dir:float, vel: float, _danio_p:int) -> void:
	position = pos
	rotation = dir
	velocidad = Vector2(vel, 0).rotated(dir)


# cuando provoca daño
func daniar(cuerpo:CollisionObject2D) -> void:
	if cuerpo.has_method("recibir_danio"):
		cuerpo.recibir_danio(danio)
	queue_free()


# sale de la línea de visión
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

# golpea a un enemigo
func _on_area_entered(area:Area2D) -> void:
	daniar(area)
	

func _on_body_entered(body:Node) -> void:
	daniar(body)
