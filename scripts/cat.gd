extends CharacterBody3D

const SPEED = 1.5

@onready var nav: NavigationAgent3D = $NavigationAgent3D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var bird = %playerbird

#


func _physics_process(delta):

	nav.target_position = bird.global_transform.origin
	var bird_position_flat = bird.global_transform.origin
#	bird_position_flat.y = global_transform.origin.y # Keep the cat at the same y-level
	# Get the next position on the path.
	var next_position = nav.get_next_path_position()
	var direction = (next_position - global_position).normalized()

	if direction != Vector3.ZERO:
		velocity = velocity.lerp(direction * SPEED, delta)
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
		look_at(bird_position_flat, Vector3.UP)
		rotate_y(PI)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * SPEED)
		velocity.z = lerp(velocity.z, 0.0, delta * SPEED)
	
	var area1 = $Area3D as Area3D
	var area2 = %playerbird/Area3D as Area3D
	var overlapping_areas = area1.get_overlapping_areas()
	if area2 in overlapping_areas:
		print("Collision detected with bird, resetting position.")
		%CharacterBody3D.position = Vector3(-53,12,0)
#	var area = %playerbird/Area3D as Area3D  
#	var cat_body = $RigidBody3D as RigidBody3D# Adjust the path to your Area3D node
#	if area.overlaps_body(cat_body):
#		print("Collision detected with bird, resetting position.")
#		%XROrigin3D.global_transform.origin = Vector3(-53,12,0)
	
#	nav.set_path_height_offset(0.0)
#	print(nav.get_path_height_offset ( ))
	move_and_slide()
	

#########################################################


########################################################
#func _physics_process(delta):
#	# Handle gravity only when not on the floor.
#	if is_on_floor():
#		velocity.y = 0
#	else:
#		velocity.y -= gravity * delta
#
#	# Calculate direction towards the bird, ignoring the y-axis difference.
#	var bird_position_flat = bird.global_transform.origin
#	bird_position_flat.y = global_transform.origin.y # Keep the cat at the same y-level
#	var direction = (bird_position_flat - global_transform.origin).normalized()
#
#	if direction != Vector3.ZERO:
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
#		look_at(bird_position_flat, Vector3.UP)
#		rotate_y(PI)
#	else:
#		velocity.x = lerp(velocity.x, 0, delta * SPEED)
#		velocity.z = lerp(velocity.z, 0, delta * SPEED)
#
#	move_and_slide()
#
