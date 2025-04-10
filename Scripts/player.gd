extends CharacterBody2D

@onready var lulu_sprite: Sprite2D = $LuluSprite

#player speed
const base_speed: float = 500
const base_acceleration: float = 170
	#multiplier of speed and acceleration during dashes
var is_dodging_speedAndAccelerationModifier = false
var speed_dash_multiplier: float = 4
var acceleration_dash_multiplier: float = 10
	#multiplier of speed and acceleration during bow draw
var is_drawingBow_speedAndAccelerationModifier = false
var speed_bow_multiplier: float = 0.4
var acceleration_bow_multiplier: float = 10

# Shooting
@onready var bow_strength_bar: ProgressBar = $"Bow/Bow Strength visualizer/Bow Strength Bar"
var bow_strength_increase = 2

#dodging (dodge length is determined by Timer node)
@onready var dash_cooldown:Timer = $"Timers/Dash cooldown"

func  _physics_process(_delta: float) -> void:
	#$Label.text = str(velocity)
	
#region Movement
#PLAYER INPUTS
	# Player slowly moves up to target speed, then slowly slows down to zero
	var direction = Input.get_vector("left","right","up","down")
	if (direction):
		velocity = velocity.move_toward(direction * final_speed(),
		#speed_acceleration * acceleration_dash_multiplier)
		final_acceleration())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, base_acceleration)
#endregion
#region Shooting
	if Input.is_action_pressed("shoot"): 
		shoot()
	if Input.is_action_just_released("shoot"): 
		is_drawingBow_speedAndAccelerationModifier = false
		#Resets the bow strength loading bar to be null and invisible
		bow_strength_bar.value = 0
		bow_strength_bar.visible = false
#endregion
	
	if Input.is_action_just_pressed("dodge"): dodge()
	
	move_and_slide()

func final_speed() -> float:
	var final_speed = base_speed
	
	if is_dodging_speedAndAccelerationModifier:
		final_speed *= speed_dash_multiplier
	if is_drawingBow_speedAndAccelerationModifier:
		final_speed *= speed_bow_multiplier
	
	return final_speed

func final_acceleration() -> float:
	var final_acceleration = base_acceleration
	
	if is_dodging_speedAndAccelerationModifier:
		final_acceleration *= acceleration_dash_multiplier
	if is_drawingBow_speedAndAccelerationModifier:
		final_acceleration *= acceleration_bow_multiplier
	
	return final_acceleration

func shoot():
#	if you are in the middle of dodging, leave function
	if is_dodging_speedAndAccelerationModifier:
		return
	is_drawingBow_speedAndAccelerationModifier = true
	
	bow_strength_bar.visible = true
	
	bow_strength_bar.value += bow_strength_increase

func dodge():
# If you moving, or dash cooldown is active, exit function
	if velocity == Vector2.ZERO or not dash_cooldown.is_stopped() :
		return
	
	is_dodging_speedAndAccelerationModifier = true
	
	dash_cooldown.start()
	
#TEMPORARY LINE, DELETE SOON
	invincible(dash_cooldown.time_left)

	#check _on_dash_cooldown_timeout() to see what happens when dash ends
func _on_dash_cooldown_timeout() -> void:
	is_dodging_speedAndAccelerationModifier = false
	

func invincible(invincibility_length:float = 0.5):
	lulu_sprite.self_modulate.a = 0.5
	await get_tree().create_timer(invincibility_length).timeout
	lulu_sprite.self_modulate.a = 1
