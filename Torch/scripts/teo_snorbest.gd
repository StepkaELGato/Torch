extends CharacterBody2D
class_name Player  # Устанавливает имя класса, чтобы этот класс можно было использовать в других сценах

signal healthChanged  # Сигнал, который будет отправляться при изменении здоровья игрока

# Ссылка на экран смерти, который загружается и создается как экземпляр сцены die_menu.tscn
@onready var death_screen = load("res://UI/die_menu.tscn").instantiate()

# Ссылка на Label для отображения количества монет
@onready var coin_label : Label = $"../Label_coins/CoinsBar/CoinsLable"

# Ссылки на маркеры, используемые для позиции в разных локациях (например, дом и офис)
@onready var teo_house_marker: Marker2D = get_node_or_null("../teo_house_marker")
@onready var office_marker: Marker2D = get_node_or_null("../office_marker")

# Ссылка на узел Label для отображения количества убийств врагов
@onready var kills_label = $killStates  

# Таймер для контроля задержки между атаками или действиями
@onready var cooldown_timer = $CooldownTimer

# Анимационный проигрыватель для управления анимациями персонажа
@onready var animations = $AnimationPlayer

# Эффекты, связанные с персонажем (например, частицы, вспышки при ударе)
@onready var effects = $Effects

# Таймер для контроля времени, в течение которого персонаж получает урон
@onready var hurtTimer = $hurtTimer

# Ссылка на оружие, которое использует персонаж
@onready var weapon = $weapon 

# Контейнер для отображения количества жизней игрока в интерфейсе
@onready var heartsContainer = $CanvasLayer/heartsContainer

# Аудио для шагов персонажа, будет проигрываться во время передвижения
@onready var footStepAudio = $footStepsAudio

# Таймер для контроля частоты звука шагов
@onready var stepTimer = $stepTimer

# Аудио для звука получения урона
@onready var damageAudio = $damageAudio

# Аудио для звука восстановления здоровья
@onready var healAudio = $healAudio

# Аудио для звука атаки
@onready var attackAudio = $attackAudio

# Аудио для звука при сборе монет
@onready var coinAudio = $coinAudio


@onready var dead: bool = false  # Флаг для отслеживания состояния "мертв" персонажа
var lastAnimDirection: String = "Down"  # Направление последней анимации для выбора нужного кадра при остановке
var isHurt: bool = false  # Флаг для отслеживания, находится ли персонаж в состоянии получения урона
var isAttacking: bool = false  # Флаг для отслеживания, выполняет ли персонаж атаку
var is_respawning = false  # Флаг для отслеживания состояния возрождения персонажа


@export var maxHealth = 3  # Максимальное количество здоровья персонажа
@onready var currentHealth: int = maxHealth  # Текущее здоровье персонажа, устанавливается на максимум при старте

var move_speed : float = 100  # Скорость передвижения персонажа
var starting_direction : Vector2 = Vector2(0, 1)  # Начальное направление движения персонажа (по умолчанию вниз)
var teleport_distance = 50.0  # Расстояние для телепортации (если будет использоваться функция телепорта)

var kills = 0  # Переменная для отслеживания количества убитых врагов
var coins = 0  # Переменная для хранения количества собранных монет


# Основная функция для физической обработки, выполняется каждый кадр
func _physics_process(delta: float) -> void:
	
	# Получение направления на основе ввода игрока (WASD или стрелки)
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	# Устанавливаем скорость персонажа в зависимости от направления ввода
	velocity = input_direction * move_speed
	
	updateAudio()  # Обновляем аудио (например, шаги) в зависимости от движения
	
	# Проверка нажатия кнопки атаки и вызов функции атаки
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# Выполнение движения персонажа с учетом столкновений
	move_and_slide()
	
	updateAnimation()  # Обновление анимации в зависимости от текущего состояния персонажа

