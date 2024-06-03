extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = get_node("Texture")

@export var speed: int

func _physics_process(delta):
	horizontal_movement_env()
	move_and_slide()
	player_sprite.animate(velocity)
	
func horizontal_movement_env() -> void:
	#personagem irá andar para esquerda e direita
	var input_direction =Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	velocity.x = input_direction * speed
	
