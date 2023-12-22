extends Node3D

#@export var max_speed:= 2.5
@export var dead_zone := 0.2
@export var steering := "view-directed"
@export var ground_steering := "view-directed"
@export var turn_mode := "smooth"
@export var velocity := Vector3(0,0,0)
@export var acc_scale := 0.2
@export var max_speed := 5
@export var friction := 1
@export var gravity := 50

@export var smooth_turn_speed:= 45.0
@export var smooth_turn_dead_zone := 0.2

var input_vector:= Vector2.ZERO
var back_to_dead = true
var time_elapsed = 0
var previous_left_height = 2.7
var previous_right_height = 2.7
var print_timer = 0
var uninitialized_controllers = true

# Called when the node enters the scene tree for the first time.
func _ready():
#	previous_flap_height = $LeftController.position.y + $RightController.position.y
	pass

func view_movement(mag_dvelocity):
	var dvelocity = mag_dvelocity.rotated(Vector3.UP, $XRCamera3D.global_rotation.y)
	self.get_parent().velocity += dvelocity
	var point_direction = mag_dvelocity.normalized() * 0.3
#	$TalonPivot.rotation.z = $XRCamera3D.rotation.y + $XRCamera3D/Pivot/Arrow.rotation.y
	return point_direction
	
func hand_movement(mag_dvelocity):
	var dvelocity = mag_dvelocity.rotated(Vector3.UP, $RightController.global_rotation.y)
	self.get_parent().velocity += dvelocity
	var point_direction = mag_dvelocity.rotated(Vector3.UP, -$XRCamera3D.rotation.y + $RightController.rotation.y).normalized() * 0.3
#	$TalonPivot.rotation.z = $XRCamera3D.rotation.y + $XRCamera3D/Pivot/Arrow.rotation.y
	return point_direction

func flying_movement(delta):
	var left_to_camera = Vector3($XRCamera3D.global_position - $LeftController.global_position)
	var right_to_camera = Vector3($XRCamera3D.global_position - $RightController.global_position)
	var move_dir = left_to_camera + right_to_camera
	move_dir.y = 0
#	direction = direction.rotated(Vector3(1,0,0), 15)
#	var slope_normal = Vector3.UP.rotated((Vector3(1,0,0), 15)
#	var projected_direction = direction - (direction.dot(slope_normal) - )
#	var camera_vector = Vector3(0, 0, -1).rotated(Vector3.UP, $XRCamera3D.global_rotation.y)#.rotated(Vector3(1,0,0), 15)
#	move_dir += camera_vector * 0.6
#	camera_vector.rotated(Vector3(0,1,0), $XRCamera3D.global_rotation.y)
#	camera_vector.rotated(Vector3(1,0,0), $XRCamera3D.global_rotation.x)
#	camera_vector.rotated(Vector3(0,0,1), $XRCamera3D.global_rotation.z)
#	camera_vector.rotated(Vector3(0,1,0), -90)
#	camera_vector.y = 0
#	the player should not move backwards when flying, but I will implement slowing down
#	if (direction.dot(camera_vector) > 0):
#	var dvelocity = move_dir * acc_scale * delta
#	velocity += dvelocity
	self.get_parent().velocity += move_dir * max_speed * 5
	var point_direction = self.get_parent().velocity.rotated(Vector3.UP, -$XRCamera3D.global_rotation.y).normalized() * 0.3
#			$XRCamera3D/Pivot/pointdirection.position = movement_vector.rotated(Vector3.UP, $XRCamera3D.global_rotation.y).normalized() * 0.3
#	$XRCamera3D/Pivot/pointdirection.position = point_direction
#	$XRCamera3D/Pivot/Arrow.look_at($XRCamera3D/Pivot/pointdirection.global_position)
#	$TalonPivot.rotation.z = $XRCamera3D/Pivot/Arrow.rotation.y + $XRCamera3D.rotation.y
	return point_direction

func torso_movement(delta):
	var left_to_right = Vector3($RightController.global_position - $LeftController.global_position)
	left_to_right.y = 0
	var move_dir = Vector3.UP.cross(left_to_right)
	self.get_parent().velocity += move_dir * max_speed
	var point_direction = velocity.rotated(Vector3.UP, -$XRCamera3D.global_rotation.y).normalized() * 0.3
	return point_direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# reset to not accelerate
#	if steering != "flying":
	self.get_parent().velocity.x *= 0
	self.get_parent().velocity.z *= 0
#	else:
#		var drag = -velocity * 0.5 * delta
#		drag.y = 0
#		velocity += drag
		
#	if ((previous_flap_height - ($LeftController.position.y + $RightController.position.y)) / delta) > gravity:
#		velocity.y += (previous_flap_height - ($LeftController.position.y + $RightController.position.y)) / delta
	var ldiff = previous_left_height - $LeftController.position.y
	var rdiff = previous_right_height - $RightController.position.y
	if !uninitialized_controllers:
		if (ldiff / delta > 1) && (rdiff / delta > 1):
			self.get_parent().velocity.y += min(ldiff, rdiff) * gravity * 2
		previous_left_height = $LeftController.position.y
		previous_right_height = $RightController.position.y

	if self.get_parent().position.y > 0 && !self.get_parent().is_on_floor():
		steering = "flying"
#		steering = "torso"
		self.get_parent().velocity.y += -gravity * delta 
	else:
		steering = ground_steering
#		self.get_parent().position.y = 0
		if self.get_parent().velocity.y < 0:
			self.get_parent().velocity.y = 0
	
	if self.get_parent().position.y < 0:
		self.get_parent().position.y = 0
