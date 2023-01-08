extends CharacterBody3D


const MIN_SPEED = 0.2
const MAX_SPEED = 6
const JUMP_VELOCITY = 6

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

var current_speed:float = 0
var lastPosition:float = 0
var deltaZ:float = 0
var timeElapsed:float = 0
var alive:bool = true
var home:bool = false
var panic:bool = false
var jumpAnimation:String
var footstepsVolume:float
var impedeTime:float = 0

func _ready():
	$Footsteps.play()
	reset()

func reset():
	current_speed = 0
	impedeTime = 0
	alive = true
	home = false
	velocity = Vector3.ZERO

func _physics_process(delta):
	if (!alive || !Global.playing):
		stop()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and !home:
		$JumpSound.play()
		velocity.y = JUMP_VELOCITY

	current_speed += (MAX_SPEED - current_speed) * 0.05

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction && !home:
		velocity.x = direction.x * MAX_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	velocity.z = current_speed if !home else 0
	
	move_and_slide()
	
	if (transform.origin.x < -2.0): transform.origin.x = -2.0
	elif (transform.origin.x > 2.0): transform.origin.x = 2.0
	
	deltaZ = abs(transform.origin.z - lastPosition);
	if (deltaZ < 0.01 && current_speed > MIN_SPEED):
		current_speed *= 0.9
	lastPosition = transform.origin.z
	
	rotation.y = lerp(rotation.y, velocity.x * PI/4 * 0.1, 0.1)
	
	if (impedeTime > 0): impedeTime -= delta
	
func _process(delta):
	if (Global.playing): timeElapsed += delta
	$farmer/AnimationPlayer.play(getAnimation())
	$farmer/AnimationPlayer.playback_speed = current_speed / MAX_SPEED * 1.5
	
	if (is_on_floor()):
		if (transform.origin.x < 0): jumpAnimation = "jump-left"
		else: jumpAnimation = "jump-right"
	
	if (is_on_floor() && Global.playing):
		footstepsVolume = -20
	else:
		footstepsVolume = -50
		
	if (current_speed < MAX_SPEED * 0.4 || !alive || home):
		footstepsVolume = -50
		
	$FootstepsTimer.wait_time = 0.4 - (current_speed/MAX_SPEED) * 0.2
	$Footsteps.volume_db = lerp($Footsteps.volume_db, footstepsVolume, 0.1)

func stop():
	$farmer/AnimationPlayer.stop()

func impede():
	current_speed *= 0.994
	impedeTime = 0.15

func getAnimation() -> String:
	if (home): return "idle"
	elif (!is_on_floor() && timeElapsed > 0.5): return jumpAnimation
	elif (deltaZ > 0.01 || abs(velocity.x) > 0.1): 
		if (impedeTime > 0): return "run-corn"
		elif (panic): return "run-panic"
		else: return "run"
	else: return "idle"


func _on_footsteps_timer_timeout():
	$Footsteps.play()
