extends Area2D

# ========== 感知距离参数（带中文标注） ==========
@export var alert_radius: float = 800.0     # 警戒距离：玩家进入800内怪物会转向玩家
@export var attack_range: float = 550.0     # 攻击距离：玩家贴近350内原地释放攻击gongji
@export var return_distance: float = 1000.0 # 脱离距离：玩家跑出1000像素怪物恢复纯待机

# 状态标记
var is_attacking: bool = false
@export var player: Node2D                  # main场景拖拽玩家节点绑定
@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("daiji")
	print("树木怪物加载完成，默认播放待机动画daiji")

func _process(delta):
	if not player:
		print("报错：怪物右侧Player参数未绑定玩家节点！")
		return
		
	var dis_to_player = global_position.distance_to(player.global_position)
	print("玩家与树木距离：", dis_to_player)

	# 先固定朝向玩家
	set_player_face()

	if dis_to_player <= attack_range:
		# 进入攻击范围，原地攻击
		if not is_attacking:
			attack_logic()
	elif dis_to_player <= alert_radius:
		# 看见玩家，但没到攻击距离，保持待机
		if sprite.animation != "daiji":
			sprite.play("daiji")
	else:
		# 玩家走远，纯待机
		if sprite.animation != "daiji":
			sprite.play("daiji")

# 原地面朝玩家，不会频繁抖动翻转
func set_player_face():
	var dir_x = player.global_position.x - global_position.x
	sprite.flip_h = dir_x < 0

# 原地攻击逻辑，全程不移动
func attack_logic():
	is_attacking = true
	print("玩家进入攻击范围，原地播放gongji攻击动画")
	sprite.play("gongji")
	# 等待攻击动画完整播放完毕
	await sprite.animation_finished
	is_attacking = false
	print("攻击结束，回到待机动画daiji")
	sprite.play("daiji")


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
