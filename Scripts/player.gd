extends CharacterBody2D

@onready var lulu_sprite: Sprite2D = $LuluSprite

#player speed
const speed: float = 500
var speed_Modifier: float = 1
var speed_acceleration: float = speed/3
var speed_deceleration: float = speed/3
	#multiplication of speed during dashes
var speed_acceleration_dash_multiplication: float = 4
var speed_dash_multiplication: float = 4
	#multiplication of speed during bow draw
var speed_acceleration_bow_multiplication: float = 0.4
var speed_bow_multiplication: float = 0.4

#dodging
@onready var dash_cooldown:Timer = $"Timers/Dash cooldown"
var dodging_length: float = 0.05

func  _physics_process(_delta: float) -> void:
	$Label.text = str(speed_acceleration)
#region Movement
#PLAYER INPUTS
	# Player slowly moves up to target speed, then slowly slows down to zero
	var direction = Input.get_vector("left","right","up","down")
	if (direction):
		velocity = velocity.move_toward(direction * (speed * speed_Modifier), speed_acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed_deceleration)
#endregion
	if Input.is_action_just_pressed("dodge"): dodge()
#region Shooting
	if Input.is_action_just_pressed("shoot"): 
		shoot()
	if Input.is_action_just_released("shoot"): 
		speed_Modifier *= 1/speed_acceleration_bow_multiplication
#endregion
	move_and_slide()

func shoot():
	# Mulitplying speed
	speed_Modifier *= speed_acceleration_bow_multiplication
	

func dodge():
# If you moving, or dash cooldown is active, exit function
	if not dash_cooldown.is_stopped() or velocity == Vector2.ZERO :
		return
	
#TEMPORARY LINE, DELETE SOON
	invincible(dash_cooldown.time_left)
	
	dash_cooldown.start()
	
	# Mulitplying speed
	speed_Modifier *= speed_dash_multiplication
	speed_acceleration *= speed_acceleration_dash_multiplication
	# Wait [dodging_length] amount of time before ending the dash
	await get_tree().create_timer(dodging_length).timeout
	speed_Modifier *= speed_dash_multiplication
	speed_acceleration *= speed_acceleration

func invincible(invincibility_length:float = 0.5):
	lulu_sprite.self_modulate.a = 0.5
	await get_tree().create_timer(invincibility_length).timeout
	lulu_sprite.self_modulate.a = 1
