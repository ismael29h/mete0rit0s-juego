extends AudioStreamPlayer2D

class_name Motor

export var tiempo_transicion:float = 0.6
export var volumen_apagado:float = -30.0

onready var tween_sonido:Tween = $Tween

var volumen_original:float

func _ready() -> void:
	volumen_original = volume_db
	volume_db = volumen_apagado


func encender_motor() -> void:
	if not playing:
		play()
	transicion(volume_db, volumen_original)

func apagar_motor() -> void:
	transicion(volume_db, volumen_apagado)


func transicion(inicio:float, final:float) -> void:
	tween_sonido.interpolate_property(
		self,
		"volume_db",
		inicio,
		final,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	tween_sonido.start()
