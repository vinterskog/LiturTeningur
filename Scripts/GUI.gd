extends Node

onready var nums = [$CenterContainer/HBoxContainer/cnt_red/num_red, 
					$CenterContainer/HBoxContainer/cnt_green/num_green, 
					$CenterContainer/HBoxContainer/cnt_blue/num_blue, 
					$CenterContainer/HBoxContainer/cnt_yellow/num_yellow]

const selected = Color("00d5ff")
const white = Color(1,1,1)

func _ready():
	_on_GridMap_update_gui()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_GridMap_update_gui():
	update_gui()

func _on_Root_update_gui():
	update_gui()

func update_gui():
	$MarginContainer/lblScore.text = "SCORE: " + str(Global.score)
	for i in range (0, 4):
		if i == Global.cur_col - 1:
			nums[i].add_color_override("font_color", white)
		else:
			nums[i].add_color_override("font_color", selected)
			
		nums[i].text = str(Global.cnt_col[i])

