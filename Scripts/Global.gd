extends Node

var cnt_col = [10, 10, 10, 10]
var cur_col = 1
var score = 0

var goscreen = preload("res://Scenes/GameOver.tscn")

func reset():
	cnt_col = [10, 10, 10, 10]
	cur_col = 1
	score = 0

func game_over(s):
	var gs = goscreen.instance()
	gs.set_explain(s)
	get_tree().current_scene.add_child(gs)
	
func check_inventory():
	var c = 0
	for i in cnt_col:
		c += i
	if c == 0:
		game_over("You ran out of colors...")

var music_player = null
var music_file = null

func play_music(file):
	if file != music_file:
		if music_player != null:
			music_player.stop()
			music_player.queue_free()
		music_player = AudioStreamPlayer.new()
		var music = load(file)
		var music_bus_id = AudioServer.get_bus_count()
		AudioServer.add_bus()
		AudioServer.set_bus_name(music_bus_id,"music")
		AudioServer.set_bus_send(music_bus_id,"Master")
		add_child(music_player)
		music_player.bus = "music"
		music_player.stream = music
		music_player.volume_db = 0
		music_player.play()
		music_file = file
		
func play_sound(file):
	var music_player = AudioStreamPlayer.new()
	var music = load(file)
	music_player.stream = music
	music_player.connect("finished", self, "audio_finished", [music_player])
	music_player.volume_db = -8
	add_child(music_player)
	music_player.play()

func audio_finished(who):
	who.queue_free()