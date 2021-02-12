extends KinematicBody


const SPEED : float = 7.5
const MIN_BLEND_SPEED : float = 0.125
const BLEND_TO_RUN : float = 0.075
const BLEND_TO_IDLE : float = 0.1

var _motion : Vector3 = Vector3()
var _movement_state : float = 0 #idle is 0, run is 1


func _physics_process(delta):
	_move()
	_animate()
	
	
func _move():
	var x = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	var z = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	_motion = Vector3(x, 0, z)
	
	if not _motion == Vector3(0, 0, 0):
		face_forward(x,z)
	
	move_and_slide(_motion * SPEED, Vector3.UP)
	
	
func face_forward(x, z):
	rotation.y = atan2(x,z)
	
	
func _animate():
	if (_motion * SPEED).length() > MIN_BLEND_SPEED:
		_movement_state += BLEND_TO_RUN
	else:
		_movement_state -= BLEND_TO_IDLE
		
	_movement_state = clamp(_movement_state, 0, 1)
	var anim_tree = $Armature/AnimationTree
	anim_tree["parameters/Move/blend_amount"] = _movement_state	