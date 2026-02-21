#!/bin/bash

# Проверяем, установлен ли ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "Ошибка: ffmpeg не установлен. Установите его! (sudo apt install ffmpeg или sudo apt install bc)."
    exit 1
fi

# Проходим по всем mp4 файлам в текущей директории
for file in *.mp4; do
    # Проверяем наличие файлов, чтобы не выдать ошибку, если их нет
    [ -e "$file" ] || continue

    echo "Обработка: $file"

    # 1. Получаем длительность видео в секундах
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file")

    # 2. Вычисляем середину (используем bc для работы с плавающей точкой)
    middle=$(echo "$duration / 2" | bc -l)

    # 3. Извлекаем кадр
    # -ss ставим ПЕРЕД -i для быстрого поиска по ключевым кадрам
    # -frames:v 1 берем ровно один кадр
    # q:v 2 устанавливает высокое качество JPEG
    ffmpeg -y -ss "$middle" -i "$file" -frames:v 1 -q:v 2 "${file%.mp4}_middle.jpg" -loglevel error

    echo "Готово: ${file%.mp4}_middle.jpg"
done

echo "---"
echo "Все кадры извлечены!"
