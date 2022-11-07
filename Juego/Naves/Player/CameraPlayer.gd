extends Camera2D
class_name CameraPlayer

# En mi caso, no hubo necesidad de crear "CamaraJuego.gd"...
# el zoom siempre vuelve a su estado original luego de la lluvia de meteoritos


export var variacion_zoom:float = 0.1
export var zoom_min:float = 0.8
export var zoom_max:float = 1.5

onready var tween_zoom:Tween = $TweenZoom


func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		controlar_zoom(-variacion_zoom)
	elif event.is_action_pressed("zoom_out"):
		controlar_zoom(variacion_zoom)


func controlar_zoom(modif_zoom:float) -> void:
	var zoom_x = clamp((zoom.x + modif_zoom), zoom_min, zoom_max)
	var zoom_y = clamp((zoom.y + modif_zoom), zoom_min, zoom_max)
	zoom_suavizado(zoom_x, zoom_y, 0.15)


func zoom_suavizado(nuevo_zoom_x: float, nuevo_zoom_y:float, tiempo:float) -> void:
# warning-ignore:return_value_discarded
	tween_zoom.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(nuevo_zoom_x, nuevo_zoom_y),
		tiempo,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
# warning-ignore:return_value_discarded
	tween_zoom.start()
