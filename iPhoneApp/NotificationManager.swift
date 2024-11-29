import UserNotifications

class NotificationManager {
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Notification authorization granted")
            } else {
                print("Notification authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
            completion(success)
        }
    }

    func sendNotification(for mood: String) {
        let content = UNMutableNotificationContent()
        content.title = "Mood Update"
        content.body = "You seem to be feeling \(mood). Here's some music to match your mood!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            } else {
                print("Notification sent successfully for mood: \(mood)")
            }
        }
    }
}
