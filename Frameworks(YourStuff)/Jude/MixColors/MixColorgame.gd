extends Game

@onready var Description: RichTextLabel = $Description
@onready var timer_words: RichTextLabel = $TimerWords
@onready var color_chosen_label: Label = $ColorChosen

var timer = 1.0
var won = false

signal time_done

var current_paint : Color
var started = false

var color_chosen : Color

func _start_game() -> void:
	started = true
	Description.show()
	
	await get_tree().create_timer(1.0).timeout #wait for instructions
	Description.hide()
	timer_words.show()
	set_random_color()
	color_chosen_label.modulate = color_chosen
	color_chosen_label.show()
	
	started = true

	timer = 10/get_intensity()
	await time_done
	emit_signal("end_game", won)

func _process(delta: float) -> void:
	if !started: return
	
	if timer_words.visible: 
		if timer > 0:
			timer = max(timer - delta, 0)
		else:
			timer = 0
			time_done.emit()
	timer_words.text = str(snapped(timer, .01))

func set_random_color():
	var rand3 = randi_range(0,2)
	match rand3:
		0:
			color_chosen = Color.GREEN
		1:
			color_chosen = Color.PURPLE
		2:
			color_chosen = Color.ORANGE

func get_closest_rigid_color(c: Color) -> Color: #helper
	var options = [Color.GREEN, Color.PURPLE, Color.ORANGE]
	
	var best_match = options[0]
	var shortest_dist = 999.0
	
	for option in options:
		# We use Vector3 to treat R, G, B as spatial coordinates for distance
		var dist = Vector3(c.r, c.g, c.b).distance_squared_to(Vector3(option.r, option.g, option.b))
		
		if dist < shortest_dist:
			shortest_dist = dist
			best_match = option
			
	return best_match


func _on_mixer_done_mixing() -> void:
	if get_closest_rigid_color(current_paint) == color_chosen:
		won = true
	else:
		won = false
		color_chosen_label.modulate = Color.BLACK
