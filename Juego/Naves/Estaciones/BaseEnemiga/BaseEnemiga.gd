class_name BaseEnemiga
extends Node2D


export var vida:float = 30.0
export var orbital:PackedScene = null

onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX

var esta_destruida:bool = false


func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aleatoria())


func elegir_animacion_aleatoria() -> String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size()
	var indice_anim_aleatoria:int = randi() % num_anim
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	print(lista_animacion[indice_anim_aleatoria])
	return lista_animacion[indice_anim_aleatoria]


func recibir_danio(danio:float) -> void:
	vida -= danio
	
	if vida <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
		
	impacto_sfx.play()


func destruir() -> void:
	var sprites_pos = [
		$Sprites/SpaceStation1.global_position,
		$Sprites/SpaceStation2.global_position,
		$Sprites/SpaceStation3.global_position,
		$Sprites/SpaceStation4.global_position
	]
	
	Eventos.emit_signal("base_destruida", self, sprites_pos)
	queue_free()


func spawner_orbital() -> void:
	var pos_spawn:Vector2 = deteccion_cuadrante()
	
	var nueva_orbital:EnemigoOrbital = orbital.instance()
	nueva_orbital.crear(
		global_position + pos_spawn,
		self
	)
	
	Eventos.emit_signal("spawn_orbital", nueva_orbital)


func deteccion_cuadrante() -> Vector2:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	
	if not player_objetivo:
		return Vector2.ZERO
	
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player:float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
		# entra por derecha
		return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
		#izquierda
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		if sign(angulo_player) > 0:
			#abajo
			return $PosicionesSpawn/Sur.position
		else:
			#arriba
			return $PosicionesSpawn/Norte.position
	
	return $PosicionesSpawn/Norte.position


func _on_AreaColision_body_entered(body:Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered():
	$VisibilityNotifier2D.queue_free()
	spawner_orbital()
