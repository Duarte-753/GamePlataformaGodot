extends Sprite2D
class_name EnemyTexture

@onready var animation : AnimationPlayer = get_node("../Animation")
@onready var enemy : CharacterBody2D = get_node("../")
@onready var attack_area_collision : CollisionObject2D = get_node("../EnemyAttackArea")

func animate(_velocity) -> void:
	pass


func on_animation_finished(_anim_name: String) -> void:
	pass # Replace with function body.
