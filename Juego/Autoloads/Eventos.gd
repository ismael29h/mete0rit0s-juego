extends Node

signal disparo(proyectil)
signal nave_destruida(nave, posicion, explosiones)
signal lluvia_meteoritos(posicion, direccion, volumen)
signal destruccion_meteorito(posicion)
signal nave_en_sector_peligro(centro_camara, tipo_peligro, num_peligros)
signal base_destruida(base, posiciones)
signal spawn_orbital(orbital)
signal nivel_iniciado()
signal nivel_terminado()
