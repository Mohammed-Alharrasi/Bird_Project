extends StaticBody3D

var twigs = []
var birds = []
var worms = []
var nest
var twig_count = 0
var nestBuilt = false
var seed_count
var egglayed = false
var eggs
var egghatched = false
var chicks
var time_done = false
var chicks_fed = false
var time_since_message_shown = 0.0
var message_shown = false

@onready var collision_area = $Area3D as Area3D
@onready var globals = get_node("/root/Globals")
@onready var timer = %Timer
@onready var hatch_time = %TimeToHatch
#@onready var hatch_time = %TimeToHatch

func _ready():
	twigs = get_tree().get_nodes_in_group("Twigs")
	birds = get_tree().get_nodes_in_group("Eggs")
	worms = get_tree().get_nodes_in_group("Worms")
	nest = %nestbird# Adjust the path to your Nest node
	nest.visible = false  # Initially hide the nest
	seed_count = globals.active_seeds
	eggs = %eggs
	eggs.visible = false
	chicks = %chicks
	chicks.visible = false
	timer.wait_time = 10  # Set your desired time in seconds
	timer.one_shot = true
	

func _process(delta):
#	print("seed_count: " , seed_count.size())
	if nest.get_node("CollisionShape3D") == null or nest.get_node("CollisionShape3D").shape == null:
		print("Nest has no collision shape or the shape is not set.")

	if egglayed == false: 
#		print("seed_count: " , seed_count.size())
		var player_body = %playerbird as Node3D
		if seed_count.size() >= 2:
			lay_eggs()
			timer.start()
#			var timeValue = "Time for eggs to hatch!!! (s): "+ str(timer.time_left) 
#			hatch_time.set_text(timeValue)
#			print("eggs are layed!!")
#	var timeValue = "Time for eggs to hatch!!! (s): "+ str(int(timer.time_left)) 
#	hatch_time.set_text(timeValue)
	
		# Timer is still running
	var timeValue = "Time for eggs to hatch!!! (s): " + str(int(timer.time_left))
	hatch_time.set_text(timeValue)
	if timer.time_left > 0 and timer.time_left < 1:
		time_done = true
#		print("done")
	
#	print(timeValue)
	if time_done == true and not egghatched:
	# Timer has finished and eggs haven't hatched yet
		hatch_eggs()
		egghatched = true
#		print("Eggs have hatched")

	if nestBuilt == false:
		
		twig_count = 0
		for twig in twigs:
			var grabbable_body = twig as RigidBody3D
			if collision_area.overlaps_body(grabbable_body):
				twig_count += 1
		
#		print("twig_count: ", twig_count)
		if twig_count >= 3:
			build_nest()
	#		print("Nest is buiddd!!!!: ")
	
	if egghatched and not chicks_fed:
		var chick_collision = %chicks/Area3D as Area3D
		for worm in worms:
			var grabbable_body2 = worm as RigidBody3D
			if chick_collision.overlaps_body(grabbable_body2):
				print("chick overlap: ", grabbable_body2)
				grabbable_body2.hide()
				grabbable_body2.collision_layer &= ~1
				%chick_talk.set_text("We love worms, Thank you!")
				time_since_message_shown = 0.0  # Reset the timer
				message_shown = true

	if message_shown:
		time_since_message_shown += delta
		if time_since_message_shown > 5.0:
			%chick_talk.set_text("")  # Clear the message
			message_shown = false  # Reset the flag
		
		
	

	
	

func build_nest():
	for twig in twigs:
		var grabbable_twig = twig as RigidBody3D
		grabbable_twig.collision_layer &= ~1  # Remove from collision layer 1
		grabbable_twig.hide()

	nest.visible = true
	nest.collision_layer |= 1  # Add to collision layer 1
	nestBuilt = true

func lay_eggs():
	eggs.visible = true
	eggs.collision_layer |= 1  # Add to collision layer 1
	egglayed = true
	
func hatch_eggs():
	
#	print("Hatching eggs...")
#	print("Eggs visible before: ", eggs.visible)
	eggs.visible = false
#	print("Eggs visible after: ", eggs.visible)
	chicks.visible = true
	chicks.collision_layer |= 1
	egghatched = true

	

