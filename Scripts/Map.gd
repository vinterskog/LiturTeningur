extends Spatial

var cube = preload("res://Cube.tscn")
var size = 100

func _ready():
	for x in range(-size, size+1):
		for y in range(-size, size+1):
			for z in range(-size, size+1):
				if x == -size or x == size or y == -size or y == size:
					var c = cube.instance()
					c.translation = Vector3(x, y, z)
					add_child(c)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