#	time racing
#	if steering == "flying":
#		time_elapsed += delta
#		var new_time_string = "Time: " + str(snappedf(time_elapsed, 0.01))
#		if (int(snappedf(time_elapsed, 0.01) * 100.0) % 100) == 0:
#			new_time_string += ".00"
#		elif (int(snappedf(time_elapsed, 0.01) * 100.0) % 10) == 0:
#			new_time_string += "0"
#		$XRCamera3D/Pivot/SubViewport/CanvasLayer/LineEdit.text = new_time_string + "s"
#		$XRCamera3D/Pivot/SubViewport.size.x = $XRCamera3D/Pivot/SubViewport/CanvasLayer/LineEdit.size.x
#		$XRCamera3D/Score.mesh.size.x = $XRCamera3D/Pivot/SubViewport/CanvasLayer/LineEdit.size.x * 0.1 / $XRCamera3D/Pivot/SubViewport/CanvasLayer/LineEdit.size.y
#		$XRCamera3D/Score.position.x = -0.45 + ($XRCamera3D/Score.mesh.size.x / 2)

	# Forward translation
	if steering == "flying":
		var point_direction = flying_movement(delta)
		point_direction.y = 0
		$XRCamera3D/Pivot/PointDirection.position = point_direction
		$XRCamera3D/Pivot/ArrowPivot.look_at($XRCamera3D/Pivot/PointDirection.global_position)
	elif steering == "torso":
		var point_direction = torso_movement(delta)
		point_direction.y = 0
		$XRCamera3D/Pivot/PointDirection.position = point_direction
		$XRCamera3D/Pivot/ArrowPivot.look_at($XRCamera3D/Pivot/PointDirection.global_position)
	elif self.input_vector.y > self.dead_zone || self.input_vector.y < -self.dead_zone:
		# magnitude of the change in velocity determined by joystick input
		var mag_dvelocity = Vector3(0, 0, max_speed * -self.input_vector.y)
		var point_direction = Vector3(0, 0, -1)
		
		if steering == "view-directed":
			point_direction = view_movement(mag_dvelocity)
		elif steering == "hand-directed":
			point_direction = hand_movement(mag_dvelocity)
		point_direction.y = 0
		$XRCamera3D/Pivot/PointDirection.position = point_direction
		$XRCamera3D/Pivot/ArrowPivot.look_at($XRCamera3D/Pivot/PointDirection.global_position)
	
#	self.position += velocity * delta
	self.get_parent().move_and_slide()
	
	if print_timer > -1:
		print_timer += delta
		if (print_timer > 2):
	#		print(snapped(self.position.y, 0.01), " ", snapped(velocity.y, 0.01))
	#		print_timer = 0
			if uninitialized_controllers:
				previous_left_height = $LeftController.position.y
				previous_right_height = $RightController.position.y
				uninitialized_controllers = false
				print_timer = -1
	
	# keep arrow parallel with the XROrigin
	$XRCamera3D/Pivot.rotation.x = -$XRCamera3D.rotation.x
	$XRCamera3D/Pivot.rotation.z = -$XRCamera3D.rotation.z
	
#	# keep Talons under the camera
#	$TalonPivot.position.x = $XRCamera3D.position.x
#	$TalonPivot.position.z = $XRCamera3D.position.z
	
	# check for if in dead zone
	if self.input_vector.x < self.smooth_turn_dead_zone && self.input_vector.x > -self.smooth_turn_dead_zone:
		back_to_dead = true
	
	# Smooth turn
	if turn_mode == "smooth" && (self.input_vector.x > self.smooth_turn_dead_zone || self.input_vector.x < -self.smooth_turn_dead_zone):
		
		# move to the position of the camera
		self.translate($XRCamera3D.position)
		
		# rotate about the camera's position
		self.rotate(Vector3.UP, deg_to_rad(smooth_turn_speed) * -self.input_vector.x * delta)
		
		# reverse the translation to move back to the original position
		self.translate($XRCamera3D.position * -1)

	# Snap turn
	elif turn_mode == "snap" && back_to_dead == true && (self.input_vector.x > 0.9 || self.input_vector.x < -0.9):
		
		# move to the position of the camera
		self.translate($XRCamera3D.position)
		
		# rotate about the camera's position
		if self.input_vector.x > 0:
			self.rotate(Vector3.UP, deg_to_rad(-45))
			back_to_dead = false
		elif self.input_vector.x < 0:
			self.rotate(Vector3.UP, deg_to_rad(45))
			back_to_dead = false

		# reverse the translation to move back to the original position
		self.translate($XRCamera3D.position * -1)

func process_input(input_name: String, input_value: Vector2):
	if input_name == "primary":
		input_vector = input_value

func _on_button_pressed(name):
	if name == "ax_button":
		if ground_steering == "view-directed":
			ground_steering = "hand-directed"
		else: 
			ground_steering = "view-directed"
	elif name == "by_button":
		if turn_mode == "smooth":
			turn_mode = "snap"
		else: 
			turn_mode = "smooth"
#	elif name == "menu_button":
#		if steering == "flying":
#			steering = "view-directed"
#		else: 
#			steering = "flying"
#		self.global_position = Vector3(673, 0.1, -262)
#		self.rotation.y = 180
#		$"XRCamera3D/Score".visible = true
#		$"TalonPivot".visible = true
#		$"XRCamera3D/Pivot/SubViewport/CanvasLayer/LineEdit".add_theme_color_override("font_color", Color(1, 1, 1))
#		time_elapsed = 0
#		for child in $"../FLying Area/meese".get_children():
#			child.position.y = 0.014
#		self.rotation.x += deg_to_rad(15) Vector3(2.875, 5.55, 0.3)
#		self.rotation.y += deg_to_rad(15) $"~/Starting Area/hut/hut2/door/door/handle".global_position
