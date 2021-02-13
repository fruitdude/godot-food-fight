extends KinematicBody


var projectile

const PROJECTILE_SPEED = 50


func fire():
	projectile = load("res://scenes/ProjectileTemplate.tscn").instance()
	add_child(projectile)
	projectile.set_as_toplevel(true)
	projectile.global_transform = $Position3D.global_transform
	var actor_forward = global_transform.basis[2].normalized()
	projectile.linear_velocity = actor_forward * PROJECTILE_SPEED