extends CharacterBody2D

const SPEED = 120.0
var health=3
var player_node=null
@onready var animated_sprite=$AnimatedSprite2D

func _ready():
	animated_sprite.play("idle")
	player_node=get_tree().get_first_node_in_group("Player")
	
@warning_ignore("unused_parameter")
func _physics_process(delta):
	if player_node:
		var direction=global_position.direction_to(player_node.global_position)
		velocity=direction*SPEED
		
		animated_sprite.flip_h=direction.x<0
		
		if velocity!=Vector2.ZERO and animated_sprite.animation!="run":
			animated_sprite.play("run")
		move_and_slide()
func _on_hurt_box_area_entered(area: Area2D):
	if area.name=="WeaponHitbox":
		health-=1
		if health<=0:
			queue_free()
