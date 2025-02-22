//
//  MyShieldConfigurationDataSource.swift
//  SwiftDemo
//
//  Created by guopeng on 2025/2/22.
//

import Foundation
import ManagedSettings
import ManagedSettingsUI

@available(iOS 15.0, *)
class MyShieldConfigurationDataSource: ShieldConfigurationDataSource {
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // 返回为应用程序提供的屏蔽配置
        let shieldConfig = super.configuration(shielding: application)
        // 在此可以为应用设置时间限制或其他配置
        print("为应用配置屏蔽：\(application.localizedDisplayName ?? "未知应用")")
        return shieldConfig
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // 根据应用的类别返回屏蔽配置
        let shieldConfig = ShieldConfiguration()
        print("为应用类别配置屏蔽：\(category.localizedDisplayName ?? "未知类别")")
        return shieldConfig
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // 为网站提供屏蔽配置
        let shieldConfig = ShieldConfiguration()
        print("为网站配置屏蔽：\(webDomain.domain ?? "未知域名")")
        return shieldConfig
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // 为网站和类别提供屏蔽配置
        let shieldConfig = ShieldConfiguration()
        print("为网站类别配置屏蔽：\(category.localizedDisplayName ?? "未知类别")")
        return shieldConfig
    }
}
