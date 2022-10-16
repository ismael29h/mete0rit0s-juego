extends Node2D
class_name ExplosionMeteorito


func _on_DestruccionAnimation_animation_finished(anim_name:String) -> void:
	queue_free()
