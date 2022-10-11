extends Node2D

class_name Nivel

export var explosion:PackedScene = null

onready var contenedor_proyectiles:Node


func _ready() -> void:
	conectar_seniales()
	crear_contenedores()


func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")

func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ProyectilesDisparados"
	add_child(contenedor_proyectiles)


func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)


func _on_nave_destruida(posicion:Vector2) -> void:
	var nueva_explosion:Node2D = explosion.instance()
	nueva_explosion.global_position = posicion
	add_child(nueva_explosion)
