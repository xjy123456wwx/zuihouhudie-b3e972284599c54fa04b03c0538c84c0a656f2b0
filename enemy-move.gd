extends Area2D

@export var speed = 80.0
@export var move_distance = 200.0

var start_x
var direction = 1

@onready var sprite = $AnimatedSprite2D

func _ready():
	start_x = global_position.x

func _process(delta):
	global_position.x += direction * speed * delta

	if global_position.x > start_x + move_distance:
		direction = -1
		sprite.flip_h = true

	if global_position.x < start_x - move_distance:
		direction = 1
		sprite.flip_h = false
