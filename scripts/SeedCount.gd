extends Label
var seed_counter: Label

@onready var globals = get_node("/root/Globals")
@onready var seedValue = "Number of Seeds Collected: "+ str(globals.active_grabbers.size()) 

# Called when the node enters the scene tree for the first time.
func _ready():
	seed_counter = %SeedCount
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seedValue = "Number of Seeds Collected: "+ str(globals.active_grabbers.size()) 
	seed_counter.set_text(seedValue)
#	pass
