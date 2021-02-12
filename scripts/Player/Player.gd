extends KinematicBody


const SPEED : float = 7.5

var _motion : Vector3 = Vector3()


func _physics_process(delta):
	_move()
	
	
func _move():
	var x = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	var z = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	_motion = Vector3(x, 0, z)
	
	if not _motion == Vector3(0, 0, 0):
		face_forward(x,z)
	
	move_and_slide(_motion * SPEED, Vector3.UP)
	
	
func face_forward(x, z):
	rotation.y = atan2(x,z) - PI/2