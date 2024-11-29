import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    let musicManager = MusicManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let mood = message["mood"] as? String {
            musicManager.playMusic(for: mood)
        }
    }
}
