extends KinematicBody


var projectile
var food_types = {}
var can_fire = true

const PROJECTILE_SPEED = 50


func _ready():
	food_types = file_grabber.get_files("res://scenes/Food/")
	randomize()


func try_to_fire():
	if can_fire:
		fire()
		can_fire = false
		$Timer.start()


func fire():
	var random_food = food_types[randi() % food_types.size()]
	projectile = load(random_food).instance()
	add_child(projectile)
	projectile.set_as_toplevel(true)
	projectile.global_transform = $Position3D.global_transform
	var actor_forward = global_transform.basis[2].normalized()
	projectile.linear_velocity = actor_forward * PROJECTILE_SPEED


func _on_Timer_timeout():
	can_fire = true
