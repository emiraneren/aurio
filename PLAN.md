# Aurio planı

Aurio, [SimpMusic](https://github.com/maxrave-dev/SimpMusic)'in (GPL-3.0) Kotlin fork'udur.
Eski Musike tabanlı sürüm `musike-legacy` dalında duruyor.

Bu dosya Aurio'ya özeldir. Repodaki diğer `.md` dosyaları (README, CLAUDE.md, CONTRIBUTING…)
SimpMusic'ten gelir ve onlara ait kuralları anlatır.

## 1. Fork'ta şimdiye kadar değişenler

| Ne | Nerede |
|---|---|
| Uygulama adı "Aurio" (30 dilde arayüz metinleri) | `composeResources/values*/strings.xml`, `app_name.xml` |
| Android uygulama kimliği `com.emiraneren.aurio` (SimpMusic'in yanına ayrı uygulama olarak kurulur) | `androidApp/build.gradle.kts`, manifest, `shortcuts.xml` |
| Masaüstü görünen ad, rdns adı, yayıncı | `desktopApp/build.gradle.kts`, `conveyor.conf` |
| "Resmî olmayan kopya" kilit ekranı kapatıldı (SimpMusic yalnızca kendi paket adını ve imzasını tanıyor) | `MainActivity.kt` |
| GitHub Actions sadece elle çalışır, push'ta derleme yok; SimpMusic'in PR botu silindi | `.github/workflows/` |

Bilerek değiştirilmeyenler:
- Kotlin paket adları (`com.maxrave.simpmusic…`): değiştirmek SimpMusic'ten güncelleme almayı imkânsızlaştırır.
- SimpMusic'in kendi servislerinin adları: "SimpMusic Lyrics", "SimpMusic Charts", simpmusic.org.
- `core` alt modülü hâlâ `maxrave-dev/core`'u gösteriyor. Orada değişiklik gerekirse önce o repo fork'lanmalı.

## 2. Musike'nin kullandığı API'ler: SimpMusic'te karşılığı var mı?

| Musike'de | SimpMusic'te | Sonuç |
|---|---|---|
| youtubei.js (Innertube): arama, sanatçı, albüm, türler | `kotlinYtmusicScraper` (kendi Innertube istemcisi) | Var, ekleme gerekmez |
| yt-dlp + Deno: akış adresi ve imza çözme | PipePipe/NewPipe + QuickJS ile cihazda çözme, yedek olarak api.pipepipe.dev ve BravePipe | Var, daha gelişmiş |
| `streaming.json`: uzaktan istemci ayarları | `player_configs.json` kayıt dosyası (simpmusic-files ve Metrolist faraday) | Var |
| FFmpeg: HD video ile sesi birleştirme | Android'de Media3 MergingMediaSource, masaüstünde mpv EDL | Var |
| YouTube Music türler/ruh hâli | Var (Moods & Genres) | Var |
| Sanatçının resmî klibini bulma | `counterpart` ile şarkı/video geçişi | Kısmen (sadece giriş yapılmışken) |
| iOS yerel çözücü (iOS istemcisiyle akış alma) | Yok, SimpMusic'in iOS uygulaması yok | Eksik, ancak iOS hedefi açılırsa anlamlı |
| yt-dlp sürüm kontrolü (GitHub API) | Gerek yok, yt-dlp kullanılmıyor | Gereksiz |

Sonuç: Musike'nin kullandığı API'lerden SimpMusic'e eklenmesi gereken bir şey yok. Hepsinin
karşılığı var ya da daha gelişmiş bir karşılığı var. Tek istisna iOS, o da aşağıda ayrı madde.

## 3. Musike'de olup SimpMusic'te olmayan özellikler

Kodda arayarak bulundu (`grep`). Zorluk benim tahminim.

| # | Özellik | SimpMusic'teki durum | Zorluk | Not |
|---|---|---|---|---|
| 1 | **Liste ile arama** (virgülle birçok şarkı, en iyi eşleşme, toplu çalma listesine ekleme) | Yok | Kolay–orta | Arama ekranına yeni bir mod. Mevcut arama API'si yeterli. |
| 2 | **Masaüstü klavye kısayolları** (boşluk = çal/duraklat, oklar, F = sinema modu, `?` yardım) | Sadece mini oynatıcıda tuş dinleme var | Kolay | `jvmMain` içinde pencere seviyesinde `onPreviewKeyEvent`. |
| 3 | **Android TV** (TV başlatıcısında görünme, kumanda ile gezinme, büyük arayüz) | Ana dalda yok; SimpMusic'te `feat/android-tv` adlı geliştirme dalı var | Orta | Önce o dalın durumuna bakmak, belki onu birleştirmek mantıklı. |
| 4 | **Sinema modu** (videoyu büyütme, kontrollerin solması) | Tam ekran video var | Kolay | Muhtemelen mevcut tam ekranla büyük ölçüde örtüşüyor. Önce denenmeli. |
| 5 | **Tarayıcıda çalışma (PWA) / Docker ile kendi sunucunda çalıştırma** | Yok | Çok zor | Compose'un web hedefi (wasmJs) var ama Media3, mpv ve Room orada çalışmaz. Pratikte ayrı bir proje. |
| 6 | **iPhone uygulaması** | Kodda iOS hedefi var ama kapalı; oynatıcı ve arayüz iOS'a yazılmamış | Çok zor | Ses çalma (AVPlayer) ve iOS'a özel her şey sıfırdan yazılmalı. Ayrıca Apple geliştirici hesabı ve Mac ile Xcode gerekir. |

Musike'de olup SimpMusic'te zaten bulunanlar (eklemeye gerek yok): yedekleme/geri yükleme,
tema ve vurgu rengi, türler, sanatçı ve albüm sayfaları, otomatik radyo, YouTube linkiyle açma,
medya tuşları, Türkçe (SimpMusic'te 619 Türkçe metin var).

## 4. Önerilen sıra

1. Derleme ortamını kur (JDK 21 + Android Studio), Aurio'yu telefonda ve masaüstünde bir kez çalıştır.
2. Liste ile arama (madde 1).
3. Masaüstü klavye kısayolları (madde 2).
4. Android TV: önce SimpMusic'in `feat/android-tv` dalını incele (madde 3).
5. iOS ve web/Docker: ancak gerçekten istenirse; ayrı ve büyük işler.

Sırayı ve neyin ekleneceğini proje sahibi belirler.

## 5. Açık riskler ve yapılacak kontroller

- **Güncelleme kontrolü:** Uygulama içindeki "güncellemeleri kontrol et" büyük olasılıkla
  SimpMusic'in sürümlerine bakıyor (`checkForUpdate`, `core` içinde). Kullanıcıyı SimpMusic'i
  indirmeye yönlendirebilir. Doğrulanmadı; kapatılmalı ya da Aurio'nun sürümlerine yönlendirilmeli.
- **`vivoAndroidApp` modülü** uygulamayı `com.spotify.music` kimliğiyle derliyor (vivo telefonlardaki
  bir özellik için Spotify'ın kimliğini kullanıyor). Aurio bu modülü derlememeli ve dağıtmamalı.
  Kaldırılması düşünülebilir.
- **Lisans:** GPL-3.0. Aurio'nun kaynak kodu açık kalmalı, SimpMusic kaynak olarak belirtilmeli.
- **SimpMusic'e katkı:** SimpMusic, yapay zekâ ile yazılmış ya da `Co-Authored-By: Claude` satırı
  taşıyan PR'ları otomatik kapatıyor. Aurio'daki bir değişikliği SimpMusic'e göndermek için kodun
  insan tarafından satır satır gözden geçirilmesi ve bu satırların temizlenmesi gerekir.
- **Ana projeden güncelleme alma:** `git fetch upstream && git merge upstream/main`. Çakışma en çok
  `strings.xml` dosyalarında (Aurio adı) çıkar.
