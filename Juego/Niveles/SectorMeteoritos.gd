extends Node2D
class_name SectorMeteoritos

export var cantidad_meteoritos:int = 10

var spawners:Array

func _ready() -> void:
	almacen_spawners()
	conectar_seniales_detectores()
	$AdvertenciaAnimation.play("Advertencia")

func almacen_spawners() -> void:
	for spawner in $Spawners.get_children():
		spawners.append(spawner)


func spawner_random() -> int:
	randomize()
	return randi() % spawners.size()


func conectar_seniales_detectores() -> void:
	for detector in $Detectores.get_children():
		# nota 1
		detector.connect("body_entered", self, "_on_detector_body_entered")


# autostart
func _on_Timer_timeout() -> void:
	if cantidad_meteoritos == 0:
		$Timer.stop()
		$AdvertenciaAnimation.play("default")
		return
	
	(spawners[spawner_random()]).spawnear_meteorito()
	cantidad_meteoritos -= 1


func _on_detector_body_entered(body:Node) -> void:
	body.set_esta_en_sector(false)
