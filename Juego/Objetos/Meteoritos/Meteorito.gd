extends RigidBody2D
class_name Meteorito

export var vel_lineal_base:Vector2 = Vector2(300.0,300.0)
export var vel_ang_base:float = 3.0
export var vida_base:float = 10.0

onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX
onready var impacto_anim:AnimationPlayer = $ImpactoAnimation

var vida:float
var esta_en_sector:bool = true setget set_esta_en_sector
var pos_spawn_original:Vector2
var vel_spawn_original:Vector2
var esta_destruido = false


#func _ready() -> void:
#	angular_velocity = vel_ang_base


func crear(pos:Vector2, dir:Vector2, volumen:float) -> void:
	position = pos
	pos_spawn_original = position
	#linear_velocity = vel_lineal_base * dir
	# masa
	mass *= volumen
	# tamaño
	$Sprite.scale = Vector2.ONE * volumen
	# radio = diámetro/2 -> sin embargo se usará 2.3 para menor área de colisión
	var radio:int = int($Sprite.texture.get_size().x / 2.3*volumen)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	# velocidades
	linear_velocity = (vel_lineal_base * dir / volumen) * aleatorizar()
	vel_spawn_original = linear_velocity
	angular_velocity = (vel_ang_base / volumen) * aleatorizar()
	# Hitpoints
	vida = vida_base * volumen


func recibir_danio(danio:float) -> void:
	vida -= danio
	if vida <= 0 and not esta_destruido:
		# a causa del doble disparo...
		esta_destruido = true
		destruir()
	impacto_sfx.play()
	impacto_anim.play("impacto")


func set_esta_en_sector(valor:bool) -> void:
	esta_en_sector = valor


func _integrate_forces(state:Physics2DDirectBodyState) -> void:
	if esta_en_sector:
		return
	
	var mi_transform := state.get_transform()
	mi_transform.origin = pos_spawn_original
	linear_velocity = vel_spawn_original
	state.set_transform(mi_transform)
	esta_en_sector = true


func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("destruccion_meteorito", global_position)
	queue_free()


func aleatorizar() -> float:
	randomize()
	return rand_range(1.1, 1.4)


#func _on_body_entered(body:Node) -> void:
#	if body is Player:
#		body.destruir()
#		destruir()


