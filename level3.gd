extends Node3D

@onready var camera =  $fork_lift/horizontal_pivot/vertical_pivot/Camera3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func explode():
	var death_cam =  Camera3D.new()
	add_child(death_cam)
	death_cam.global_position = camera.global_position
	death_cam.global_rotation = camera.global_rotation
	death_cam.make_current()
	camera.queue_free()
	var blow_up = Vector3(randf_range(-3000,3000),randf_range(-3000,3000),randf_range(-3000,3000))
	$fork_lift.apply_central_impulse(blow_up)
	


func _on_timer_timeout():
	explode()
	
#func _on_delivery_area_body_entered(body):
#	if body == $box:
#		get_tree().change_scene_to_file("res://level_2.tscn")
