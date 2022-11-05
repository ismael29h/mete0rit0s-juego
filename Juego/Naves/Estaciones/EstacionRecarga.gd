extends Node2D
class_name EstacionRecarga

export var energia:float = 6.0
export var radio_energia_entregada:float = 0.05

onready var sprite_recarga:Sprite = $AreaRecarga/SpriteZonaRecarga
onready var carga_sfx:AudioStreamPlayer2D = $CargaSFX
onready var barra_energia:ProgressBar = $BarraEnergia

var nave_player:Player = null
var player_en_zona:bool = false
var energia_max:float = energia


func _ready() -> void:
	barra_energia.max_value = energia
	barra_energia.value = energia


func _unhandled_input(event:InputEvent) -> void:
	if not puede_recargar(event):
		return
	
	if event.is_action("recarga_escudo"):
		nave_player.get_escudo().control_energia(-radio_energia_entregada)
		energia -= radio_energia_entregada
			
	elif event.is_action("recarga_laser"):
		nave_player.get_laser().control_energia(-radio_energia_entregada)
		energia -= radio_energia_entregada

	if event.is_action_released("recarga_laser"):
		Eventos.emit_signal("ocultar_energia_laser")
	elif event.is_action_released("recarga_escudo"):
		Eventos.emit_signal("cambio_energia_escudo", energia_max, energia)

func puede_recargar(event:InputEvent) -> bool:
	if sprite_recarga.visible:
		var hay_input = event.is_action("recarga_escudo") or event.is_action("recarga_laser")
		if hay_input and player_en_zona and energia > 0.0:
			if !carga_sfx.playing:
				carga_sfx.play()
			return true
		
		# cuando la estacion queda sin energía, detalle visual
		if energia <= 0.0:
			sprite_recarga.visible = false
			$VacioSFX.play()
		barra_energia.value = energia
	return false


func _on_AreaColision_body_entered(body:Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_AreaRecarga_body_entered(body:Node) -> void:
	if body is Player:
		player_en_zona = true
		nave_player = body
		Eventos.emit_signal("detecto_zona_recarga", true)
	body.set_gravity_scale(0.1)
	


func _on_AreaRecarga_body_exited(body:Node) -> void:
	if body is Player:
		player_en_zona = false
		Eventos.emit_signal("detecto_zona_recarga", false)
	body.set_gravity_scale(0.0)
	
