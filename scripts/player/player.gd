extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = get_node("Texture")#acesso as minhas texturas filho de player
@onready var wall_ray: RayCast2D = get_node("WallRay")#acesso ao filho Wallray sobre slide da parede
@onready var stats: Node = get_node("Stats")#acesso ao filho Stats
@export var speed: int #velocidade
@export var jump_speed: int #velocidade de pulo
@export var wall_jump_speed: int#velocidade de pilo parede
@export var wall_gravity: int #gravidade da parede
@export var wall_impulse_speed: int #gravidade da parede
@export var player_gravity: int #gravidade do player

var direction: int = 1
var jump_count: int = 0 #ação de contar os pulos
var landing: bool = false #ação de cair no solo
var on_wall: bool = false# ação para saber se está na parede
var attacking: bool = false #ação de atacar
var defending: bool = false #ação de defender
var crouching: bool = false #ação de agachar
var on_hit: bool = false #ação de tomar hit
var dead: bool = false #ação de morte

var can_track_input: bool = true # caso o personagem 
#estiver defendendo, etc. não vai pode fazer ações
var not_on_wall: bool = true

func _physics_process(delta): #processo de físicas
	horizontal_movement_env() #movimento horizontal
	vertical_movement_env()#movimento vertical
	action_env()#ações de defender, etc..
	
	gravity(delta)#gravidade
	move_and_slide()
	player_sprite.animate(velocity)#animação
	
func horizontal_movement_env() -> void:
	#personagem irá andar para esquerda e direita
	var input_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	if can_track_input == false or attacking:
		velocity.x = 0
		return
	velocity.x = input_direction * speed
	
func vertical_movement_env() -> void:
	if is_on_floor() or is_on_wall():#se ele tiver no chão zerar os count pulos
		jump_count = 0
	if Input.is_action_just_pressed("ui_select") and jump_count < 2 and can_track_input and not attacking:# se precionar o SPACE ira pular no máximo 2 pulos
		jump_count += 1 #conta os pulos
		if  next_to_wall() and not is_on_floor():
			velocity.y = wall_jump_speed
			velocity.x += wall_impulse_speed * direction
		else:
			velocity.y = jump_speed#faz os pulos normal
			
			

func action_env() -> void:
	attack()
	crouch()
	defense()
	
func attack() -> void:
	var attack_condition: bool = not attacking and not crouching and not defending
	if Input.is_action_just_pressed("attack") and attack_condition and is_on_floor():
		attacking = true
		player_sprite.normal_attack = true
	
func crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		can_track_input = false
		stats.shielding = false
	elif  not defending:
		crouching = false
		can_track_input = true
		stats.shielding = false
		player_sprite.crouching_off = true
		
func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		can_track_input = false
		stats.shielding = true
	elif  not crouching:
		defending = false
		can_track_input = true
		stats.shielding = false
		player_sprite.shield_off = true
		
	
func gravity(delta: float) -> void:
	if next_to_wall():
		velocity.y += wall_gravity * delta
		if velocity.y >= wall_gravity:
			velocity.y = wall_gravity
			
	else:
		velocity.y += delta * player_gravity
		if velocity.y >= player_gravity:
			velocity.y = player_gravity
			

func next_to_wall() -> bool:
	if wall_ray.is_colliding() and not is_on_floor():
		if not_on_wall:
			velocity.y = 0
			not_on_wall = false
		return true
	else:
		not_on_wall = true
		return false
	

func _on_attack_area_body_entered(body):
	body.update_health(randi_range(1,1))
