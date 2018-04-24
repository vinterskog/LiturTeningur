extends Control

func _ready():
	Global.play_music("res://Sounds/intro.ogg")

func _input(event):
	if event.is_pressed():
		get_tree().change_scene("res://Scenes/Thinking.tscn")

