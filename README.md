# Yüzme Shorts Kanalı – Büyüme ve Gelir Kiti

YouTube'daki yüzme videolarını, izlenme alan ve para kazandıran **Shorts** içeriklerine dönüştürmek için hazırlanmış pratik bir kit.

| Dosya | İçerik |
|---|---|
| [01-strateji.md](01-strateji.md) | Para kazanma şartları, tutan yüzme kanallarının formülü, kanal konumlandırma, 90 günlük plan |
| [02-shorts-fikirleri.md](02-shorts-fikirleri.md) | Çekmeye hazır 30 Shorts fikri – kanca cümlesi, sahne akışı, süre |
| [03-baslik-aciklama-etiket.md](03-baslik-aciklama-etiket.md) | Başlık kalıpları, açıklama şablonu, hashtag setleri, sabitlenmiş yorum örnekleri |
| [04-cekim-ve-kurgu.md](04-cekim-ve-kurgu.md) | Telefonla havuz çekimi, kurgu kuralları, ses, kapak, yasal/etik uyarılar |
| [araclar/shorts_yap.sh](araclar/shorts_yap.sh) | Elindeki yatay videoyu tek komutla 1080x1920 Shorts'a çeviren script |

## Hızlı başlangıç: ilk Short'u 10 dakikada çıkar

1. [ffmpeg](https://ffmpeg.org/download.html) kur (Windows'ta Git Bash veya WSL ile çalıştır).
2. Mevcut bir yüzme videondan en etkileyici 15–30 saniyeyi seç.
3. Çalıştır:
   ```bash
   ./araclar/shorts_yap.sh havuz.mp4 "Bu hatayı yapan yavaş yüzer" 12 25
   ```
   - Yüzücü kadrajın ortasında değilse: `MOD=blur ./araclar/shorts_yap.sh ...`
   - Su altı / teknik an için ağır çekim: `YAVAS=0.5 ./araclar/shorts_yap.sh ...`
4. Çıkan `*_short.mp4` dosyasını YouTube uygulamasından Shorts olarak yükle, müziği uygulama içinden ekle (telifsiz ve Shorts'ta gelir paylaşımına uygun olur).
5. Başlık/açıklamayı [03-baslik-aciklama-etiket.md](03-baslik-aciklama-etiket.md)'den kopyala.

> Not: Kimse belirli bir izlenme sayısını garanti edemez. Bu kit, büyüyen yüzme kanallarında tekrar tekrar işe yarayan **formatları ve alışkanlıkları** bir araya getirir; asıl fark düzenli yükleme ve analitiğe göre ayar yapmakla oluşur.
