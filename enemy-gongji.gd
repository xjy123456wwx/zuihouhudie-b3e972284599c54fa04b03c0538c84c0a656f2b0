extends Area2D

# ========== 巡逻参数（带注释） ==========
@export var move_speed: float = 60.0        # 巡逻走路速度
@export var patrol_range: float = 250.0     # 左右巡逻最大距离
var start_x: float
var direction: int = 1

# ========== 追击&攻击放大参数 ==========
@export var alert_radius: float = 800.0     # 800像素内发现玩家开始追
@export var attack_range: float = 350.0     # 350像素内停下攻击
@export var chase_speed: float = 120.0      # 追击速度
@export var return_distance: float = 1000.0 # 跑出1000像素放弃追击

# 状态标记
var is_chasing: bool = false
var is_attacking: bool = false
@export var player: Node2D
@onready var sprite = $AnimatedSprite2D

func _ready():
	start_x = global_position.x
	sprite.play("daiji")
	print("怪物加载完成，待机动画daiji")

func _process(delta):
	if not player:
		print("未绑定玩家节点！右侧Player拖拽player")
		return
		
	var dis_to_player = global_position.distance_to(player.global_position)
	print("玩家距离：", dis_to_player)

	if not is_chasing:
		# 未追击：巡逻
		if dis_to_player <= alert_radius:
			is_chasing = true
			print("进入警戒，开始追击 zoulu")
			sprite.play("zoulu")
		else:
			patrol_logic(delta)
	else:
		# 追击分支：攻击优先，攻击时完全停止移动
		if dis_to_player <= attack_range:
			if not is_attacking:
				attack_logic()
			# 满足攻击范围，直接return，不执行追击移动（原地停下）
			return
		elif dis_to_player > return_distance:
			# 玩家跑太远，回归巡逻待机
			is_chasing = false
			print("玩家走远，停止追击 daiji")
			sprite.play("daiji")
		else:
			# 距离适中，正常追击移动
			chase_logic(delta)

# 巡逻逻辑
func patrol_logic(delta):
	global_position.x += direction * move_speed * delta

	if global_position.x > start_x + patrol_range:
		direction = -1
		sprite.flip_h = true
	if global_position.x < start_x - patrol_range:
		direction = 1
		sprite.flip_h = false

	if sprite.animation != "zoulu":
		sprite.play("zoulu")

# 追击逻辑（修复反复翻转抖动）
func chase_logic(delta):
	var dir_to_player = player.global_position.x - global_position.x
	# 只判断一次朝向，避免微小距离差反复flip
	if dir_to_player < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	var move_dir = (player.global_position - global_position).normalized()
	global_position += move_dir * chase_speed * delta

	if sprite.animation != "zoulu":
		sprite.play("zoulu")

# 攻击逻辑：原地不动播放gongji
func attack_logic():
	is_attacking = true
	print("进入攻击范围，播放gongji攻击动画")
	sprite.play("gongji")
	await sprite.animation_finished
	is_attacking = false
	print("攻击结束，继续追击zoulu")
	if is_chasing:
		sprite.play("zoulu")


#绿
var hp = 80
var is_dead = false

# 被攻击触发变色+扣血
func take_damage(dmg):
	if is_dead:
		return
	
	# 怪物变绿
	$AnimatedSprite2D.modulate = Color.GREEN
	hp -= dmg
	await get_tree().create_timer(0.2)
	$AnimatedSprite2D.modulate = Color.WHITE

	# 血量为0执行死亡
	if hp <= 0:
		die()

func die():
	is_dead = true
	$AnimatedSprite2D.play("siwang")
	await $AnimatedSprite2D.animation_finished
	queue_free()
