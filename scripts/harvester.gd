extends Node3D

const SPEED = 5.6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!Global.farmer.alive): return
	
	transform.origin.z += SPEED * delta
