extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_explain(s):
	$MarginContainer/CenterContainer/MarginContainer/VBoxContainer2/VBoxContainer/lblExplain.text = s

func _on_btnRetry_pressed():
	call_deferred("change")

func change():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Thinking.tscn")

func _on_btnQuit_pressed():
	get_tree().quit()
