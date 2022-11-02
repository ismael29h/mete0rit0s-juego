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
signal detecto_zona_recarga(entrando)
signal cambio_numero_meteoritos(numero)
signal actualizar_tiempo(tiempo_restante)
signal cambio_energia_laser(energia_max, energia_actual)
# los siguientes no funcionaban dentro de HUD.gd
signal ocultar_energia_laser()
signal ocultar_energia_escudo()
signal cambio_energia_escudo(energia_max, energia_actual)
