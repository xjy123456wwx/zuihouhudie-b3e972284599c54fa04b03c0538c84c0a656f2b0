extends Area2D

# 巡逻相关设置
@export var patrol_speed: float = 60.0
@export var patrol_range: float = 220.0
var start_x: float
var dir_patrol: int = 1

# 感知、发射子弹设置
@export var alert_radius: float = 1700.0
@export var return_distance: float = 1900.0
@export var shoot_cd: float = 1.3

# 子弹预制体
@export var bullet_prefab: PackedScene
@export var bullet_speed: float = 350.0

# 绑定节点
@export var player: Node2D
@onready var sprite = $AnimatedSprite2D
@onready var shoot_point = $Marker2D

# 内部状态变量
var shoot_timer: Timer
var player_in_range: bool = false
# 新增：手动标记计时器是否在运行，避开引擎自带报错函数
var timer_running: bool = false

func _ready():
	start_x = global_position.x
	sprite.play("zoulu")
	# 创建计时器
	shoot_timer = Timer.new()
	shoot_timer.wait_time = shoot_cd
	shoot_timer.timeout.connect(shoot_bullet)
	add_child(shoot_timer)

func _process(delta):
	if not player:
		return
	var dis_to_player = global_position.distance_to(player.global_position)

	if dis_to_player <= alert_radius:
		player_in_range = true
		patrol_stop()
		turn_to_player()
		# 改用自己写的变量判断，不调用Timer的任何函数
		if not timer_running:
			shoot_timer.start()
			timer_running = true
	elif dis_to_player > return_distance:
		player_in_range = false
		shoot_timer.stop()
		timer_running = false
		patrol_run(delta)

# 无人时左右巡逻走路
func patrol_run(delta):
	global_position.x += dir_patrol * patrol_speed * delta
	if global_position.x > start_x + patrol_range:
		dir_patrol = -1
		sprite.flip_h = true
	if global_position.x < start_x - patrol_range:
		dir_patrol = 1
		sprite.flip_h = false
	if sprite.animation != "zoulu":
		sprite.play("zoulu")

# 停止巡逻，切换待机动画
func patrol_stop():
	if sprite.animation != "daiji":
		sprite.play("daiji")

# 鸭子面朝玩家，左右翻转
func turn_to_player():
	var dir_x = player.global_position.x - global_position.x
	sprite.flip_h = dir_x < 0

# 生成子弹，水平飞向玩家
func shoot_bullet():
	if bullet_prefab == null:
		print("子弹预制体未绑定！")
		timer_running = false
		return

	var bullet = bullet_prefab.instantiate()
	bullet.global_position = shoot_point.global_position

	var diff_x = player.global_position.x - shoot_point.global_position.x
	var fly_direction = Vector2(diff_x, 0).normalized()

	bullet.set_dir(fly_direction)
	get_tree().root.add_child(bullet)
	timer_running = false
