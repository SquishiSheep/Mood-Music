class MoodDetector {
    func detectMood(heartRate: Double, hrv: Double, activity: String) -> String {
        if heartRate > 100 && hrv < 20 {
            return "Stressed"
        } else if activity == "Running" {
            return "Energetic"
        } else if heartRate < 60 {
            return "Relaxed"
        } else {
            return "Neutral"
        }
    }

    func startBiometricQuery(completion: @escaping (Double, Double) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate),
            let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return }

        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        ) { _, samples, _ in
            guard let heartRateSample = samples?.first as? HKQuantitySample else { return }
            let heartRate = heartRateSample.quantity.doubleValue(for: HKUnit(from: "count/min"))

            let hrvQuery = HKSampleQuery(
                sampleType: hrvType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
            ) { _, samples, _ in
                guard let hrvSample = samples?.first as? HKQuantitySample else { return }
                let hrv = hrvSample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                completion(heartRate, hrv)
            }
            self.healthStore.execute(hrvQuery)
        }
        healthStore.execute(query)
    }

}
