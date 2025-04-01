extends CharacterBody2D

func _process(_delta: float) -> void:
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self:
		queue_free()
