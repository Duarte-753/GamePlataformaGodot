extends Node2D
class_name  Level

@onready var player : CharacterBody2D = get_node("Player")

func _ready() -> void:
	var _game_over: bool = player.get_node("Texture").connect("game_over", Callable(self ,"on_game_over"))

func on_game_over():
	var _reload: bool = get_tree().reload_current_scene()
