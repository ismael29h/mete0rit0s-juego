extends Node2D


func _ready() -> void:
	$Node/ColorRect.visible = false

func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		MusicaJuego.play_button()
		$Node/ColorRect.visible = not $Node/ColorRect.visible
		get_tree().paused = not get_tree().paused
