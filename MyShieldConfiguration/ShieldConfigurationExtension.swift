//
//  ShieldConfigurationExtension.swift
//  MyShieldConfiguration
//
//  Created by guopeng on 2025/2/22.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        print("Shield application:\(application.localizedDisplayName ?? "")")
        return super.configuration(shielding: application)
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        print("Shield application:\(application.localizedDisplayName ?? "")")
        return super.configuration(shielding: application, in: category)
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        print("Shield webDomain:\(webDomain.domain ?? "")")
        return super.configuration(shielding: webDomain)
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        print("Shield webDomain:\(webDomain.domain ?? "")")
        return super.configuration(shielding: webDomain, in: category)
    }
}
