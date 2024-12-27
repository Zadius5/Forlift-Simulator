extends VehicleBody3D

signal fall
var max_rpm = 200 #set max speed
var cam_hor_piv = 0 #track horizontal camera input
var cam_ver_piv = 0 #track vertical camera input
var cam_sen = 0.002 #camera sensitivity
var max_engine_f = 100 #engine force 
var steer = 0.0 #left right turning
var lift_mode = 0.0 # handle lift prongs
var control = true
#get horizontal and vertical pivot
@onready var hor_node = $horizontal_pivot 
@onready var ver_node = $horizontal_pivot/vertical_pivot




func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if control:
		handle_camera()
		handle_movement(delta)
		handle_lift()
		handle_falling()

	
	
#function that control camera
func handle_camera():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		hor_node.rotate_y(cam_hor_piv * cam_sen)
		ver_node.rotate_x(cam_ver_piv * cam_sen)
		ver_node.rotation.x = clamp(ver_node.rotation.x,deg_to_rad(-30),deg_to_rad(50)) #limit camera movement
	if Input.is_action_just_released("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	cam_ver_piv = 0
	cam_hor_piv = 0





#function to control movement
func handle_movement(delta):
	steering = lerp(steering,Input.get_axis("steer_right","steer_left") * 0.2,5 * delta)
	var acc = Input.get_axis("move_backward","move_forward") * max_engine_f
	if acc != 0.0:
		var rpm = $front_left.get_rpm()
		$front_left.engine_force = acc * (1- rpm/max_rpm)
		rpm = $front_right.get_rpm()
		$front_right.engine_force = acc * (1- rpm/max_rpm)
			
#		$back_right.steering = lerp($back_right.steering, steer,0.01) 
#		$back_left.steering = lerp($back_left.steering, steer,0.01) 
	else:
		if $engine_sound.playing:
			$engine_sound.stop()
		if $reverse_sound.playing:
			$reverse_sound.stop()
		$front_left.engine_force = 0
		$front_right.engine_force = 0
	if acc > 0.0 && !$engine_sound.playing:
		$engine_sound.play()
	if acc < 0.0 && !$reverse_sound.playing:
		$reverse_sound.play()
	
#	var acc = Input.get_axis("move_backward","move_forward") * 100
#	if acc != 0.0:
#
#		var rpm = $back_left.get_rpm()
#		$back_left.engine_force = acc  * (1- rpm/max_rpm)
#		rpm = $back_right.get_rpm()
#		$back_right.engine_force = acc  * (1- rpm/max_rpm)
#		rpm = $front_left.get_rpm()
#		$front_left.engine_force = acc  * (1- rpm/max_rpm)
#		rpm = $front_right.get_rpm()
#		$front_right.engine_force = acc  * (1- rpm/max_rpm)
#	else:
#		$front_left.engine_force = 0
#		$front_right.engine_force = 0
#		$back_left.engine_force = 0
#		$back_right.engine_force = 0

func handle_lift():
	lift_mode = Input.get_axis("lift_down","lift_up")
	if $lift1.position.y >= 2 && lift_mode > 0:
		lift_mode = 0
	if $lift1.position.y <= -0.55 && lift_mode < 0:
		lift_mode = 0
	if $lift1.position.y <= -0.55:
		$lift1_hitbox.disabled = true
		$lift2_hitbox.disabled = true
	else:
		$lift1_hitbox.disabled = false
		$lift2_hitbox.disabled = false
	$lift1.translate(Vector3(0,lift_mode*0.01,0))
	$lift1_hitbox.translate(Vector3(0,lift_mode * 0.01,0))
	$lift2.translate(Vector3(0,lift_mode * 0.01,0))
	$lift2_hitbox.translate(Vector3(0,lift_mode* 0.01,0))


#function that dectect mouse movement
func _unhandled_input(event:InputEvent):
	if event is InputEventMouseMotion:
		cam_hor_piv = -event.relative.x 
		cam_ver_piv = event.relative.y

func handle_falling():
	if global_rotation.x >= deg_to_rad(90) ||  global_rotation.z >= deg_to_rad(90) || global_rotation.x <= deg_to_rad(-90)  || global_rotation.z <= deg_to_rad(-90):
		emit_signal("fall")



