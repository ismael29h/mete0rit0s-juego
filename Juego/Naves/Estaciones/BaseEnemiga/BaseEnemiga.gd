class_name BaseEnemiga
extends Node2D


export var vida:float = 30.0
export var orbital:PackedScene = null
export var num_orbitales:int = 4
export var intervalo_spawn:float = 1.2

onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX
onready var timer_spawner:Timer = $TimerSpawnerEnemigos

var esta_destruida:bool = false
var posicion_spawn:Vector2 = Vector2.ZERO


func _ready() -> void:
	timer_spawner.wait_time = intervalo_spawn
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
	Eventos.emit_signal("minimapa_objeto_destruido", self)
	queue_free()


func spawner_orbital() -> void:
	num_orbitales -= 1
	$RutaEnemigo.global_position = global_position

	var pos_spawn:Vector2 = deteccion_cuadrante()

	var nueva_orbital:EnemigoOrbital = orbital.instance()
	nueva_orbital.crear(
		global_position + pos_spawn,
		self,
		$RutaEnemigo
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
		$RutaEnemigo.rotation_degrees = 180.0
		return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
		#izquierda
		$RutaEnemigo.rotation_degrees = 0.0
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		if sign(angulo_player) > 0:
			#abajo
			$RutaEnemigo.rotation_degrees = 270.0
			return $PosicionesSpawn/Sur.position
		else:
			#arriba
			$RutaEnemigo.rotation_degrees = 90.0
			return $PosicionesSpawn/Norte.position
	
	return $PosicionesSpawn/Norte.position


func _on_AreaColision_body_entered(body:Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered():
	$VisibilityNotifier2D.queue_free()
	posicion_spawn = deteccion_cuadrante()
	spawner_orbital()
	timer_spawner.start()


func _on_TimerSpawnerEnemigos_timeout():
	if num_orbitales == 0:
		timer_spawner.stop()
		return
	
	spawner_orbital()
