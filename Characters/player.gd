extends CharacterBody2D


@export var SPEED : float = 200.0
@export var JUMP_VELOCITY : float = -185.0
@export var DOUBLE_JUMP_VELOCITY : float = -150.0
@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var doublejump_available = true
var animation_locked : bool = false
var was_in_air : bool = false

func _physics_process(delta):
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		doublejump_available = true
		animation_locked = false
		
	# Handle Jump.
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			jump()
		elif doublejump_available:
			velocity.y = DOUBLE_JUMP_VELOCITY
			doublejump_available = false
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	player_animations()
	update_player_direction()
	
func player_animations():
		#Animations
	
	if not animation_locked:
		#print("Animation unlocked")
		
		if (velocity.x > 1 || velocity.x  < -1):
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
			#print(animation_locked)
	
func jump():
	velocity.y = JUMP_VELOCITY
	animated_sprite.play("jump_start")
	animation_locked = true
	
func land():
	animated_sprite.play("jump_end")
	animation_locked = false

func update_player_direction():
	var isLeft  = velocity.x < 0
	animated_sprite.flip_h = isLeft
	
		
func _on_animated_sprite_2d_animation_finished():
	print("Inside animation fin")
	if (animated_sprite.animation == "jump_start"):
	#if(["jump_end", "jump_start"].has(animated_sprite.animation)):
		animation_locked = false
