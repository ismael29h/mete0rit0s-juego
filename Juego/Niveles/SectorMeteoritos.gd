extends Node2D
class_name SectorMeteoritos

export var cantidad_meteoritos:int = 10

var spawners:Array

func _ready() -> void:
	almacen_spawners()
	$AdvertenciaAnimation.play("Advertencia")

func almacen_spawners() -> void:
	for spawner in $Spawners.get_children():
		spawners.append(spawner)


func spawner_random() -> int:
	randomize()
	return randi() % spawners.size()


# autostart
func _on_Timer_timeout() -> void:
	if cantidad_meteoritos == 0:
		$Timer.stop()
		$AdvertenciaAnimation.play("default")
		return
	
	(spawners[spawner_random()]).spawnear_meteorito()
	cantidad_meteoritos -= 1
