extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	placeRandomly()
	transform.origin.z = Global.farmer.transform.origin.z + randf_range(-10.0, 30.0)

func placeRandomly():
	$grass_1.hide()
	$grass_2.hide()
	$grass_3.hide()
	$grass_4.hide()
	transform.origin = Vector3(randf_range(-6.0, 6.0), 0.3, Global.farmer.transform.origin.z + randf_range(10.0, 30.0))
	var random_choice = randi_range(1, 4)
	match (random_choice):
		1: $grass_1.show()
		2: $grass_2.show()
		3: $grass_3.show()
		4: $grass_4.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Global.farmer.transform.origin.z - transform.origin.z > 20):
		placeRandomly()
