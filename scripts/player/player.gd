extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = get_node("Texture")#acesso as minhas texturas
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
	velocity.x = input_direction * speed
	
func vertical_movement_env() -> void:
	if is_on_floor():#se ele tiver no chão zerar os count pulos
		jump_count = 0
	if Input.is_action_just_pressed("ui_select") and jump_count < 2:# se precionar o SPACE ira pular no máximo 2 pulos
		jump_count += 1 #conta os pulos
		velocity.y = jump_speed#faz os pulos
	
func action_env() -> void:
	attack()
	crouch()
	defense()
	
func attack() -> void:
	pass
func crouch() -> void:
	pass
func defense() -> void:
	pass
func gravity(delta) -> void:
	velocity.y += delta * player_gravity
	if velocity.y >= player_gravity:
		velocity.y = player_gravity
