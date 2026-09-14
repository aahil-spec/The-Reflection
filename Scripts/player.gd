extends CharacterBody2D
const SPEED=300.0
const DASH_SPEED=900.0
const DASH_DURATION=0.2
const ATTACK_DURATION=0.15

enum State{NORMAL,DASHING,ATTACKING}
var current_state=State.NORMAL
var dash_direction=Vector2.ZERO

@onready var animated_sprite=$AnimtedSprite2D
@onready var hitbox=$WeaponHitbox
@onready var hitbox_shape=$WeaponHitbox/CollisionShape2D

@warning_ignore("unused_parameter")
func _physics_process(delta):
	match current_state:
		State.NORMAL:
			handle_normal_movement()
		State.DASHING:
			handle_dash_movement()
		State.ATTACKING:
			velocity=Vector2.ZERO
	move_and_slide()
	
func handle_normal_movement():
	var direction=Input.get_vector("move_left","move_right","move_up","move_down")
	velocity=direction*SPEED
	
	if direction!=Vector2.ZERO:
		animated_sprite.play("run")
		if direction.x !=0:
			var facing_left=direction.x<0
			animated_sprite.flip_h=facing_left
			hitbox.scale.x=-1.0 if facing_left else 1.0
	else:
		animated_sprite.play("idle")
	if Input.is_action_just_pressed("dash") and direction !=Vector2.ZERO:
		start_dash(direction)
	elif Input.is_action_just_pressed("attack"):
		start_attack()
		
func start_dash(direction:Vector2):
	current_state=State.DASHING
	dash_direction=direction
	await get_tree().create_timer(DASH_DURATION).timeout
	
	current_state=State.NORMAL
	
func handle_dash_movement():
	velocity=dash_direction*DASH_SPEED
	
func start_attack():
	current_state=State.ATTACKING
	animated_sprite.play("attack")
	hitbox_shape.set_deferred("disabled",false)
	
	await get_tree().create_timer(ATTACK_DURATION).timeout
	
	hitbox_shape.set_deferred("disabled",true)
	current_state=State.NORMAL
