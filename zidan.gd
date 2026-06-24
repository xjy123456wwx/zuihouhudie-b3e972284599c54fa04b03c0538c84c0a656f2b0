extends Area2D

@export var bullet_speed: float = 500.0
@export var life_time: float = 4.0
var fly_dir: Vector2

func _ready():
	# 超时自动销毁
	await get_tree().create_timer(life_time).timeout
	queue_free()

func _process(delta):
	global_position += fly_dir * bullet_speed * delta

func set_dir(dir: Vector2):
	fly_dir = dir
	rotation = dir.angle()

# 子弹进入玩家碰撞区域触发
func _on_body_entered(body):
	# 判断碰到的物体是不是玩家
	if body.name == "player":
		queue_free() # 子弹直接删除消失
