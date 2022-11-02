extends Node2D

class_name Nivel

export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var explosion_meteorito:PackedScene = null
export var sector_meteoritos:PackedScene = null
export var enemigo_interceptor:PackedScene = null
export var rele_masa:PackedScene = null
export var tiempo_transicion_camara:float = 2

onready var contenedor_proyectiles:Node
onready var contenedor_meteoritos:Node
onready var contenedor_explosiones:Node
onready var contenedor_sector_meteoritos:Node
onready var contenedor_enemigos:Node
onready var camara_nivel:Camera2D = $CameraNivel
onready var camara_player:Camera2D = $Player/CameraPlayer

var meteoritos_totales:int = 0
var player:Player = null
var num_bases_enemigas = 0


func _ready() -> void:
	Eventos.emit_signal("nivel_iniciado")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	conectar_seniales()
	crear_contenedores()
	num_bases_enemigas = contabilizar_bases_enemigas()
	player = DatosJuego.get_player_actual()


func contabilizar_bases_enemigas() -> int:
	return $ContenedorBasesEnemigas.get_child_count()


func crear_rele() -> void:
	var nuevo_rele_masa:ReleMasa = rele_masa.instance()
	var pos_aleatoria:Vector2 = crear_posicion_aleatoria(400.0, 200.0)
	var margen:Vector2 = Vector2(600.0, 600.0)
	if pos_aleatoria.x < 0:
		margen.x *= -1
	if pos_aleatoria.y < 0:
		margen.y *= -1
	
	nuevo_rele_masa.global_position = player.global_position + (margen + pos_aleatoria)
	add_child(nuevo_rele_masa)


func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	Eventos.connect("lluvia_meteoritos", self, "_on_spawn_meteoritos")
	Eventos.connect("destruccion_meteorito", self, "_on_meteorito_destruido")
	Eventos.connect("nave_en_sector_peligro", self, "_on_nave_en_sector_peligro")
	Eventos.connect("base_destruida", self, "_on_base_destruida")
	Eventos.connect("spawn_orbital", self, "_on_spawn_orbital")


func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ProyectilesDisparados"
	add_child(contenedor_proyectiles)
	
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "ContenedorMeteoritos"
	add_child(contenedor_meteoritos)
	
	contenedor_explosiones = Node.new()
	contenedor_explosiones.name = "ContenedorExplosiones"
	add_child(contenedor_explosiones)

	contenedor_sector_meteoritos = Node.new()
	contenedor_sector_meteoritos.name = "ContenedorSectorMeteoritos"
	add_child(contenedor_sector_meteoritos)

	contenedor_enemigos = Node.new()
	contenedor_enemigos.name = "ContenedorEnemigos"
	add_child(contenedor_enemigos)


func crear_sector_meteoritos(centro_camara:Vector2, numero_peligros:int) -> void:
	meteoritos_totales = numero_peligros
	var nuevo_sector_meteoritos:SectorMeteoritos = sector_meteoritos.instance()
	nuevo_sector_meteoritos.crear(centro_camara, numero_peligros)
	camara_nivel.global_position = centro_camara
	#camara_nivel.current = true
	contenedor_sector_meteoritos.add_child(nuevo_sector_meteoritos)
	transicion_camaras(
		camara_player.global_position,
		camara_nivel.global_position,
		camara_nivel
	)


func crear_sector_enemigos(num_enemigos:int) -> void:
	for i in range(num_enemigos):
		var nuevo_interceptor:EnemigoInterceptor = enemigo_interceptor.instance()
		var spawn_pos:Vector2 = crear_posicion_aleatoria(1400.0, 1000) # (1000.0, 800.0)
		nuevo_interceptor.global_position = player.global_position + spawn_pos
		contenedor_enemigos.add_child(nuevo_interceptor)


