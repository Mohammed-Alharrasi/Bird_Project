# This code was written by Mohammed, but used an AI (Chatgpt) to debug it and improve it. 
extends Node3D

var grabbed_object: RigidBody3D = null
var previous_transform: Transform3D


@onready var grabbables = get_tree().get_nodes_in_group("Seeds")
@onready var collision_area = $Area3D as Area3D
@onready var globals = get_node("/root/Globals")
@onready var overlap_check_area = %OverlapCheckArea


var min_position = Vector3(0, 0.5, 0)  
var max_position = Vector3(570, 70, 253)

var worm_grabbed = false
var grabbed_objects = []


# Called when the node enters the scene tree for the first time.
func _ready():
#	seed_counter = %SeedCount
	randomize()
#	pass


func _process(_delta):
	# Always handle worm movement
	var relative_transform = self.global_transform * previous_transform.affine_inverse()
	for obj in grabbed_objects:
		obj.global_transform = relative_transform * obj.global_transform
	previous_transform = self.global_transform

	# Check each grabbable to see if it's a seed
	if not worm_grabbed:  # Only process seeds if no worm is grabbed
		for grabbable in grabbables:
			var grabbable_body = grabbable as RigidBody3D
			if "Seeds" in grabbable.get_groups() and collision_area.overlaps_body(grabbable_body):
				_handle_seed_interaction(grabbable_body)
func _on_button_pressed(button_name: String) -> void:
	if button_name != "grip_click":
		return

	# Check each grabbable to see if it's a worm
	var grabble_worms = get_tree().get_nodes_in_group("Worms")
	for grabble_worm in grabble_worms:
		var grabbable_body = grabble_worm as RigidBody3D
		if "Worms" in grabble_worm.get_groups() and collision_area.overlaps_body(grabbable_body):
			_handle_worm_interaction(grabbable_body)

	
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



func _on_button_released(button_name: String) -> void:
	if button_name != "grip_click":
		return

	for obj in grabbed_objects:
		obj.freeze = false
		obj.linear_velocity = Vector3(0, -0.1, 0)
		obj.angular_velocity = Vector3.ZERO
		worm_grabbed = false

	grabbed_objects.clear()  # Clear the list of grabbed objects
	var globals = get_node("/root/Globals")
	globals.active_worms.remove_at(globals.active_twigs.find(self))
	
	
# New function to handle seed interaction
func _handle_seed_interaction(grabbable_body: RigidBody3D) -> void:
	grabbable_body.collision_layer &= ~1
	grabbable_body.hide()

	var new_position = await _generate_valid_random_position()
	grabbable_body.global_transform.origin = new_position
	grabbable_body.collision_layer |= 1
	grabbable_body.show()

	globals.active_seeds.push_back(self)
	print("Array length: ", globals.active_seeds.size())

# New function to handle worm interaction
func _handle_worm_interaction(grabbable_body: RigidBody3D) -> void:
	if grabbed_objects.size() >= 3:
		return  # Maximum of 3 worms

	worm_grabbed = true
	grabbed_objects.append(grabbable_body)
	globals.active_worms.push_back(self)

	if grabbed_objects.size() >= 3:
		return  # Stop adding more if three are already grabbed
