import Capacitor
import UIKit
import WebKit

/// The app's web view: Capacitor's own, plus the two bridges iOS needs that Android has in its Java code —
/// the lock screen (AurioPlayback) and resolving a stream URL (AurioYouTube).
final class AurioWebViewController: CAPBridgeViewController {
    private let playback = AurioPlayback()
    private let youtube = AurioYouTube()
    private let audio = AurioAudio()

    override func capacitorDidLoad() {
        super.capacitorDidLoad()
        // Capacitor replaces the web view's userContentController after the configuration is built, so the handlers
        // are added here, once the web view exists.
        webView?.configuration.userContentController.add(playback, name: "aurioMedia")
        webView?.configuration.userContentController.add(youtube, name: "aurioResolve")
        webView?.configuration.userContentController.add(audio, name: "aurioAudio")
        playback.attach(webView)
        youtube.attach(webView)
        audio.attach(webView)
        // Swipe from the left edge goes back, like the Android back button: dialogs close, then pages.
        webView?.allowsBackForwardNavigationGestures = true
    }
}
