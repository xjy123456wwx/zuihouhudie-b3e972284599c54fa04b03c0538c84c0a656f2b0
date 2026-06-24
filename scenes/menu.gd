extends Control

@onready var anim_fade: AnimationPlayer = $AnimationPlayer
@onready var mask: ColorRect = $ColorRect

func _ready():
	mask.modulate.a = 0
	print("页面加载完成，遮罩初始透明")

func _on_start_pressed():
	print("点击进入游戏按钮，准备播放动画hei")
	# 打印当前拥有的所有动画名称，排查是否存在hei
	print("动画列表：", anim_fade.get_animation_list())
	anim_fade.play("hei")
	await anim_fade.animation_finished
	print("动画播放完毕，跳转主界面")
	get_tree().change_scene_to_file("res://scenes/zhujiemian.tscn")

func _on_load_pressed() -> void:
	print("打开存档列表")

func _on_setting_pressed() -> void:
	print("打开设置面板")

func _on_exit_pressed() -> void:
	get_tree().quit()
