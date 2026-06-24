extends AnimatableBody2D

@export var speed: float = 300.0
@export var wait_time: float = 1.5
var high: Vector2
var low: Vector2
var target: Vector2
var timer: float = 0.0
var waiting: bool = false
var is_looping: bool = false

func _ready():
	high = position
	low = Vector2(position.x, position.y + 4600)
	target = high

# 按钮触发：开启往复循环
func start_loop():
	is_looping = true

# 按钮松开：关闭循环，返回最高点
func return_to_top():
	is_looping = false
	target = high

func _physics_process(delta):
	# 不循环时，持续往最高点移动
	if not is_looping:
		position = position.move_toward(high, speed * delta)
		return

	# 到达两端停留1.5秒逻辑
	if waiting:
		timer += delta
		if timer >= wait_time:
			waiting = false
			timer = 0.0
		return

	position = position.move_toward(target, speed * delta)

	# 抵达最低点，停留后向上
	if position.distance_to(low) < 3:
		waiting = true
		target = high
	# 抵达最高点，停留后向下
	elif position.distance_to(high) < 3:
		waiting = true
		target = low
