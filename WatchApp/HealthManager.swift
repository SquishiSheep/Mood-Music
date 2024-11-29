import HealthKit

class HealthManager {
    let healthStore = HKHealthStore()

    func requestAuthorization() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let typesToRead: Set = [heartRateType]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if success {
                print("HealthKit authorization granted")
            } else {
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func startHeartRateQuery(completion: @escaping (Double) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }

        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        ) { _, samples, _ in
            guard let sample = samples?.first as? HKQuantitySample else { return }
            let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            completion(heartRate)
        }
        healthStore.execute(query)
    }
}
