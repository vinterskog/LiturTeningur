extends Spatial

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func is_emitting():
	return $Particles.emitting
	
func set_color(c):
	$Particles.material_override = $Particles.material_override.duplicate()
	$Particles.material_override.albedo_color = c

	
func go():
	$Particles.emitting = true
