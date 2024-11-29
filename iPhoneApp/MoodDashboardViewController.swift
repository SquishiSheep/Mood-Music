import UIKit

class MoodDashboardViewController: UIViewController {
    let moodHistoryManager = MoodHistoryManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        displayMoodHistory()
    }

    func displayMoodHistory() {
        let moodHistory = moodHistoryManager.getMoodHistory()
        let historyLabel = UILabel(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 400))
        historyLabel.numberOfLines = 0
        historyLabel.textAlignment = .left
        historyLabel.text = moodHistory.map { "\($0.date): \($0.mood)" }.joined(separator: "\n")
        view.addSubview(historyLabel)
    }
}
