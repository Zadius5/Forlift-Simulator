extends Control

signal time_up
signal restart
signal next
signal quit
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = $Timer.get_time_left()
	var seconds = fmod(time,60)
	var minutes = fmod(time, 60 *60)/60
	$timer.text = "TIME REMAINING: " + "%02d : %02d" % [minutes,seconds]
	





func _on_timer_timeout():
	emit_signal("time_up")


func _on_death_screen_quit():
	emit_signal("quit")
	

func _on_death_screen_restart():
	emit_signal("restart")




func _on_success_scene_next_level():
	emit_signal("next")
