extends StaticBody3D

var active = false;

const lines: Array[String] = [
	"Tweet!",
	"You're finally awake...",
	"Happy 18th Birthday Birdy!",
	"Now that you're 18 days old, it's time to go build a nest of your very own.",
	"Twigs work well for a rudimentary nest.",
	"If you get around to investing in the stork market you could earn yourself a house like your mom and pop."
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
			print("next1")
			DialogManager.text_box.queue_free()
			
			DialogManager.current_line_index += 1
			if DialogManager.current_line_index >= DialogManager.dialog_lines.size():
				DialogManager.is_dialog_active = false
				DialogManager.current_line_index = 0
				return
				
			DialogManager._show_text_box()
		else:
			print("start1")
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