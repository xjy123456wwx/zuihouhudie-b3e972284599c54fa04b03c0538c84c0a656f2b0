extends Area2D

var has_triggered: bool = false

func _ready():
	# 开启碰撞监听
	monitoring = true
	monitorable = true

func _body_entered(body):
	if has_triggered:
		return
	# 只响应玩家分组
	if body.is_in_group("player"):
		has_triggered = true
		# 找到同级的 elevator 节点并激活
		get_node("../elevator").activate_elevator()
		print("电梯已被玩家触发！")
		
