extends CharacterBody2D
class_name EnemyTemplate

@onready var texture: Sprite2D = get_node("Texture")#acesso as minhas texturas filho de EnemyTemplate
@onready var floor_ray: RayCast2D = get_node("FloorRay")
@onready var animation: AnimationPlayer = get_node("Animation")
@onready var enemy : CharacterBody2D = get_node(".")

var can_die: bool = false #pode atacar 
var can_hit: bool = false #pode ter hit
var can_attack: bool = false #pode atacar

var player_ref: Player = null

@export var health: int = 6 #verificar depois cada inimigo vai ter seu heath
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
			
func kill_enemy() -> void:
	animation.play("kill")
	
func update_health(demage: int) -> void:
	health -= demage
	if health <= 0:
		enemy.can_die = true
		return
	enemy.can_hit = true
	


func _on_enemy_attack_area_area_entered(area):
	if area.get_parent() is Player:
		#var colisao_enemy_attack: String = "EnemyAttackArea"
		area.get_parent().stats.on_collision_area_entered(area)
	 
	


func _on_enemy_attack_area_body_entered(body):
	if body is Player:
		var colisao_enemy_attack: String = "EnemyAttackArea"
		var dano_enemy: Node = get_parent().get_node("../EnemyAttackArea")
		body.stats.on_collision_area_entered(colisao_enemy_attack, dano_enemy.demage)
