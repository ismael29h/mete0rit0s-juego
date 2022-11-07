extends Node2D


export(String, FILE, "*.tscn") var nivel_inicial = ""

func _ready() -> void:
	OS.set_window_fullscreen(true)
	MusicaJuego.play_musica(MusicaJuego.get_lista_musicas().menu_principal)


func _on_BotonJugar_pressed() -> void:
	MusicaJuego.play_button()
# warning-ignore:return_value_discarded
	get_tree().change_scene(nivel_inicial)


func _on_BotonSalir_pressed() -> void:
	MusicaJuego.play_button()
	get_tree().quit()
