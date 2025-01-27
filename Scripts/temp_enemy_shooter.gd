extends CharacterBody2D

@export var speed:float = 200
@onready var shooting_cooldown: Timer = $"Shooting cooldown"
const BASIC_BOOLET = preload("res://Scenes/basic_boolet.tscn")



func _on_shooting_cooldown_timeout() -> void:
	var basic_boolet: CharacterBody2D = BASIC_BOOLET.instantiate()
	var collisionShape:CollisionShape2D = $CollisionShape2D
	basic_boolet.position = position + Vector2(collisionShape.shape.size.x, 0)
	basic_boolet.velocity = Vector2.RIGHT * speed
	get_parent().add_child(basic_boolet)
