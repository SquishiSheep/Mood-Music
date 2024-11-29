import Foundation

class MoodHistoryManager {
    private var moodHistory: [(date: Date, mood: String)] = []

    func addMood(_ mood: String) {
        moodHistory.append((date: Date(), mood: mood))
    }

    func getMoodHistory() -> [(date: Date, mood: String)] {
        return moodHistory
    }
}
