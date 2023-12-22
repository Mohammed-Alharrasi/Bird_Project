extends Sprite3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var look_direction = $"../../CharacterBody3D".global_position
#	look_direction.y = self.global_position.y
#	self.look_at(look_direction)
#	self.rotate_y(deg_to_rad(180))

func _process(delta):
	$SubViewport.size = $SubViewport/CanvasLayer/speech_bubble.size

#@onready var label = $SubViewport/CanvasLayer/speech_bubble/MarginContainer/Label
#@onready var timer = $SubViewport/CanvasLayer/speech_bubble/LetterDisplayTimer


const MAX_WIDTH = 1000

@export var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2


signal finished_displaying()

func display_text(text_to_display: String):
	text = text_to_display
#	await $SubViewport/CanvasLayer/speech_bubble/MarginContainer/Label.ready
#	await $SubViewport/CanvasLayer/speech_bubble/LetterDisplayTimer.ready
	$SubViewport/CanvasLayer/speech_bubble/MarginContainer/Label.text = text_to_display
	
#	await $SubViewport/CanvasLayer/speech_bubble.resized
	$SubViewport/CanvasLayer/speech_bubble.custom_minimum_size.x = MAX_WIDTH #min($SubViewport/CanvasLayer/speech_bubble/Label.size.x, MAX_WIDTH)
	
	if $SubViewport/CanvasLayer/speech_bubble.size.x > MAX_WIDTH:
#		$SubViewport/CanvasLayer/speech_bubble/MarginContainer/Label.autowrap_mode = TextServer.AUTOWRAP_WORD
#		await $SubViewport/CanvasLayer/speech_bubble.resized # wait for x resize
#		await $SubViewport/CanvasLayer/speech_bubble.resized # wait for y resize
		$SubViewport/CanvasLayer/speech_bubble.custom_minimum_size.y = $SubViewport/CanvasLayer/speech_bubble.size.y
		
#	global_position.x -= (($SubViewport/CanvasLayer/speech_bubble.size.x / 2) - 185)
#	global_position.y -= $SubViewport/CanvasLayer/speech_bubble.size.y + 50
	
	$SubViewport/CanvasLayer/speech_bubble/MarginContainer/Label.text = ""
	_display_letter()
	

func _display_letter():
	$SubViewport/CanvasLayer/speech_bubble/MarginContainer/Label.text = text.substr(0, letter_index + 1) + "\n "
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
		
	match text[letter_index]:
		"!", ".", ",", "?":
			$LetterDisplayTimer.start(punctuation_time)
		" ":
			$LetterDisplayTimer.start(space_time)
		_:
			$LetterDisplayTimer.start(letter_time)


func _on_letter_display_timer_timeout():
	_display_letter()

