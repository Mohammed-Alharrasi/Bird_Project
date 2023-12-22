extends Node3D

var grabbed_object: RigidBody3D = null
var previous_transform: Transform3D
var grabbed_objects = []



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(_delta):
	var relative_transform = self.global_transform * self.previous_transform.affine_inverse()
	for obj in grabbed_objects:
		obj.global_transform = relative_transform * obj.global_transform
	self.previous_transform = self.global_transform

func _on_button_pressed(button_name: String) -> void:
	if button_name != "grip_click":
		return

	if grabbed_objects.size() >= 3:  # Maximum of 3 twigs
		return

	var grabbables = get_tree().get_nodes_in_group("Twigs")
	var collision_area = $Area3D as Area3D

	for grabbable in grabbables:
		var grabbable_body = grabbable as RigidBody3D
		if collision_area.overlaps_body(grabbable_body):
			grabbable_body.freeze = true
			grabbed_objects.append(grabbable_body)
			var globals = get_node("/root/Globals")
			globals.active_twigs.push_back(self)
			if grabbed_objects.size() >= 3:
				break  # Stop adding more if three are already grabbed

func _on_button_released(button_name: String) -> void:
	if button_name != "grip_click":
		return

	for obj in grabbed_objects:
		obj.freeze = false
		obj.linear_velocity = Vector3(0, -0.1, 0)
		obj.angular_velocity = Vector3.ZERO

	grabbed_objects.clear()  # Clear the list of grabbed objects
	var globals = get_node("/root/Globals")
	globals.active_twigs.remove_at(globals.active_twigs.find(self))

