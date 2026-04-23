# RoboHead CLI

Командная утилита для управления роботом RoboHead на базе ROS 2 (Robot Operating System).

## Описание

RoboHead CLI предоставляет удобный интерфейс для:

- Управления системными сервисами робота (старт, стоп, рестарт)
- Создания оптимизированных образов SD-карты
- Настройки аудио и громкости
- Управления словарём голосового распознавания (KWS и ASR)
- Создания и управления действиями (actions) робота
- Выключения и перезагрузки системы

## Структура проекта

```
robohead-cli/
├── source/
│   ├── robohead          # Основной Python-скрипт CLI
│   └── config.json       # Конфигурация с путями
└── install.sh            # Скрипт автоматической установки
```

## Установка

### Автоматическая установка

```bash
cd robohead-cli
sudo ./install.sh
```

### Ручная установка

```bash
sudo mkdir -p /opt/robohead-cli
sudo mkdir -p ~/.config/robohead
sudo cp source/robohead /opt/robohead-cli/robohead
sudo cp source/config.json ~/.config/robohead/config.json
sudo chmod +x /opt/robohead-cli/robohead
sudo ln -s /opt/robohead-cli/robohead /usr/local/bin/robohead
```

## Использование

После установки команда `robohead` доступна из любой директории:

```bash
robohead [модуль] [команда] [опции]
```

### Основные модули

#### core — Управление системой и сервисами

```bash
# Запуск сервиса
robohead core start

# Остановка сервиса
robohead core stop

# Перезапуск сервиса
robohead core restart

# Перезапуск в debug-режиме
robohead core restart --debug

# Выключение системы
robohead core shutdown
robohead core shutdown --no-sync

# Перезагрузка системы
robohead core reboot
robohead core reboot --no-sync

# Создание образа SD-карты
robohead core get_img
robohead core get_img --device /dev/sdc
robohead core get_img --output /media/usb/backup.img
robohead core get_img --pack                    # Сжать через PiShrink
robohead core get_img --2pack                   # Сжать + архивировать в gzip
robohead core get_img --device /dev/sdc --output /media/usb/backup.img --2pack
```

#### config — Настройки системы

**Динамики и аудио:**

```bash
# Установить громкость (0-100)
robohead config speakers set_volume 75

# Установить стандартную громкость (60%)
robohead config speakers set_volume --default

# Сохранить громкость для автозапуска
robohead config speakers set_volume 60 --standart
```

**Голосовое распознавание — Активационные слова (KWS):**

```bash
# Добавить активационное слово
robohead config words wake_phrase add слушай робот

# Удалить активационное слово
robohead config words wake_phrase remove привет робот

# Список активационных слов
robohead config words wake_phrase list

# Установить одно активационное слово (заменить все)
robohead config words wake_phrase set слушай робот
```

**Голосовое распознавание — Быстрые команды (KWS):**

```bash
# Добавить быструю команду
robohead config words fast_command add громче

# Удалить быструю команду
robohead config words fast_command remove тише

# Список быстрых команд
robohead config words fast_command list

# Установить одну быструю команду
robohead config words fast_command set стоп
```

**Голосовое распознавание — Команды (ASR):**

```bash
# Добавить команду
robohead config words command add покажи уши

# Удалить команду
robohead config words command remove сделай фото

# Список команд
robohead config words command list

# Установить одну команду
robohead config words command set поздоровайся
```

**Аудио файлы:**

```bash
# Заменить аудио файл в модуле
robohead config voice set_audio \
  --from-file ./new_sound.mp3 \
  --to-module std_greeting/action.py
```

#### action — Управление действиями

```bash
# Список всех действий
robohead action list

# Создать новое действие
robohead action create smile улыбнись
robohead action create dance танцуй

# Создать действие без команды активации
robohead action create custom_action --no-word

# Получить информацию о действии
robohead action info smile
robohead action info smile --path      # Только путь
robohead action info smile --data      # Только дата
robohead action info smile --in-file   # Содержимое файла

# Удалить действие
robohead action remove smile

# Запустить действие через ROS topic
robohead action run std_smile
robohead action run std_greeting
```

## Примеры использования

### Создание нового действия

```bash
# 1. Создайте действие
robohead action create greeting привет

# 2. Отредактируйте файл действия
nano ~/robohead_ws/src/robohead2/robohead_controller/robohead_controller/actions/greeting/action.py

# 3. Перезапустите сервис (словарь обновится автоматически)
robohead core restart
```

### Настройка громкости

```bash
# Установить громкость 75% и сохранить для автозапуска
robohead config speakers set_volume 75 --standart
```

### Создание образа SD-карты

```bash
# 1. Подключите SD-карту через кардридер
# 2. Найдите устройство
lsblk

# 3. Создайте образ со сжатием
robohead core get_img --device /dev/sdc --output ~/backup.img --pack

# 4. Или создайте образ с двойным сжатием (минимум места)
robohead core get_img --device /dev/sdc --output ~/backup.img --2pack

# Образ сохранится в ~/OS_image/
```

### Запуск действия

```bash
# Запустить действие по имени
robohead action run std_smile

# Команда автоматически:
# 1. Отправит активационную фразу (KWS)
# 2. Отправит команду действия (ASR)
```

### Управление словами

```bash
# Добавить активационное слово
robohead config words wake_phrase add привет робот

# Добавить команду распознавания
robohead config words command add покажи напряжение

# Просмотреть все команды
robohead config words command list

# Применить изменения
robohead core restart
```

## Справка

Для получения помощи по конкретной команде используйте флаг `-h` или `--help`:

```bash
robohead --help
robohead core --help
robohead core get_img --help
robohead config --help
robohead config words --help
robohead config words wake_phrase --help
robohead config speakers set_volume --help
robohead action --help
robohead action run --help
```

## Конфигурация

Все пути хранятся в файле `~/.config/robohead/config.json`:

```json
{
  "paths": {
    "ws_root": "~/robohead_ws",
    "controller_root": "~/robohead_ws/src/robohead2/robohead_controller",
    "config_dir": "~/robohead_ws/src/robohead2/robohead_controller/config",
    "actions_dir": "~/robohead_ws/src/robohead2/robohead_controller/robohead_controller/actions",
    "image_dir": "~/OS_image"
  },
  "files": {
    "robohead_controller_yaml": "robohead_controller.yaml",
    "media_driver_yaml": "media_driver.yaml",
    "asr_yaml": "speech_recognizer_asr.yaml",
    "kws_yaml": "speech_recognizer_kws.yaml"
  }
}
```

## Требования

- Python 3.8+
- ROS 2 (Humble/Iron)
- RoboHead2 workspace (`~/robohead_ws`)
- Права sudo для системных команд
- PiShrink (устанавливается автоматически при первом использовании `get_img --pack`)

## Расположение файлов

После установки:

- Исполняемый файл: `/opt/robohead-cli/robohead`
- Символическая ссылка: `/usr/local/bin/robohead`
- Конфиг CLI: `~/.config/robohead/config.json`
- Конфиги RoboHead: `~/robohead_ws/src/robohead2/robohead_controller/config/`
- Действия: `~/robohead_ws/src/robohead2/robohead_controller/robohead_controller/actions/`
- Образы: `~/OS_image/`

## Поддержка

Документация: https://docs.voltbro.ru

---

**Версия:** 2.0.0 (ROS 2)
