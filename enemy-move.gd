extends Area2D

@export var speed = 80.0
@export var move_distance = 200.0

var start_x
var direction = 1

@onready var sprite = $AnimatedSprite2D

func _ready():
	start_x = global_position.x
	# 开局播放待机动画，你的待机动画名自行替换
	sprite.play("daiji")

func _process(delta):
	global_position.x += direction * speed * delta

	if global_position.x > start_x + move_distance:
		direction = -1
		sprite.flip_h = true

	if global_position.x < start_x - move_distance:
		direction = 1
		sprite.flip_h = false

	# 移动时播放走路动画 zoulu
	if abs(direction) > 0:
		if sprite.animation != "zoulu":
			sprite.play("zoulu")
			
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
