import HealthKit

class HealthManager {
    private let healthStore = HKHealthStore()

    // MARK: - Request HealthKit Authorization
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Health data is not available on this device."]))
            return
        }

        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(false, NSError(domain: "HealthKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "Heart rate data type is not available."]))
            return
        }

        let typesToRead: Set = [heartRateType]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            completion(success, error)
        }
    }

    // MARK: - Start Heart Rate Query
    func startHeartRateQuery(completion: @escaping (Double?, Error?) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion(nil, NSError(domain: "HealthKit", code: 3, userInfo: [NSLocalizedDescriptionKey: "Heart rate data type is not available."]))
            return
        }

        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        ) { _, samples, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let sample = samples?.first as? HKQuantitySample else {
                completion(nil, NSError(domain: "HealthKit", code: 4, userInfo: [NSLocalizedDescriptionKey: "No heart rate data available."]))
                return
            }

            let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            completion(heartRate, nil)
        }
        healthStore.execute(query)
    }
}