func meteoritos_restantes() -> void:
	meteoritos_totales -= 1
	Eventos.emit_signal("cambio_numero_meteoritos", meteoritos_totales)
	if meteoritos_totales == 0:
		contenedor_sector_meteoritos.get_child(0).queue_free()
		#transicion_camaras(
		#	camara_nivel.global_position,
		#	camara_player.global_position,
		#	camara_player
		#)
		# Decidí resolver el bug de cámara de esta manera, sigue siendo brusco...
		# ... intentando disimularlo con la animación de spawn
		$Player/AnimationPlayer.play("spawn")
		camara_nivel.current = false
		camara_player.current = true


func crear_posicion_aleatoria(rango_horiz:float, rango_vert:float) -> Vector2:
	randomize()
	var rand_x = rand_range(-rango_horiz, rango_horiz)
	var rand_y = rand_range(-rango_vert, rango_vert)
	
	return Vector2(rand_x, rand_y)


func transicion_camaras(desde:Vector2, hasta:Vector2, camara_actual:Camera2D) -> void:
	$TweenCamara.interpolate_property(
		camara_actual,
		"global_position",
		desde,
		hasta,
		tiempo_transicion_camara,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	camara_actual.current = true
	$TweenCamara.start()
	
	
func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)


func _on_nave_destruida(nave:Player, posicion:Vector2, explosiones:int) -> void:
	if nave is Player:
		transicion_camaras(
			posicion,
			posicion + crear_posicion_aleatoria(-200.0, 200.0),
			camara_nivel
		)
		
		$RestartTimer.start()
		
	#crear_explosion(posicion, explosiones, 0.0, Vector2(100.5, 50.0))
	for i in range(explosiones):	
		var nueva_explosion:Node2D = explosion.instance()
		nueva_explosion.global_position = posicion + crear_posicion_aleatoria(100.0, 50.0)
		contenedor_explosiones.add_child(nueva_explosion)
		yield(get_tree().create_timer(0.17), "timeout")


func crear_explosion(
	pos:Vector2,
	num:int = 1,
	intervalo:float = 0.0,
	rango_random:Vector2 = Vector2(0.0, 0.0)
) -> void:
	for _i in range(num):
		var nueva_explosion:Node2D = explosion.instance()
		nueva_explosion.global_position = pos + crear_posicion_aleatoria(
			rango_random.x,
			rango_random.y
		)
		contenedor_explosiones.add_child(nueva_explosion)
		yield(get_tree().create_timer(intervalo), "timeout")


func _on_spawn_meteoritos(pos_spawn:Vector2, dir_meteorito:Vector2, volumen:float) -> void:
	var nuevo_meteorito:Meteorito = meteorito.instance()
	nuevo_meteorito.crear(
		pos_spawn,
		dir_meteorito,
		volumen
	)
	contenedor_meteoritos.add_child(nuevo_meteorito)


func _on_meteorito_destruido(pos:Vector2) -> void:
	var nueva_explosion:ExplosionMeteorito = explosion_meteorito.instance()
	nueva_explosion.global_position = pos
	contenedor_explosiones.add_child(nueva_explosion)
	
	meteoritos_restantes()


func _on_nave_en_sector_peligro(centro_cam:Vector2, tipo_peligro:String, num_peligros:int) -> void:
	if tipo_peligro == "Meteorito":
		crear_sector_meteoritos(centro_cam, num_peligros)
		Eventos.emit_signal("cambio_numero_meteoritos", num_peligros)
	elif tipo_peligro == "Enemigo":
		crear_sector_enemigos(num_peligros)


func _on_spawn_orbital(enemigo:EnemigoOrbital) -> void:
	contenedor_enemigos.add_child(enemigo)


func _on_base_destruida(_base, sprites_pos:Array) -> void:
	print(sprites_pos)
	for pos in sprites_pos:
		crear_explosion(pos, 2.0)
		yield(get_tree().create_timer(0.5), "timeout")
		
	num_bases_enemigas -= 1
	if num_bases_enemigas == 0:
		crear_rele()


func _on_RestartTimer_timeout() -> void:
	Eventos.emit_signal("nivel_terminado")
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().reload_current_scene()
