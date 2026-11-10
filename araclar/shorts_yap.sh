#!/usr/bin/env bash
# Yatay (veya dikey) bir yüzme videosundan YouTube Shorts formatında (1080x1920) klip üretir.
#
# Kullanım:
#   ./shorts_yap.sh <girdi.mp4> "<kanca metni>" [baslangic_sn] [sure_sn] [cikti.mp4]
#
# Örnekler:
#   ./shorts_yap.sh havuz.mp4 "Bu hatayı yapan yavaş yüzer" 12 25
#   MOD=blur ./shorts_yap.sh genis_aci.mp4 "50 metre kaç saniyede?" 0 40 sonuc.mp4
#   YAVAS=0.5 ./shorts_yap.sh dalis.mp4 "Mükemmel dönüş böyle yapılır" 3 6
#
# Ortam değişkenleri:
#   MOD=crop   (varsayılan) Ortadan 9:16 kırpar - yüzücü kadrajın ortasındaysa en iyisi.
#   MOD=blur   Görüntüyü kırpmadan ortalar, arkaya bulanık kopyasını koyar - geniş havuz çekimleri için.
#   YAVAS=0.5  Klibi yavaşlatır (0.5 = yarı hız). Teknik detay / su altı çekimleri için.
#   KANCA_SN=3 Kanca metninin ekranda kalma süresi (saniye). 0 = tüm video boyunca.
#   FONT=/yol/font.ttf  Kullanılacak kalın yazı tipi (Türkçe karakter destekli olmalı).
set -euo pipefail

if [[ $# -lt 2 ]]; then
  sed -n '2,20p' "$0"; exit 1
fi

GIRDI="$1"; KANCA="$2"; BAS="${3:-0}"; SURE="${4:-30}"
CIKTI="${5:-${GIRDI%.*}_short.mp4}"
MOD="${MOD:-crop}"; YAVAS="${YAVAS:-1}"; KANCA_SN="${KANCA_SN:-3}"

command -v ffmpeg >/dev/null || { echo "ffmpeg kurulu değil: https://ffmpeg.org/download.html"; exit 1; }
[[ -f "$GIRDI" ]] || { echo "Dosya bulunamadı: $GIRDI"; exit 1; }

FONT="${FONT:-$(fc-match -f '%{file}' 'DejaVu Sans:bold' 2>/dev/null || true)}"
[[ -f "$FONT" ]] || { echo "Yazı tipi bulunamadı. FONT=/yol/font.ttf ile belirtin."; exit 1; }

# Metni dosyaya yaz: Türkçe karakterler ve özel işaretler için kaçış sorunlarını önler.
METIN=$(mktemp); trap 'rm -f "$METIN"' EXIT
printf '%s' "$KANCA" | fold -s -w 22 > "$METIN"

if [[ "$MOD" == "blur" ]]; then
  GORUNTU="[0:v]split[a][b];[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=25:2[bg];[b]scale=1080:-2[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2"
else
  GORUNTU="[0:v]scale=-2:1920,crop=1080:1920"
fi

if [[ "$KANCA_SN" == "0" ]]; then ZAMAN=""; else ZAMAN=":enable='lt(t,$KANCA_SN)'"; fi

FILTRE="${GORUNTU},setpts=PTS/${YAVAS},drawtext=fontfile='${FONT}':textfile='${METIN}':fontsize=72:fontcolor=white:borderw=6:bordercolor=black:line_spacing=12:x=(w-text_w)/2:y=h*0.14${ZAMAN},fps=30,format=yuv420p[v]"

# Ses: hız değişirse ses de uyarlanır; yüksek sesli havuz gürültüsü normalize edilir.
SES="[0:a]atempo=${YAVAS},loudnorm=I=-14:TP=-1.5:LRA=11[a]"
if [[ "$YAVAS" != "1" ]] && awk "BEGIN{exit !($YAVAS < 0.5)}"; then
  SES="[0:a]atempo=0.5,atempo=$(awk "BEGIN{print $YAVAS/0.5}"),loudnorm=I=-14:TP=-1.5:LRA=11[a]"
fi

if ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$GIRDI" | grep -q .; then
  ffmpeg -y -ss "$BAS" -t "$SURE" -i "$GIRDI" -filter_complex "${FILTRE};${SES}" \
    -map "[v]" -map "[a]" -c:v libx264 -preset medium -crf 20 -c:a aac -b:a 160k -movflags +faststart "$CIKTI"
else
  ffmpeg -y -ss "$BAS" -t "$SURE" -i "$GIRDI" -filter_complex "${FILTRE}" \
    -map "[v]" -c:v libx264 -preset medium -crf 20 -movflags +faststart "$CIKTI"
fi

echo "Hazır: $CIKTI"
