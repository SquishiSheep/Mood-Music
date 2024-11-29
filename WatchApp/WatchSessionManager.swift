import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    var session: WCSession

    override init() {
        self.session = WCSession.default
        super.init()
        session.delegate = self
        session.activate()
    }

    func sendMoodToPhone(mood: String) {
        if session.isReachable {
            session.sendMessage(["mood": mood], replyHandler: nil, errorHandler: { error in
                print("Error sending mood: \(error)")
            })
        }
    }
}
