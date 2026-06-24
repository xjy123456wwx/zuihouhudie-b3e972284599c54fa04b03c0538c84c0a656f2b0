extends Control

# 主城淡入动画（进主城时播放）
@onready var dong_hua: AnimationPlayer = $AnimationPlayer
# 新增：主城跳转关卡的黑屏遮罩、动画播放器
@onready var mask_go: ColorRect = $mask_go
@onready var anim_go: AnimationPlayer = $anim_go

# 进入主城自动亮屏
func _ready():
	dong_hua.play("liang")
	mask_go.modulate.a = 0 # 跳转遮罩初始透明

# 点击Go按钮执行
func _on_go_pressed():
	anim_go.play("hei") # 播放主城慢慢黑屏动画
	await anim_go.animation_finished # 等黑屏结束再切关卡
	# 替换成你ground.tscn真实完整路径
	get_tree().change_scene_to_file("res://liuchengyu/ground.tscn")

# 好友按钮
func _on_friend_pressed():
	print("打开好友界面")
	# 后续可写切换好友场景代码
	# get_tree().change_scene_to_file("res://xxx/friend.tscn")

# 展馆按钮
func _on_zhuanguan_pressed():
	print("打开展馆界面")

# 背包按钮
func _on_bag_pressed():
	print("打开背包界面")

# 任务按钮
func _on_renwu_pressed():
	print("打开任务面板")

# 商店按钮
func _on_shop_pressed():
	print("打开商店")

# 设置按钮
func _on_shezhi_pressed():
	print("打开设置窗口")

# 生态缸按钮
func _on_shengtaigang_pressed():
	print("进入生态缸查看界面")


func _on_ditu_pressed() -> void:
	pass # Replace with function body.
