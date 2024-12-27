extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://instruction.tscn")


func _on_credit_pressed():
	$credit_layer.visible = true
	$title.visible = false
	$Start.visible = false
	$Credit.visible = false
	$exit.visible = false
func _on_button_pressed():
	$credit_layer.visible = false
	$title.visible = true
	$Start.visible = true
	$Credit.visible = true
	$exit.visible = true


func _on_exit_pressed():
	get_tree().quit()
