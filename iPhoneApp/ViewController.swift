import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    let musicManager = MusicManager()
    let moodHistoryManager = MoodHistoryManager()
    let notificationManager = NotificationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWatchConnectivity()
        requestNotificationAuthorization()
    }

    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    private func requestNotificationAuthorization() {
        notificationManager.requestAuthorization { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Notifications are enabled.")
                } else {
                    print("Notifications are disabled.")
                }
            }
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let mood = message["mood"] as? String {
            musicManager.playMusic(for: mood)
            moodHistoryManager.addMood(mood)
            notificationManager.sendNotification(for: mood)
        }
    }

    @IBAction func showMoodHistory() {
        let dashboardVC = MoodDashboardViewController()
        navigationController?.pushViewController(dashboardVC, animated: true)
    }
}
