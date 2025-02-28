import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

class ScreenTimeViewModel: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection()

    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    private let userDefaultsKey = "ScreenTimeSelection"
    
    init() {
        // Load saved selection when the view model is initialized
        if let savedSelection = savedSelection() {
            activitySelection = savedSelection
        }
    }

    // saves all the selections passed into activitySelection
    func saveSelection() {
        let defaults = UserDefaults.standard
        if let encodedSelection = try? encoder.encode(activitySelection) {
            defaults.set(encodedSelection, forKey: userDefaultsKey)
        }
    }

    // returns the last selected activities from user Defaults
    func savedSelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: userDefaultsKey) else { return nil }

        if let decodedSelection = try? decoder.decode(FamilyActivitySelection.self, from: data) {
            return decodedSelection
        } else {
            return nil
        }
    }
    
    func endMonitoring() { // stops monitoring screentime for specific pod
        let center = DeviceActivityCenter()
        center.stopMonitoring([DeviceActivityName("TimeApp2025")])
    }
    
    func beginMonitoring() {
        let id = "TimeApp2025"
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
            repeats: true
        )
        
        guard let selection: FamilyActivitySelection = self.savedSelection() else {
            print("beginMonitoring(): saved selection not found")
            return
        }
        
        let event = DeviceActivityEvent(
            applications: selection.applicationTokens,
            categories: selection.categoryTokens,
            webDomains: selection.webDomainTokens,
            threshold: DateComponents(hour: 10)
        )
        
        let center = DeviceActivityCenter()
        
        // monitors screentime for each pod
        let activity = DeviceActivityName(id)
        let eventName = DeviceActivityEvent.Name("ScreenTimeMonitoring")
        
        do {
            try center.startMonitoring(
                activity,
                during: schedule,
                events: [
                    eventName: event
                ]
            )
        } catch {
            print("beginMonitoring(): Error starting ScreenTimeMonitoring")
        }
        
    }
}



class ShieldModel: ObservableObject {
    static let shared: ShieldModel = {
        let instance = ShieldModel()
        instance.selectedActivity = FamilyActivitySelection()
        instance.selectedActivity.applicationTokens = instance.store.shield.applications ?? Set<ApplicationToken>()
        return instance
    }()
    var store = ManagedSettingsStore()
    @Published var selectedActivity = FamilyActivitySelection()
    
    func clearAllLimit() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
    
    func onSelectedChange(_ value: FamilyActivitySelection) {
        
        print("\n已限制应用: \(store.shield.applications?.count ?? 0)个")
        
        // 打印选择的应用信息
        let applications = value.applicationTokens
        if applications.count > 0 {
            print("\n选择的应用: \(applications.count)个")
            store.shield.applications = applications
        } else {
            store.shield.applications = nil
        }
        
        // 打印选择的应用分类信息
        let categories = value.categoryTokens
        if categories.count > 0 {
            print("\n选择的分类: \(categories.count)个")
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories)
        } else {
            store.shield.applicationCategories = nil
        }
        
        // 打印选择的网页域名信息
        let webDomains = selectedActivity.webDomainTokens
        if webDomains.count > 0 {
            print("\n选择的网页域名: \(webDomains.count)个")
            store.shield.webDomains = webDomains
        } else {
            store.shield.webDomains = nil
        }
        
    }
    
}
