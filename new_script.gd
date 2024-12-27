


extends Node3D

@onready var camera =  $fork_lift/horizontal_pivot/vertical_pivot/Camera3D
var win = false
var losed = false
var begin = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$floor_is_lava.object_node = null #TO DO:insert_level_object:



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		lose()
	
	

func explode():
	var death_cam =  Camera3D.new()
	add_child(death_cam)
	death_cam.global_position = camera.global_position
	death_cam.global_rotation = camera.global_rotation
	death_cam.make_current()
	camera.queue_free()
	var blow_up = Vector3(randf_range(-3000,3000),randf_range(-3000,3000),randf_range(-3000,3000))
	$fork_lift.apply_central_impulse(blow_up)
	


func lose():
	if !losed:
		if !win:
			explode()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$hud/death_screen.visible = true
			losed = true
	
func _on_delivery_area_body_entered(body):
	if body == $box:
		$hud/success_scene.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	win = true


func _on_hud_time_up():
	lose()


func _on_floor_is_lava_fail():
	lose()


func _on_hud_next():
	get_tree().change_scene_to_file("null") #TO DO:insert next level path


func _on_hud_quit():
	pass # Replace with function body.


func _on_hud_restart():
	get_tree().reload_current_scene()


func _on_floor_is_lava_body_exited(body):
	if body == null : #TO DO:insert_level_object:
		begin = true


func _on_floor_is_lava_body_entered(body):
	if begin && body == null: #TO DO:insert level object:
		lose()
		


func _on_fork_lift_fall():
	lose()
