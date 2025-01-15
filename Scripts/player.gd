extends CharacterBody2D

#player speed
var speed: float = 500
var speed_acceleration: float = speed/3
var speed_deceleration: float = speed/3

#dodging
var dodging_length: float = 0.1
var is_dodging:bool = false

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
	if is_dodging:
		return
	is_dodging = true
	var original_speed = speed
	var original_speed_acceleration = speed_acceleration
	var origonal_speed_deceleration = speed_deceleration
	
	# Mulitplying speed
	speed *= 4
	speed_acceleration *= 4
	speed_deceleration *= 4
	
	await get_tree().create_timer(dodging_length).timeout
	speed = original_speed
	speed_acceleration = original_speed_acceleration
	speed_deceleration = origonal_speed_deceleration
	
	is_dodging = false
