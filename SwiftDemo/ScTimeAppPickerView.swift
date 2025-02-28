//
//  ScTimeAppPickerView.swift
//  SwiftDemo
//
//  Created by guopeng on 2025/2/20.
//

import UIKit
import SwiftUI
import FamilyControls
import ManagedSettings

struct ScTimeAppPickerView: View {
    @ObservedObject var model = ScreenTimeViewModel()
    // 使用 @Environment 注入 presentationMode
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            Text("选择应用\(model.activitySelection.applicationTokens.count)个")
            ForEach(Array(model.activitySelection.applicationTokens), id: \.self) { token in
                Label(token)
            }
            
            Text("选择域名\(model.activitySelection.webDomainTokens.count)个")
            ForEach(Array(model.activitySelection.webDomainTokens), id: \.self) { token in
                Label(token)
            }
            
            FamilyActivityPicker(
                headerText: "选择活动类别",
                footerText: "请根据家庭的需要选择活动",
                selection: $model.activitySelection
            )
            
            .onChange(of: model.activitySelection) { newValue, oldValue in
                
            }
            
            HStack {
                Spacer()
                Button(action: {
                    // 点击按钮时关闭当前模态视图
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("取消")
                }.frame(width: 100, height: 36)
                Spacer()
                Button(action: {
                    model.saveSelection()
                    model.beginMonitoring()
                    // 点击按钮时关闭当前模态视图
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存并退出")
                }.frame(width: 100, height: 36)
                Spacer()
            }
            
        }
        
    }
}
