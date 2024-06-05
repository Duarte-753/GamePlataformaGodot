extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = get_node("Texture")#acesso as minhas texturas filho de player
@onready var wall_ray: RayCast2D = get_node("WallRay")#acesso ao filho Wallray sobre slide da parede
@export var speed: int #velocidade
@export var jump_speed: int #velocidade de pulo
@export var player_gravity: int #gravidade do player
var jump_count: int = 0 #ação de contar os pulos
var landing: bool = false #ação de cair no solo
var attacking: bool = false #ação de atacar
var defending: bool = false #ação de defender
var crouching: bool = false #ação de agachar

var can_track_input: bool = true # caso o personagem 
#estiver defendendo, etc. não vai pode fazer ações

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
	if is_on_floor():#se ele tiver no chão zerar os count pulos
		jump_count = 0
	if Input.is_action_just_pressed("ui_select") and jump_count < 2 and can_track_input and not attacking:# se precionar o SPACE ira pular no máximo 2 pulos
		jump_count += 1 #conta os pulos
		velocity.y = jump_speed#faz os pulos
	
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
	elif  not defending:
		crouching = false
		can_track_input = true
		player_sprite.crouching_off = true
		
func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		can_track_input = false
	elif  not crouching:
		defending = false
		can_track_input = true
		player_sprite.shield_off = true
		
	
func gravity(delta) -> void:
	velocity.y += delta * player_gravity
	if velocity.y >= player_gravity:
		velocity.y = player_gravity
