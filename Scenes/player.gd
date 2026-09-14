extends CharacterBody2D

@export var speed := 250.0

func _physics_process(_delta):
	var direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	direction = direction.normalized()

	velocity = direction * speed

	move_and_slide()
