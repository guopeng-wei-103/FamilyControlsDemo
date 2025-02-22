//
//  ViewController.swift
//  SwiftDemo
//
//  Created by guopeng on 2025/1/21.
//

import UIKit
import SwiftUI
import FamilyControls
import Foundation
import ManagedSettingsUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .red
        
        view.addSubview(clearLimitButton)
        view.addSubview(setupButton)
        view.addSubview(countLabel)
        
        refreshInLoop()
    }
    
    func refreshInLoop() {
        if let limitedApplications = MyModel.shared.store.shield.applications {
            countLabel.text = "已限制应用（或分组、域名）\(limitedApplications.count)个"
        } else {
            countLabel.text = "已限制应用（或分组、域名） 0 个"
        }
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { [weak self] in
            self?.refreshInLoop()
        }
    }
    
    lazy var countLabel: UILabel = {
        let label = UILabel.init(frame: CGRect(x: 0, y: 100, width: 375, height: 50))
        label.textAlignment = .center
        return label
    }()
    
    lazy var clearLimitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 150, y: 500, width: 80, height: 40))
        button.setTitle("清空限制", for: .normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        return button
    }()
    
    lazy var setupButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 150, y: 400, width: 80, height: 40))
        button.setTitle("开始设置", for: .normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(beginSetup), for: .touchUpInside)
        return button
    }()
    
    
    @objc func beginSetup() {
        // 创建包含 familyActivityPicker 的 SwiftUI 视图
        let swiftUIView = ScTimeAppPickerView()
        // 使用 UIHostingController 包装 SwiftUI 视图
        let hostingController = UIHostingController(rootView: swiftUIView)
        self.present(hostingController, animated: true)
    }
    
    @objc func clearAll() {
        MyModel.shared.clearAllLimit()
        countLabel.text = "已限制应用（或分组、域名）数量 0 个"
    }
}
