import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    // MARK: - Properties
    private let session: WCSession

    // MARK: - Initializer
    override init() {
        self.session = WCSession.default
        super.init()
        setupSession()
    }

    // MARK: - Setup WCSession
    private func setupSession() {
        guard WCSession.isSupported() else {
            print("WatchConnectivity is not supported on this device.")
            return
        }

        session.delegate = self
        session.activate()
        print("WCSession activated successfully.")
    }

    // MARK: - Send Data to iPhone
    func sendMoodToPhone(mood: String) {
        guard session.isReachable else {
            print("iPhone is not reachable. Unable to send mood.")
            return
        }

        session.sendMessage(["mood": mood], replyHandler: nil, errorHandler: { error in
            print("Error sending mood: \(error.localizedDescription)")
        })
    }

    // MARK: - WCSessionDelegate Methods
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive.")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated. Activating a new session...")
        WCSession.default.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let response = message["response"] as? String {
            print("Received response from iPhone: \(response)")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
}
