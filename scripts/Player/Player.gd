extends "res://scripts/Actor.gd"


const SPEED : float = 7.5
const MIN_BLEND_SPEED : float = 0.125
const BLEND_TO_RUN : float = 0.075
const BLEND_TO_IDLE : float = 0.1

var _motion : Vector3 = Vector3()
var _movement_state : float = 0 #idle is 0, run is 1
var _mouse_sensitivity : float = 1200

export(NodePath) onready var _camera = get_node(_camera) as Camera
export(NodePath) onready var _camera_pivot = get_node(_camera_pivot) as Position3D
export(NodePath) onready var _armature = get_node(_armature) as Skeleton


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	_move()
	_animate()
	
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation = _h_camera_rotation(-event.relative.x / _mouse_sensitivity)
		_camera.rotation = _v_camera_rotation(-event.relative.y / _mouse_sensitivity)
		
	if Input.is_action_just_pressed("fire"):
		fire()
		
		
func _h_camera_rotation(camera_rotation):
	return rotation + Vector3(0, camera_rotation, 0)
	
	
func _v_camera_rotation(camera_rotation):
	var rot = _camera.rotation + Vector3(camera_rotation, 0, 0)
	rot.x = clamp(rot.x, -89, 89)
	return rot
	
	
func _move():
	var movement_dir = get_2d_movement_dir()
	var direction = Vector3.ZERO
	var camera_x = _camera.global_transform
	
	direction -= camera_x.basis.z.normalized() * movement_dir.x
	direction += camera_x.basis.x.normalized() * movement_dir.y
	direction.y = 0
	
	_motion = direction
	
	move_and_slide(_motion * SPEED, Vector3.UP)
	
	
func get_2d_movement_dir():
	var x = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	var z = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	var movement_direction = Vector2(x, z)
	
	if not movement_direction == Vector2.ZERO:
		face_forward(x,z)
		
	return movement_direction.normalized()
	
	
func face_forward(x, z):
	_armature.rotation.y = atan2(x,z) - PI / 2
	
	
func _animate():
	if (_motion * SPEED).length() > MIN_BLEND_SPEED:
		_movement_state += BLEND_TO_RUN
	else:
		_movement_state -= BLEND_TO_IDLE
		
	_movement_state = clamp(_movement_state, 0, 1)
	var anim_tree = $Armature/AnimationTree
	anim_tree["parameters/Move/blend_amount"] = _movement_state	