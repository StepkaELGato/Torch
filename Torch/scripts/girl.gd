extends CharacterBody2D  # Наследуем класс CharacterBody2D для создания персонажа

@onready var animations = $AnimationPlayer  # Получаем ссылку на узел AnimationPlayer, который управляет анимациями

# Вызывается, когда узел впервые добавляется в дерево сцен.
func _ready() -> void:
	animations.play("idle")  # Запускаем анимацию "idle" (в состоянии ожидания) при инициализации персонажа
