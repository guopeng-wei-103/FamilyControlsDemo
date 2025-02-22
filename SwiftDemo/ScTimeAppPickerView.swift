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
    @State private var showPicker = false
    @ObservedObject var model = MyModel()

    var body: some View {
        VStack {
            
            Spacer()

            Button("选择应用") {
                showPicker = true
            }
           .familyActivityPicker(isPresented: $showPicker, selection: $model.selectedActivity)

            Spacer()

        }
        .onChange(of: model.selectedActivity) { oldValue, newValue in
           MyModel.shared.onSelectedChange(newValue)
        }
        
        // Display selected applications
        if !model.selectedActivity.applications.isEmpty {
            VStack {
                Text("选择的应用:\(model.selectedActivity.applications.count)个")
            }
        }
        
        // Display selected categories
        if !model.selectedActivity.categories.isEmpty {
            VStack {
                Text("选择的分类:\(model.selectedActivity.categories.count)个")
            }
        }
        
        // Display selected web domains
        if !model.selectedActivity.webDomains.isEmpty {
            VStack {
                Text("选择的网页域名:\(model.selectedActivity.webDomains.count)个")
            }
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
