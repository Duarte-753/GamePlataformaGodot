extends EnemyTexture #herda de EnemyTexture do enemy_template #não dará problema pelo enemytexture herda Sprite2D
class_name WhaleTexture

func animate(velocity) ->void:
	move_behavior(velocity)

func move_behavior(velocity) -> void:
	if velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
