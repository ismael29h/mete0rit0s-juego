extends Node2D

class_name Nivel

onready var contenedor_proyectiles:Node


func _ready() -> void:
	conectar_seniales()
	crear_contenedores()

func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)


func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")


func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ProyectilesDisparados"
	add_child(contenedor_proyectiles)
