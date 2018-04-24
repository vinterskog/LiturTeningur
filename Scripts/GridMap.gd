extends GridMap

signal update_gui

var size = 15

var perlin = preload("res://Scripts/perlin.gd").PerlinNoise.new()
var particles = preload("res://Scenes/Particles.tscn")
var thinking_scene = preload("res://Scenes/Thinking.tscn")
var thinking

var to_destroy = {}
var particle_buffer = []
var thr

func _ready():
	generate()


func generate():
	randomize()
	var _seed = randf() * 254
	var i = 0
	
	var timer = OS.get_ticks_msec()
	
	for x in range (-size, size+1):	
		for y in range (-size, size+1):
			for z in range (-size, size+1):
				if (x in range(-1, 2)) and (y in range(-1, 2)) and (z in range(-1, 2)):
					# make room for player
					set_cell_item(x, y, z, -1)
				else:
					var p = perlin.perlin(_seed+float(x)/size, _seed+float(y)/size, _seed+float(z)/size, 4, 3)
					if p < 0.5:
						set_cell_item(x, y, z, -1)
					elif p < 0.6:
						set_cell_item(x, y, z, 0)
					else:
						set_cell_item(x, y, z, randi()%4+1)
	
	timer = OS.get_ticks_msec() - timer
	print ("Generating the world took ", timer, " ms.")
	
	get_tree().paused = false
	if thinking != null:
		thinking.visible = false
		thinking.queue_free()

var time = 0.0
var dtime = 0.0
var last_col = 0
var col_des_cnt = 0

func _process(delta):
	time += delta
	dtime += delta
	
	if int(time) % 10 == 0:
		var temp = []
		
		for p in particle_buffer:
			if p.is_emitting():
				temp.append(p)
			else:
				p.queue_free()
		
		particle_buffer = temp
	
	if dtime > 0.2:
		dtime = 0.0
		if to_destroy.size() > 0:
			var t = to_destroy.keys()[0]
			destroy(t, to_destroy[t])
			to_destroy.erase(t)
		else:
			last_col = 0
			col_des_cnt = 0
			Global.check_inventory()


func _on_Player_tile_selected(vec):
	var v = world_to_map(vec) 
	
	if get_cell_item(v.x, v.y, v.z) > 0:
		Global.play_sound("res://Sounds/piou.wav")
		return
	
	var c = Global.cur_col
	
	if Global.cnt_col[c-1] > 0:
		Global.cnt_col[c-1] = max(0, Global.cnt_col[c-1] - 1)
		emit_signal("update_gui")
		set_cell_item(v.x, v.y, v.z, c)
		Global.play_sound("res://Sounds/paint.wav")
		call_deferred("check_neighbours", v, c)
	else:
		Global.play_sound("res://Sounds/plock.wav")

func check_neighbours(v, c):
	var tiles = []
	check(v, c, tiles)
	if tiles.size() > 2:
		for tile in tiles:
			to_destroy[tile] = c
			

func destroy(pos, col):
	var c = get_cell_item(pos.x, pos.y, pos.z)
	
	if not c in range(1, 5): 
		return
		
	var score_plus = 10
	
	if c == last_col:
		col_des_cnt += 1
		if col_des_cnt > 6:
			score_plus *= 25
		elif col_des_cnt > 4:
			score_plus *= 10
		elif col_des_cnt > 3:
			score_plus *= 5
	else:
		last_col = c
		col_des_cnt = 1
		
	Global.score += score_plus	
	Global.cnt_col[c-1] = min(99, Global.cnt_col[c-1] + 1)
	var p = particles.instance()
	p.translation = map_to_world(pos.x, pos.y, pos.z)
	p.set_color(get_particle_color(c))
	particle_buffer.append(p)
	add_child(p)
	p.go()
	set_cell_item(pos.x, pos.y, pos.z, -1)
	emit_signal("update_gui")
	Global.play_sound("res://Sounds/destroy.wav")

func get_particle_color(c):
	match c:
		1: return Color("ff0000")
		2: return Color("00ff0f")
		3: return Color("0039ff")
		4: return Color("f1ff00")
		_: return Color(1,0,0)
		

func check(pos, tile, ret):
	var n = get_neighbours(pos)
	for t in n:
		if not ret.has(t):
			var ti = get_cell_item(t.x, t.y, t.z)
			if ti == tile:
				ret.append(t)
				check(t, tile, ret)
	return ret
			
func get_neighbours(pos):
	var x = pos.x
	var y = pos.y
	var z = pos.z
	
	var x1 = Vector3(x-1, y, z)
	var x2 = Vector3(x+1, y, z)
	
	var y1 = Vector3(x, y-1, z)
	var y2 = Vector3(x, y+1, z)
	
	var z1 = Vector3(x, y, z+1)
	var z2 = Vector3(x, y, z-1)
	
	return [x1, x2, y1, y2, z1, z2]

var scanned_tile = null
var scanned_color = 0

func reset_scanned_tile():
	if scanned_tile != null:
		set_cell_item(scanned_tile.x, scanned_tile.y, scanned_tile.z, scanned_color)
		scanned_tile = null
		
func _on_Player_tile_scan(vec):
	var v = world_to_map(vec) 
	
	if scanned_tile == v:
		return
	
	reset_scanned_tile()
	
	var c = get_cell_item(v.x, v.y, v.z)
	
	if c < 1:
		return
	
	set_cell_item(v.x, v.y, v.z, c+4)
	scanned_tile = v
	scanned_color = c
	


func _on_Player_stop_scan():
	reset_scanned_tile()
	
