extends CharacterBody2D

var born_pos:Vector2

const gravity = 2000
const speed_walk = 800
const speed_run = 1550
const jump_force = 1800

var hp = 100
var max_hp = 100
var is_attacking = false
var is_dead = false

var max_jumps = 2
var jumps_remaining = max_jumps

@onready var anim = $AnimatedSprite2D
@onready var hitbox = $HitBox
var attack_has_hit = false

var jump_trigger = false
var is_buzhuo = false

var health = 100
var can_hurt = true
var is_in_emeny : bool = false


func _ready():
	born_pos = global_position
	hitbox.monitoring = false

func _physics_process(delta):
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if is_attacking or is_buzhuo:
		velocity.x = 0
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		jumps_remaining = max_jumps

	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if Input.is_action_pressed("run"):
		velocity.x = direction * speed_run
	else:
		velocity.x = direction * speed_walk

	if jump_trigger:
		jump_trigger = false
		velocity.y = -jump_force
		jumps_remaining -= 1

	if direction != 0:
		anim.flip_h = direction < 0

	# Z键捕捉，把解锁改成计时器，不再依赖动画状态
	if Input.is_action_just_pressed("buzhuo") and not is_buzhuo and not is_attacking and is_on_floor():
		is_buzhuo = true
		anim.play("buzhuo")
		# 等待0.4秒自动解除锁定，和动画时长匹配
		await get_tree().create_timer(0.4).timeout
		is_buzhuo = false

	# 空闲动画
	if not is_buzhuo and not is_attacking:
		if not is_on_floor():
			anim.play("jump")
		elif direction != 0:
			anim.play("walk")
		else:
			anim.stop()

	move_and_slide()

func _process(_delta):
	if is_dead:
		return
	
	if Input.is_action_just_pressed("jump") and jumps_remaining > 0 and not is_buzhuo and not is_attacking:
		jump_trigger = true

	# 右键攻击（保持原样，正常连续释放）
	if Input.is_action_just_pressed("gongji") and not is_attacking and not is_buzhuo and is_on_floor():
		is_attacking = true
		attack_has_hit = false
		anim.play("gongji")
		hitbox.monitoring = true
		
		await anim.animation_finished
		hitbox.monitoring = false
		is_attacking = false

	if can_hurt and is_in_emeny:
		health -= 10
		hurt_flash()
		can_hurt = false
		await get_tree().create_timer(1.0).timeout
		can_hurt = true

	if health <= 0 and not is_dead:
		die()

func die():
	is_dead = true
	anim.play("siwang")
	await get_tree().create_timer(1.0).timeout
	global_position = born_pos
	health = 100
	can_hurt = true
	is_dead = false

func _on_hitbox_body_entered(body):
	if attack_has_hit:
		return
	if body.is_in_group("enemy"):
		attack_has_hit = true
		if body.has_method("take_damage"):
			body.take_damage(25)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	is_in_emeny = true

func _on_hurt_box_area_exited(area: Area2D) -> void:
	is_in_emeny = false

func hurt(damage:int)->void:
	if not can_hurt:
		return
	health -= damage

func hurt_flash():
	anim.modulate = Color.RED
	var t = get_tree().create_timer(0.2)
	t.timeout.connect(restore_color)

func restore_color():
	anim.modulate = Color.WHITE
