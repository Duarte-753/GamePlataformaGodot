extends CharacterBody2D

@onready var texture: Sprite2D = get_node("Texture")#acesso as minhas texturas filho de EnemyTemplate
@onready var floor_ray: RayCast2D = get_node("FloorRay")
@onready var animation: AnimationPlayer = get_node("Animation")

var can_die: bool = false #pode atacar 
var can_hit: bool = false #pode ter hit
var can_attack: bool = false #pode atacar

var player_ref: Player = null

@export var speed: int
@export var gravity_speed: int
@export var proximity_threshold: int
@export var raycast_default_position: int

func _physics_process(delta: float) -> void:
	gravity(delta)
	move_behavior()
	verify_position()
	texture.animate(velocity)
	move_and_slide()
	
func gravity(delta: float) -> void:
	velocity.y += delta * gravity_speed
	
func move_behavior() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		if  abs(distance.x) <= proximity_threshold:  #abs significa módulo, técnicamente resto da operação
			velocity.x = 0
			can_attack = true
		elif floor_collision() and not can_attack:
			velocity.x = direction.x * speed
			
		else:
			velocity.x = 0
			
		return
	velocity.x = 0
	
func floor_collision() -> bool: # bool retorna true ou false
	if floor_ray.is_colliding(): 
		return true 
	return false
	
func verify_position() -> void:
	if player_ref != null:
		var direction: float = sign(player_ref.global_position.x - global_position.x)
		if direction > 0:
			texture.flip_h = true
			floor_ray.position.x = abs(raycast_default_position)
		elif direction < 0:
			texture.flip_h = false
			floor_ray.position.x = raycast_default_position
