extends RigidBody2D
class_name Meteorito

export var vel_lineal_base:Vector2 = Vector2(300.0,300.0)
export var vel_ang_base:float = 3.0
export var vida_base:float = 10.0

onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX
onready var impacto_anim:AnimationPlayer = $ImpactoAnimation

var vida:float

#func _ready() -> void:
#	angular_velocity = vel_ang_base


func crear(pos:Vector2, dir:Vector2, volumen:float) -> void:
	position = pos
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
	linear_velocity = vel_lineal_base * dir / volumen
	angular_velocity = vel_ang_base / volumen
	# Hitpoints
	vida = vida_base * volumen


func recibir_danio(danio:float) -> void:
	vida -= danio
	if vida <= 0:
		destruir()
	impacto_sfx.play()
	impacto_anim.play("impacto")

func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()

