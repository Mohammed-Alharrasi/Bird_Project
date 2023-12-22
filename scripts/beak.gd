extends Node3D

var grabbed_object: RigidBody3D = null
var previous_transform: Transform3D


@onready var grabbables = get_tree().get_nodes_in_group("Seeds")
@onready var collision_area = $Area3D as Area3D
@onready var globals = get_node("/root/Globals")
@onready var overlap_check_area = %OverlapCheckArea


var min_position = Vector3(0, 0.5, 0)  
var max_position = Vector3(570, 70, 253)
#var last_collision = 0
#var add_check = false
#var min_position = Vector3(-3, 0.5, -3) 
#var max_position = Vector3(3, 1, 3)
#var seed_counter: Label3D



# Called when the node enters the scene tree for the first time.
func _ready():
#	seed_counter = %SeedCount
	randomize()
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	print("before: " , %XRCamera3D.global_rotation.x)
#	%XRCamera3D.global_rotation.x = %XRCamera3D.global_rotation.x *10
#	print("after: " , %XRCamera3D.global_rotation.x)
#	last_collision += _delta
	for grabbable in grabbables:
		# Cast the grabbable object to a RigidBody3D
		var grabbable_body = grabbable as RigidBody3D
		# Check to see if the grabber and grabbable collision shapes are intersecting
		if collision_area.overlaps_body(grabbable_body):
			grabbable_body.collision_layer &= ~1
#			grabbable_body.hide()
			
			var new_position = await _generate_valid_random_position()
			grabbable_body.global_transform.origin = new_position
#			grabbable_body.show()

			globals.active_grabbers.push_back(self)
			print("Array length: " , globals.active_grabbers.size())
			

func _handle_collision(object):
	pass
#	var new_position = await _generate_valid_random_position()
#	object.global_transform.origin = new_position
#	object.collision_area.set_disabled(true)
#	object.collision_layer &= ~1
#	globals.active_grabbers.push_back(self)
#	print("Array length: " , globals.active_grabbers.size())
#	await get_tree().create_timer(0.5).timeout
#	object.collision_layer |= 1
#	object.collision_area.set_disabled(false)
	
func _valid_position(new_position):
	overlap_check_area.global_transform.origin = new_position
	await get_tree().create_timer(1.0).timeout
	return overlap_check_area.get_overlapping_bodies().size() == 0
	

func _generate_valid_random_position():
	var valid_position_found = false
	var new_position = Vector3()
	while not valid_position_found:
		new_position = Vector3(
			randf_range(min_position.x, max_position.x),
			randf_range(min_position.y, max_position.y),
			randf_range(min_position.z, max_position.z)
		)
		valid_position_found = await _valid_position(new_position)
	return new_position
	

func _on_button_pressed(button_name: String) -> void:
#	print("button pressed: " + button_name)
	
	# Stop if we have not clicked the grip button or we already are grabbing an object
	if button_name != "grip_click" || self.grabbed_object != null:
		return
	
	var grabbables = get_tree().get_nodes_in_group("Seeds")
	var collision_area = $Area3D as Area3D

	# Iterate through all grabbable objects and check if the collision area overlaps with them
	for grabbable in grabbables:

		# Cast the grabbable object to a RigidBody3D
		var grabbable_body = grabbable as RigidBody3D

		# Check to see if the grabber and grabbable collision shapes are intersecting
#		
			
		if collision_area.overlaps_body(grabbable_body):
#			print("Beak Overlapping: " , grabbable_body )
#			print("Seed Z position: " , grabbable_body.position.z )
#			print("Beak Z position: " , collision_area.position.z )
#			print("Seed Y position: " , grabbable_body.position.y )
#			print("Beak Y position: " , collision_area.position.y )
#			print("Seed X position: " , grabbable_body.position.x )
#			print("Beak X position: " , collision_area.position.x )
			
			# If the object is already grabbed by another grabber, release it first
			var globals = get_node("/root/Globals")
#			print("Beak : test 1")
#			for grabber in globals.active_grabbers:
#				print("Beak : test 2")
#				if grabber.grabbed_object == grabbable_body:
#					print("Beak : test 3")
#					grabber.grabbed_object = null
#					globals.active_grabbers.remove_at(globals.active_grabbers.find(self))
#					break

			# Freeze the object physics and then grab it
			grabbable_body.hide()
			


#			print("Beak : test 4")
#			grabbable_body.freeze = true
#			print("Beak : test 5")
#			self.grabbed_object = grabbable_body
#			print("Beak : test 6")
			globals.active_grabbers.push_back(self)
			print("Array length: " , globals.active_grabbers.size())
#			var seedValue = "Number of Seeds Collected: "+ str(globals.active_grabbers.size()) 
#			seed_counter.set_text(seedValue )
#			print("Beak : test 7")
	
func _on_button_released(button_name: String) -> void:
#	print("button released: " + button_name)
	
	# Stop if we have not clicked the grip button or we have no current grabbed object
	if button_name != "grip_click" || self.grabbed_object == null:
		return

#	# Release the grabbed object and unfreeze it
#	self.grabbed_object.show()
#	self.grabbed_object.freeze = false
#	self.grabbed_object.linear_velocity = Vector3(0, -0.1, 0)
#	self.grabbed_object.angular_velocity = Vector3.ZERO
#	self.grabbed_object = null
#
#	# Remove this grabber from the array of active grabbers
#	var globals = get_node("/root/Globals")
#	globals.active_grabbers.remove_at(globals.active_grabbers.find(self))

#func collect(collectable):
#	collected.emit(collectable)
