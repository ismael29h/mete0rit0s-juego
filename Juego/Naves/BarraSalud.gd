class_name BarraSalud
extends ProgressBar


onready var tween_visibilidad:Tween = $TweenVisibilidad
export var siempre_visible:bool = false

func _ready() -> void:
	modulate = Color(1,1,1, siempre_visible)


func set_valores(vida:float) -> void:
	max_value = vida
	value = vida


func set_vida_actual(vida:float) -> void:
	value = vida


func controlar_barra(vida_nave:float, mostrar:bool) -> void:
	value = vida_nave
	if not tween_visibilidad.is_active() and modulate.a != int(mostrar):
		tween_visibilidad.interpolate_property(
			self,
			"modulate",
			Color(1,1,1, not mostrar),
			Color(1,1,1, mostrar),
			1.0,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		tween_visibilidad.start()


func _on_TweenVisibilidad_tween_all_completed():
	if modulate.a == 1.0:
		controlar_barra(value, false)
