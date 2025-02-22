//
//  BluetoothManager.swift
//  SwiftDemo
//
//  Created by guopeng on 2025/2/19.
//

import UIKit
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        
        // 订阅特征的通知
        // connectedPeripheral.setNotifyValue(true, for: characteristic)
    }

    // 蓝牙状态变化的回调
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("蓝牙开启")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        case .poweredOff:
            print("蓝牙关闭")
        case .unauthorized:
            print("蓝牙未授权")
        case .unsupported:
            print("设备不支持蓝牙")
        default:
            break
        }
    }

    // 扫描到设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        print("发现设备：\(peripheral.name ?? "未知设备")")
        if peripheral.name == "guopeng的MacBook Pro" {
            centralManager.stopScan()
            connectedPeripheral = peripheral
            centralManager.connect(peripheral, options: nil)
        }
    }

    // 连接成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("连接成功：\(peripheral.name ?? "未知设备")")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    // 连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接失败：\(error?.localizedDescription ?? "未知错误")")
    }
}

extension BluetoothManager {
    // 发现设备的服务
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("发现服务失败：\(error?.localizedDescription ?? "未知错误")")
            return
        }
        
        for service in peripheral.services ?? [] {
            print("发现服务：\(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    // 发现特征
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("发现特征失败：\(error?.localizedDescription ?? "未知错误")")
            return
        }

        for characteristic in service.characteristics ?? [] {
            print("发现特征：\(characteristic.uuid)")
            // 读取或订阅特征
            peripheral.readValue(for: characteristic)
        }
    }
}

extension BluetoothManager {
    // 读取特征值
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("读取特征值失败：\(error?.localizedDescription ?? "未知错误")")
            return
        }
        
        if let value = characteristic.value {
            print("读取到特征值：\(value)")
        }
    }

    // 写入特征值
    func writeData(to peripheral: CBPeripheral, characteristic: CBCharacteristic, data: Data) {
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
        print("写入数据：\(data)")
    }
}
