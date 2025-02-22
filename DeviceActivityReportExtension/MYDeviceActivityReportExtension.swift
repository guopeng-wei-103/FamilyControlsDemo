//
//  DeviceActivityReportExtension.swift
//  DeviceActivityReportExtension
//
//  Created by guopeng on 2025/2/22.
//

import DeviceActivity
import SwiftUI

@main
struct MYDeviceActivityReportExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
