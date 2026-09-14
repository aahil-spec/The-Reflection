extends CharacterBody2D


var history_data=[]
var current_frame=0

@onready var animated_sprite=$AnimtedSprite2D
var playback_timer=Timer.new()

var health=5

func _ready():
	add_child(playback_timer)
	playback_timer.wait_time=0.15
	playback_timer.timeout.connect(_on_playback_timer_timeout)
	
func start_echo(recorded_run:Array):
	history_data=recorded_run
	current_frame=0
	playback_timer.start()
	
func _on_playback_timer_timeout():
	if current_frame<history_data.size():
		var frame=history_data[current_frame]
		global_position=frame["position"]
		animated_sprite.flip_h=frame["facing-left"]
		if frame["state"]==2:
			animated_sprite.play("attack")
		elif frame["state"] ==1 or global_position.distance_to(frame["position"])>5:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
			
		current_frame+=1
	else:
		playback_timer.stop() 
		animated_sprite.play("idle")
		print("Echo playback finished.")
		queue_free()
		
func _on_hurtbox_area_entered(area:Area2D):
	if area.name=="WeaponHitbox":
		health-=1
		
		animated_sprite.modulate=Color(10,10,10,1)
		await get_tree().create_timer(0.1).timeout
		animated_sprite.modulate=Color(1,1,1,0.5)
		
		if health<=0:
			print("Echo Defeated!")
			queue_free()