# Функция атаки
func attack():
	# Проверяем, работает ли таймер перезарядки; если работает, выходим из функции, чтобы избежать повторной атаки
	if !cooldown_timer.is_stopped():
		return
	
	# Проигрываем анимацию атаки в направлении последнего движения
	animations.play("attack" + lastAnimDirection)
	
	# Воспроизводим аудио для атаки
	attackAudio.play()
	
	# Устанавливаем флаг, что персонаж атакует
	isAttacking = true
	
	# Включаем оружие, чтобы оно могло наносить урон
	weapon.enable()
	
	# Ждем завершения анимации атаки
	await animations.animation_finished
	
	# Отключаем оружие, чтобы прекратить нанесение урона
	weapon.disable()
	
	# Сбрасываем флаг атаки
	isAttacking = false
	
	# Запускаем таймер перезарядки для следующей атаки
	cooldown_timer.start()

# Пустая функция для проверки игрока
func player():
	pass

# Функция для обновления анимации персонажа в зависимости от его состояния и направления движения
func updateAnimation():
	# Если персонаж атакует, выходим из функции, чтобы анимация атаки не прерывалась
	if isAttacking: return
	
	# Если персонаж не двигается, останавливаем текущую анимацию
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		# Определяем направление движения персонажа
		var direction = "Down"
		if velocity.x < 0:
			direction = "Left"
		elif velocity.x > 0:
			direction = "Right"
		elif velocity.y < 0:
			direction = "Up"
		
		# Проигрываем анимацию ходьбы в заданном направлении
		animations.play("walk" + direction)
		
		# Обновляем переменную последнего направления движения
		lastAnimDirection = direction

# Инициализация узла и настроек сцены при запуске
func _ready() -> void:
	# Включаем обработку ввода и физики
	set_process_input(true)
	set_physics_process(true)
	
	# Находим узел для отображения количества монет
	var coin_bar = get_node_or_null("../Label_coins/CoinsBar")
	if coin_bar:
		var coin_label = get_node_or_null("/root/Level_1/UI/Label_coins/CoinsBar/CoinsLabel")
		if coin_label != null:
			# Устанавливаем метку для отображения монет в глобальном скрипте CoinStates
			CoinStates.set_coin_label(coin_label)
			print("Label найден: ", coin_label)
		else:
			print("Ошибка: CoinsLabel не найден в CoinBar")
	else:
		print("Ошибка: Label_coins/CoinsBar не найден")
		
	# Запускаем эффекты для сброса
	effects.play("RESET")
	
	# Устанавливаем начальные значения здоровья в контейнере сердец
	heartsContainer.setMaxHearts(maxHealth)
	heartsContainer.updateHearts(currentHealth)
	# Подключаем сигнал для обновления количества сердец при изменении здоровья
	healthChanged.connect(heartsContainer.updateHearts)
	
	# Проверяем, запускалась ли сцена ранее
	if Global.get_start_scene() != true:
		# Если персонаж не мертв, восстанавливаем здоровье из глобального состояния
		if !dead:
			currentHealth = Global.get_health()
	else:
		# Устанавливаем начальное здоровье и сбрасываем флаг первой сцены
		currentHealth = 3
		Global.set_start_scene(false)
	
	# Получаем имя маркера возрождения из глобального менеджера маркеров
	var spawn_marker_name = MarkerManager.player_spawn_marker_name
	var spawn_marker = get_parent().get_node_or_null(spawn_marker_name)
		
	if spawn_marker:
		# Если маркер найден, перемещаем игрока на его позицию
		global_position = spawn_marker.global_position
		print("Player teleported to marker: ", global_position)
	else:
		# Если маркер не найден, используем дефолтную позицию
		print("Spawn marker not found, using default position.")
		global_position = MarkerManager.start_player_position  # Стандартная позиция
		print("Using default spawn position: ", global_position)
		
	# Выводим текущую сцену и имя маркера возрождения в консоль
	print("Current scene: ", get_tree().current_scene.name)
	print("Looking for marker: ", MarkerManager.player_spawn_marker_name)
	
	###################### Обработка позиции на маркере ###########################
	if MarkerManager.target_marker == "teo_house_marker":
		global_position = teo_house_marker.global_position
	if MarkerManager.target_marker == "office_marker":
		global_position = office_marker.global_position
	if MarkerManager.target_marker == "marker_level1":
		global_position = office_marker.global_position
		
	######################################################

####################### Проверка доступа к двери Level 2 #######################

# Увеличивает количество убийств при уничтожении врага
func increase_kills():
	kills += 1
	print("Убийств: ", kills)  # Печатает количество убийств в консоль (можно убрать)
	
