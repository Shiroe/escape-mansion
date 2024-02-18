extends PathFollow2D

var speed =  0.01  # Adjust this value to control the speed

func _ready() -> void:
	# In the _ready function or somewhere before the _process function
	loop = true

func _process(delta):
	# Increment the progress_ratio to move along the path
	progress_ratio += speed * delta
	
	# If the progress_ratio exceeds  1, loop back to the start of the path
	if progress_ratio >=  1.0:
		progress_ratio =  0.0  # Reset to the start of the path
