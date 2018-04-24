extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _on_btnRetry_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	queue_free()

func _on_btnQuit_pressed():
	get_tree().quit()