# Удаляет врага из сцены и обновляет количество убийств
func kill_enemy(enemy):
	enemy.queue_free()  # Удаляет врага из сцены
	increase_kills()  # Увеличивает счетчик убийств
	
# Обработка попадания во врага
func _on_enemy_hit(enemy):
	kill_enemy(enemy)
	
# Наносит урон игроку и запускает анимацию получения урона
func damage(damage: int):
	# Создаем таймер для обработки эффектов урона
	hurtTimer = Timer.new()
	add_child(hurtTimer)  # Добавляем таймер в сцену
	currentHealth -= damage  # Уменьшаем здоровье на полученный урон
	Global.set_health(currentHealth)  # Сохраняем текущее здоровье в глобальной переменной
	
	# Проверяем, осталось ли здоровье, если нет - игра окончена
	if currentHealth < 1:
		Global.set_health(3)
		dead = true
		# Переходим на экран окончания игры
		get_node("../DiedMenu/DieMenu").game_over()
	
	# Проигрываем звук получения урона
	damageAudio.play()
	# Отправляем сигнал изменения здоровья
	healthChanged.emit(currentHealth)
	# Устанавливаем флаг получения урона
	isHurt = true
	# Запускаем эффект моргания при получении урона
	effects.play("hurtBlink")
	hurtTimer.start()  # Запускаем таймер
	await hurtTimer.timeout
	# Возвращаем эффекты в исходное состояние после окончания таймера
	effects.play("RESET")
	isHurt = false  # Сбрасываем флаг получения урона
	
	
# Функция вызывается, когда другая область входит в зону урона персонажа
func _on_hurt_box_area_entered(area: Area2D) -> void:
	pass # Здесь будет обработка входа объекта в зону урона

# Функция вызывается, когда другая область выходит из зоны урона персонажа
func _on_hurt_box_area_exited(area: Area2D) -> void:
	pass # Здесь будет обработка выхода объекта из зоны урона

# Устанавливает текущее здоровье персонажа
func set_health(health):
	currentHealth = health

# Возвращает текущее здоровье персонажа
func getCurrentHealth():
	return currentHealth

# Восстанавливает здоровье персонажа, если оно ниже максимального
func heal():
	# Проверяем, чтобы здоровье не превышало максимальное значение
	if currentHealth < maxHealth:
		healAudio.play()  # Проигрываем звук исцеления
		currentHealth += 1  # Увеличиваем здоровье на 1
		print("Персонаж хиляется. Текущее здоровье: ", currentHealth)
		healthChanged.emit(currentHealth)  # Отправляем сигнал для обновления здоровья
		heartsContainer.updateHearts(currentHealth)  # Обновляем UI сердца
	else:
		print("Здоровье уже на максимуме.")  # Сообщаем, что здоровье не может быть больше maxHealth

# Добавляет монеты к общему количеству и обновляет интерфейс
func add_coins(amount):
	coinAudio.play()  # Проигрываем звук добавления монеты
	coins += amount  # Увеличиваем количество монет
	update_coin_label()  # Обновляем отображение монет

# Уменьшает количество монет при покупке; возвращает true, если монет хватает
func decrease_coins(amount):
	if coins >= amount:
		coins -= amount  # Уменьшаем количество монет
		return true  # Покупка прошла успешно
	return false  # Покупка невозможна из-за недостатка монет

# Обновляет текст метки, отображающей количество монет
func update_coin_label():
	if coin_label:
		coin_label.text = str(coins)  # Преобразуем количество монет в строку и обновляем текст метки

# Управляет звуком шагов персонажа в зависимости от движения
func updateAudio():
	if velocity != Vector2.ZERO:
		# Если таймер остановлен, запускаем его и проигрываем звук шага
		if stepTimer.is_stopped():
			stepTimer.start()  # Запускаем таймер для ритма шагов
			footStepAudio.play()  # Проигрываем звук шага
	else:
		stepTimer.stop()  # Останавливаем таймер, если персонаж не двигается

# Срабатывает при окончании таймера шагов, проигрывая звук и перезапуская таймер
func _on_step_timer_timeout() -> void:
	if velocity != Vector2.ZERO:  # Проверяем, двигается ли персонаж
		footStepAudio.play()  # Проигрываем звук шага
		stepTimer.start()  # Перезапускаем таймер для следующего шага
