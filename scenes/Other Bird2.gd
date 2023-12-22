extends StaticBody3D

var active = false;

const lines: Array[String] = [
	"Happy 18th Birthday Birdy!",
	"You remember how to fly... right?",
	"We went over it yesterday silly!",
	"Just flap your wings and you'll go up easy.",
	"...",
	"You'll get hungry on your own, so you'll need to know about food.",
	"You've loved worms since you were a chick, but that's chick food.",
	"Now that you're an adult, you eat seeds like the rest of us.",
	"Good luck darling, and watch out for cats."
]

func _on_right_controller_button_pressed(name):
	if (
		name == "trigger_click" &&
		global_position.distance_to($"../CharacterBody3D/XROrigin3D/XRCamera3D".global_position) < 3
	):
		if (
			DialogManager.is_dialog_active &&
			DialogManager.can_advance_line && 
			active
		):
			print("next2")
			DialogManager.text_box.queue_free()
			
			DialogManager.current_line_index += 1
			if DialogManager.current_line_index >= DialogManager.dialog_lines.size():
				DialogManager.is_dialog_active = false
				DialogManager.current_line_index = 0
				return
				
			DialogManager._show_text_box()
		else:
			print("start2")
			active = true
#			DialogManager.cancel()
			DialogManager.start_dialog(global_position + Vector3(0, 2.4, 0), lines)
	elif (
		name == "trigger_click" &&
		active
	):
		print("far1")
		DialogManager.cancel()
		active = false
