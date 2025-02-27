//
//  ScTimeAppPickerView.swift
//  SwiftDemo
//
//  Created by guopeng on 2025/2/20.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct ScTimeAppPickerView: View {
    @ObservedObject var model = MyModel()
    
    var body: some View {
        
        VStack {
            Label("Activity", systemImage: "star.fill")
                        .labelStyle(IconOnlyLabelStyle())
                        .padding()
            
            FamilyActivityPicker(
                headerText: "选择活动类别",
                footerText: "请根据家庭的需要选择活动",
                selection: $model.selectedActivity
            )
            
        }
        
    }
}

class MyModel: ObservableObject {
    static let shared: MyModel = {
        let instance = MyModel()
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
        let webDomains = selectedActivity.webDomains
        if webDomains.count > 0 {
            print("\n选择的网页域名: \(webDomains.count)个")
        }
        
    }
    
}
