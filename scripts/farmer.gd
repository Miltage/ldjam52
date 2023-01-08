extends CharacterBody3D


const MIN_SPEED = 0.2
const MAX_SPEED = 6
const JUMP_VELOCITY = 6

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

var current_speed:float = 0
var lastPosition:float = 0
var deltaZ:float = 0
var alive:bool = true

func _ready():
	current_speed = 0

func _physics_process(delta):
	if (!alive):
		stop()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	current_speed += (MAX_SPEED - current_speed) * 0.05

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * MAX_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	velocity.z = current_speed

	move_and_slide()
	
	if (transform.origin.x < -2.0): transform.origin.x = -2.0
	elif (transform.origin.x > 2.0): transform.origin.x = 2.0
	
	deltaZ = abs(transform.origin.z - lastPosition);
	if (deltaZ < 0.01 && current_speed > MIN_SPEED):
		current_speed *= 0.9
	lastPosition = transform.origin.z
	
	rotation.y = lerp(rotation.y, velocity.x * PI/4 * 0.1, 0.1)
	
func _process(delta):
	$farmer/AnimationPlayer.play("run" if deltaZ > 0.01 else "idle")
	$farmer/AnimationPlayer.playback_speed = current_speed / MAX_SPEED * 1.25

func stop():
	$farmer/AnimationPlayer.stop()
