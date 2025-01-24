extends CharacterBody2D

#player speed
var speed: float = 500
var speed_acceleration: float = speed/3
var speed_deceleration: float = speed/3

#dodging
@onready var dash_cooldown:Timer = $"Timers/Dash cooldown"
var dodging_length: float = 0.05

func  _physics_process(_delta: float) -> void:
	
#PLAYER INPUTS
	# Player slowly moves up to target speed, then slowly slows down to zero
	var direction = Input.get_vector("left","right","up","down")
	if (direction):
		velocity = velocity.move_toward(direction * speed, speed_acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed_deceleration)
	if Input.is_action_just_pressed("dodge"): dodge()

	move_and_slide()

func dodge():
# If you moving, or dash cooldown is active, exit function
	if not dash_cooldown.is_stopped() or velocity == Vector2.ZERO :
		return

#TEMPORARY LINE, DELETE SOON
	invincible(0.3)

	dash_cooldown.start()
	var original_speed = speed
	var original_speed_acceleration = speed_acceleration
	
	# Mulitplying speed
	speed *= 4
	speed_acceleration *= 4
	
	await get_tree().create_timer(dodging_length).timeout
	speed = original_speed
	speed_acceleration = original_speed_acceleration
	

func invincible(invincibility_length:float = 0.5):
	$Sprite2D.self_modulate.a = 0.5
	await get_tree().create_timer(invincibility_length).timeout
	$Sprite2D.self_modulate.a = 1
