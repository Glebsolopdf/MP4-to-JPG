#!/bin/bash
for file in *.mp4; do
    [ -e "$file" ] || continue

    echo "Обработка: $file"

    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file")

    middle=$(echo "$duration / 2" | bc -l)

    ffmpeg -y -ss "$middle" -i "$file" -frames:v 1 -q:v 2 "${file%.mp4}_middle.jpg" -loglevel error

    echo "Готово: ${file%.mp4}_middle.jpg"
done

echo "---"
echo "Все кадры извлечены!"
