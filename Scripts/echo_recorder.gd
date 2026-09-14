extends Node

var run_history=[]
var echo_scene=preload("res://Scenes/echo.tscn")

@onready var player=$".."
@onready var timer=$RecordTimer

func _ready():
	timer.timeout.connect(_on_record_timer_timeout)
	
@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		summon_echo()
func _on_record_timer_timeout():
	var frame_data={
		"position":player.global_position,
		"facing-left":player.get_node("AnimtedSprite2D").flip_h,
		"state":player.current_state
	}
	run_history.append(frame_data)
	print("Recording... Frames saved: ", run_history.size())
	
func summon_echo():
	timer.stop()
	var echo_instance=echo_scene.instantiate()
	player.get_parent().add_child(echo_instance)
	echo_instance.start_echo(run_history.duplicate())
