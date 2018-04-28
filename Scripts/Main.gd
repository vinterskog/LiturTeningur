extends Node

signal update_gui

var quitbox = preload("res://Scenes/Quit.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Global.play_music("res://Sounds/muzak.ogg")

func _input(e):
	if e.is_action_pressed("ui_cancel"):
		add_child(quitbox.instance())
		
	if e is InputEventMouseButton and e.is_pressed():
		if e.button_index == BUTTON_WHEEL_UP:
			Global.cur_col += 1
			if Global.cur_col > 4: 
				Global.cur_col = 1
			emit_signal("update_gui")
		elif e.button_index == BUTTON_WHEEL_DOWN:
			Global.cur_col -= 1
			if Global.cur_col < 1: 
				Global.cur_col = 4
			emit_signal("update_gui")
			
	if e is InputEventKey and e.is_pressed():
		var update = true
		
		if e.scancode == KEY_1:
			Global.cur_col = 1
		elif e.scancode == KEY_2:
			Global.cur_col = 2
		elif e.scancode == KEY_3:
			Global.cur_col = 3
		elif e.scancode == KEY_4:
			Global.cur_col = 4
		else:
			update = false
		
		if update:
			emit_signal("update_gui")
		
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
