# Aurio planı

Aurio, [SimpMusic](https://github.com/maxrave-dev/SimpMusic)'in (GPL-3.0) Kotlin fork'udur.
Eski Musike tabanlı sürüm `musike-legacy` dalında duruyor.

Bu dosya Aurio'ya özeldir. Repodaki diğer `.md` dosyaları SimpMusic'ten gelir.

## 0. Kurallar

- **SimpMusic'ten otomatik güncelleme alınmaz.** Proje sahibi "güncelleme var mı?" diye sorunca
  `git fetch upstream` ile yeni değişikliklere bakılır, ne geldiği anlatılır; birleştirme ancak onay sonrası.
- **Diller:** yalnızca İngilizce ve Türkçe.
- **Platform önceliği:** iPhone ve web en önemli. Sonra macOS ve Windows. Android ikinci planda.

## 1. Fork'ta şimdiye kadar değişenler

| Ne | Nerede |
|---|---|
| Uygulama adı "Aurio" | `composeResources/values*/strings.xml`, `app_name.xml` |
| Android uygulama kimliği `com.emiraneren.aurio` | `androidApp/build.gradle.kts`, manifest, `shortcuts.xml` |
| Masaüstü görünen ad, rdns adı, yayıncı | `desktopApp/build.gradle.kts`, `conveyor.conf` |
| "Resmî olmayan kopya" kilit ekranı kapatıldı | `MainActivity.kt` |
| GitHub Actions sadece elle çalışır; SimpMusic'in PR botu silindi | `.github/workflows/` |
| Diller İngilizce + Türkçe'ye indirildi (diğer 27 dil silindi, dil seçicide sadece ikisi var) | `composeResources/`, `SettingScreen.kt`, `locale_config.xml` |

Bilerek değiştirilmeyenler: Kotlin paket adları (`com.maxrave…`), SimpMusic'in servis adları
(SimpMusic Lyrics, Charts), `core` alt modülü (hâlâ `maxrave-dev/core`).

## 2. Platform durumu

| Platform | Durum |
|---|---|
| macOS bilgisayar | **Var.** SimpMusic'in masaüstü sürümü macOS'ta çalışıyor (macOS 15 ve üstü). |
| Windows | **Var.** |
| Android | **Var.** |
| iPhone | **Yok.** Aşağıda madde P1. |
| Web tarayıcı | **Yok.** Aşağıda madde P2. |

### Neden iPhone ve web zor? (kodda ölçüldü)

**iPhone:** Arayüz ve iş mantığı büyük ölçüde ortak kodda (Compose Multiplatform), bu iyi haber.
`core` modüllerinin çoğunda iOS hedefi zaten tanımlı. Eksik olan üç büyük parça var:
1. **Ses/video çalar yok.** Android Media3, masaüstü mpv kullanıyor; ikisi de iOS'ta çalışmaz.
   Masaüstü çalar yaklaşık 6.800 satır. iOS için AVPlayer üzerine yeni bir çalar yazılmalı
   (arka planda çalma, kilit ekranı kontrolleri, sıra, geçiş).
2. **YouTube akış çözücü yok.** Akış adresini bulan PipePipe kütüphanesi Java'dır, iOS'ta çalışmaz.
   iOS için ayrı bir çözücü gerekir (Musike'nin iOS uygulamasındaki Swift çözücü burada örnek olur).
3. **Platforma özel kod.** `composeApp` içinde 47, `core` içinde 20 `expect` tanımı var; her birine
   iOS karşılığı yazılmalı (dosya seçme, paylaşma, bildirim, ayarlar…).
4. **Araç:** Bu Mac'te Xcode kurulu değil (sadece komut satırı araçları var). iPhone'a kurmak için
   Xcode ve en azından ücretsiz Apple ID gerekir; App Store'a koymak için yıllık 99$ geliştirici hesabı
   (kaynak: Apple Developer Program fiyatı, bilgim dahilinde; doğrulanmalı).

**Web:** Tarayıcı, güvenlik kuralı (CORS) yüzünden YouTube Music'in API'sine doğrudan istek atamaz.
Bu yüzden web sürümü tek başına çalışamaz, **arada bir sunucu şart**. Musike'nin Node sunucusu ve
Docker'ı bu işi yapıyordu. Ayrıca Aurio'nun veritabanı (Room) ve çalarları tarayıcıda çalışmıyor.

## 3. Eklenebilecek özellikler (karar proje sahibinin)

Zorluk ve süre benim tahminim, ölçülmüş değil.

### Platformlar

| # | İş | Zorluk | Not |
|---|---|---|---|
| P1 | **iPhone uygulaması** | Çok büyük | Önce Xcode kurulumu. Sıra: iOS hedefini açıp derlemek → AVPlayer çalar → akış çözücü → eksik `expect`'ler. |
| P2a | **Web: Aurio sunucusu + Musike'nin web arayüzü** | Büyük | Aurio'nun Kotlin çekirdeğini bir sunucu (Ktor) olarak çalıştırıp, Musike'nin hazır React arayüzünü ona bağlamak. Docker ile kendi sunucunda çalışır. En hızlı web yolu. |
| P2b | **Web: Compose ile aynı arayüz tarayıcıda (wasm) + sunucu** | Çok büyük | Arayüz Aurio ile birebir aynı olur ama veritabanı ve çalar tarayıcı için yeniden yazılmalı; sunucu yine gerekir. |
| P3 | iPad ve Mac için iOS uygulaması (iPhone uygulamasıyla aynı kod) | Küçük, P1'den sonra | |

### Musike'den gelecek özellikler

| # | Özellik | Zorluk |
|---|---|---|
| M1 | Liste ile arama (virgülle birçok şarkı, en iyi eşleşme, hepsini listeye ekle) | Kolay–orta |
| M2 | Masaüstü klavye kısayolları (boşluk, oklar, F, `?` yardım ekranı) | Kolay |
| M3 | Sinema modu (videoyu büyütme, kontrollerin solması) | Kolay; mevcut tam ekranla karşılaştırılmalı |
| M4 | Android TV (SimpMusic'in `feat/android-tv` dalı incelenerek) | Orta |

### Aurio'ya özel iyileştirmeler

| # | İş | Zorluk | Not |
|---|---|---|---|
| A1 | **Türkçe çevirinin tamamlanması** | Kolay | İngilizce 1045 metin var, Türkçe 619. Eksik 426 metin şu an İngilizce görünüyor. |
| A2 | Uygulama içi güncelleme kontrolünü SimpMusic yerine Aurio'nun sürümlerine yönlendirmek ya da kapatmak | Kolay | Şu an büyük olasılıkla SimpMusic'in sürümlerini öneriyor (doğrulanmadı). |
| A3 | `vivoAndroidApp` modülünü kaldırmak | Kolay | Uygulamayı Spotify'ın kimliğiyle (`com.spotify.music`) derliyor; Aurio'da olmamalı. |
| A4 | Aurio logosu ve simgesi | Kolay–orta | Şu an SimpMusic'in simgeleri duruyor. |
| A5 | `core` alt modülünü kendi hesabına fork'lamak | Kolay | iOS çalışması `core` içinde değişiklik gerektirecek; şu an orası SimpMusic'in reposu. |

## 4. Açık riskler

- **Lisans:** GPL-3.0. Kaynak kod açık kalmalı, SimpMusic kaynak olarak belirtilmeli.
- **SimpMusic'e katkı:** SimpMusic, yapay zekâ ile yazılmış ya da `Co-Authored-By: Claude` satırı taşıyan
  PR'ları otomatik kapatıyor.
- **YouTube kullanım koşulları:** Uygulama YouTube içeriğini reklamsız çekiyor; kişisel kullanım içindir.
- **Dil silme ve güncellemeler:** Silinen 27 dil dosyası, SimpMusic'ten güncelleme alınırken
  "silindi / değişti" çakışması çıkarabilir; o dosyalar yine silinerek çözülür.
