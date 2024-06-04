extends Sprite2D
class_name PlayerTexture

@onready var animation : AnimationPlayer = get_node("../Animation")
@onready var player : CharacterBody2D = get_node("../")


func animate(direction: Vector2) -> void:
	verify_position(direction)
	
	if direction.y !=0:
		vertical_behavior(direction)
	elif player.landing == true:
		animation.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)
	

func  verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
	elif direction.x < 0:
		flip_h = true

func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation.play("fall")
	elif direction.y < 0:
		animation.play("jump")

func horizontal_behavior(direction: Vector2) -> void:
	if direction.x != 0:
		#play na animação run
		animation.play("run")
	else:
		#play na animação de idle
		animation.play("idle")


func on_animation_finished(anim_name: String):
	match anim_name:
		"landing":
			player.landing = false
			player.set_physics_process(true)
	
