extends CanvasLayer  # Наследуем класс CanvasLayer для наложения интерфейса на сцену

@onready var color_rect: ColorRect = $ColorRect  # Ссылка на ColorRect, используемый для затемнения экрана
@onready var animation_player: AnimationPlayer = $AnimationPlayer  # Ссылка на AnimationPlayer для управления анимациями

func _ready() -> void:
	color_rect.visible = false  # Скрываем ColorRect при инициализации

# Метод для загрузки новой сцены с анимацией перехода
func load_scene(target_scene: String):
	animation_player.play("fade_in")  # Запускаем анимацию затухания
	await animation_player.animation_finished  # Ждем завершения анимации
	get_tree().change_scene_to_file(target_scene)  # Меняем текущую сцену на целевую
	animation_player.play_backwards("fade_in")  # Запускаем анимацию затухания обратно
	get_tree().paused = false  # Разблокируем игру (если она была приостановлена)

# Метод для перезагрузки текущей сцены с анимацией перехода
func reload_scene(String):
	animation_player.play("fade_in")  # Запускаем анимацию затухания
	await animation_player.animation_finished  # Ждем завершения анимации
	get_tree().reload_current_scene()  # Перезагружаем текущую сцену
	animation_player.play("fade_out")  # Запускаем анимацию затухания
