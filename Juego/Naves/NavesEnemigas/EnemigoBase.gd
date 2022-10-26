class_name EnemigoBase

extends NaveBase

var player_objetivo:Player = null


func _ready() -> void:
	# IMPORTANTE: DENTRO DEL NIVEL, TENER CUIDADO EL ORDEN DE INSTANCIAS DEL PLAYER Y LOS ENEMIGOS
	player_objetivo = DatosJuego.get_player_actual()
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	numero_explosiones = 1


func _physics_process(delta:float) -> void:
	rotar_hacia_player()


func rotar_hacia_player() -> void:
	if player_objetivo:
		var dir_player:Vector2 = player_objetivo.global_position - global_position
		rotation = dir_player.angle()


# señales
func _on_body_entered(body:Node) -> void:
	._on_body_entered(body) # llamada al método de la clase padre
	if body is Player:
		body.destruir()
		destruir()

func _on_nave_destruida(nave:NaveBase, _posicion, _explosiones) -> void:
	if nave is Player:
		player_objetivo = null
