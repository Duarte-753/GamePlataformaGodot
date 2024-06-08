extends Area2D
class_name DetectioArea

#@onready var player : CharacterBody2D = get_node("../")

@onready var enemy : CharacterBody2D = get_node("../")


func _on_body_entered(body: Player) -> void: #corpo que vai estar entrando em contato é o player
	enemy.player_ref = body
	
func _on_body_exited(_body: Player) -> void:
	enemy.player_ref = null
