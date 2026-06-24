extends AnimatableBody2D

@export var move_speed: float = 60.0
@export var top_distance: float = 400.0
@export var bottom_distance: float = 450.0

var start_position: Vector2
var top_point: Vector2
var bottom_point: Vector2
var current_target: Vector2
var is_activated: bool = true  # 把这里从 false 改成 true，开机就动

func _ready():
	start_position = position
	top_point = start_position - Vector2(0, top_distance)
	bottom_point = start_position + Vector2(0, bottom_distance)
	current_target = top_point

func _physics_process(delta):
	if not is_activated:
		return
	position = position.move_toward(current_target, move_speed * delta)
	if position.distance_to(current_target) < 1.0:
		current_target = bottom_point if current_target == top_point else top_point

# 保留触发函数，方便你之后改回触发模式
func activate_elevator():
	is_activated = true
	print("电梯开始运行！")
	
