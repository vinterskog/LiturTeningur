extends Node

onready var nums = [$CenterContainer/HBoxContainer/cnt_red/num_red, 
					$CenterContainer/HBoxContainer/cnt_green/num_green, 
					$CenterContainer/HBoxContainer/cnt_blue/num_blue, 
					$CenterContainer/HBoxContainer/cnt_yellow/num_yellow]
					
onready var btns = [$CenterContainer/HBoxContainer/cnt_red/btn_red, 
					$CenterContainer/HBoxContainer/cnt_green/btn_green, 
					$CenterContainer/HBoxContainer/cnt_blue/btn_blue, 
					$CenterContainer/HBoxContainer/cnt_yellow/btn_yellow]

onready var icons = [preload("res://sphere_red.png"),
					 preload("res://sphere_green.png"),
					 preload("res://sphere_blue.png"),
					 preload("res://sphere_yellow.png")
]

onready var icons_glow = [preload("res://sphere_red_glow.png"),
						  preload("res://sphere_red_glow.png"),
						  preload("res://sphere_red_glow.png"),
						  preload("res://sphere_red_glow.png")  
]

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
			#btns[i].texture_normal = icons_glow[i]
		else:
			nums[i].add_color_override("font_color", selected)
			#btns[i].texture_normal = icons[i]
			
		nums[i].text = str(Global.cnt_col[i])

