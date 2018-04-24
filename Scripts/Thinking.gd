extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	Global.reset()

var t = 0

func _process(delta):
	t += delta
	if t > 1:
		call_deferred("change")

func change():
	get_tree().change_scene("res://Scenes/Main.tscn")
	