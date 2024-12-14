extends CharacterBody2D

@export var speed:= 100.0
var direction: Vector2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	
	direction = Input.get_vector("left","right","down","up")
	velocity = direction * speed
