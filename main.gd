extends Node2D

var spike = preload("res://spike.tscn")
var flag = preload("res://flag.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		var instanced_spike = spike.instantiate()
		add_child(instanced_spike)             

		instanced_spike.position = Vector2(177 * (1 + i), 0)
		if i < 2:
			instanced_spike.position.y = 456
		elif i == 2:
			instanced_spike.position.y = 366
		else: 
			instanced_spike.position.y = 276
	var the_flag = flag.instantiate()
	add_child(the_flag)
	
	the_flag.position = Vector2(1050, 175)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
