extends CharacterBody2D

# 可在编辑器直接调参数
@export var push_speed: float = 280.0
@export var gravity: float = 2000.0

# 标记玩家是否在箱子推动范围内
var player_near: bool = false

func _ready():
	# 自动绑定碰撞信号，不用手动点右侧信号面板
	$PushArea.body_entered.connect(_on_player_enter)
	$PushArea.body_exited.connect(_on_player_leave)

func _physics_process(delta):
	# 重力下落逻辑
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# 输入读取（和你玩家输入名称匹配 move_left/move_right）
	var input_dir = Input.get_axis("move_left", "move_right")

	# 仅落地+玩家在范围内，才能推动箱子
	if is_on_floor() and player_near:
		velocity.x = input_dir * push_speed
	else:
		# 离开范围后平滑减速停下
		velocity.x = move_toward(velocity.x, 0, push_speed * delta)

	move_and_slide()

# 玩家进入PushArea触发
func _on_player_enter(body: Node2D):
	if body.name == "player":
		player_near = true
		print("玩家靠近，可以推箱子")

# 玩家离开PushArea触发
func _on_player_leave(body: Node2D):
	if body.name == "player":
		player_near = false
		print("玩家远离，无法推动")
		
