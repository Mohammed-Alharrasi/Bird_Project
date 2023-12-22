extends Node3D

@onready var bird_poop_scene = preload("res://scenes/bird_poop.tscn")

func _on_right_controller_button_pressed(name):
	if (
		name == "ax_button"
	):
		var poop = bird_poop_scene.instantiate()
		self.add_child(poop)
		poop.global_position = $"../CharacterBody3D/XROrigin3D/XRCamera3D".global_position
		poop.global_position.y = 0.01
		print("pooped")
