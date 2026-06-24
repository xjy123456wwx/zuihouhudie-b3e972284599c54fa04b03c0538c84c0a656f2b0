extends Node2D

@export var press_offset: float = 20.0        #按下向下偏移20像素
@export var move_speed: float = 300.0

# 电梯节点路径（严格匹配场景层级）
@onready var elevator = $"../Elevator2/elevator2_gd"

# 严格按场景树节点名写路径
@onready var trigger_area = $TriggerZone
@onready var btn_sprite = $ButtonSprite

var original_y: float
var pressed_count: int = 0

func _ready():
	# 关键：先检查所有节点是否存在，避免空指针
	if not btn_sprite:
		print("❌ 找不到 ButtonSprite 节点！")
		return
	if not trigger_area:
		print("❌ 找不到 TriggerZone 节点！")
		return
	
	original_y = btn_sprite.position.y
	trigger_area.body_entered.connect(on_body_enter)
	trigger_area.body_exited.connect(on_body_leave)

func _physics_process(delta):
	# 只有 btn_sprite 存在时才执行
	if not btn_sprite:
		return

	var target_y = original_y
	if pressed_count > 0:
		target_y = original_y + press_offset
		# 只有电梯存在时才调用方法
		if elevator:
			elevator.start_loop()
	else:
		if elevator:
			elevator.return_to_top()
	
	# 原有按钮移动逻辑不变
	btn_sprite.position.y = move_toward(btn_sprite.position.y, target_y, move_speed * delta)

func on_body_enter(body: Node2D):
	if body.name == "player" or body.name == "box":
		pressed_count += 1

func on_body_leave(body: Node2D):
	if body.name == "player" or body.name == "box":
		pressed_count = max(0, pressed_count - 1)
		
