extends Node2D
class_name SectorMeteoritos


# one_shot / autostart
func _on_Timer_timeout() -> void:
	for spawner in $Spawners.get_children():
		spawner.spawnear_meteorito()
		print('ok')
