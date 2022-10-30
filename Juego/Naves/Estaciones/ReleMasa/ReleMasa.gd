class_name ReleMasa
extends Node2D


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		$AnimationPlayer.play("activada")


func _on_DetectorPlayer_body_entered(body:Node) -> void:
	$DetectorPlayer/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("super_activada")
	body.desactivar_controles()
