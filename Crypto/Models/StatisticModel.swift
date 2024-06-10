//
//  StatisticModel.swift
//  Crypto
//
//  Created by Kritchanat on 13/6/2567 BE.
//

// MARK: โครงสร้าง StatisticModel นี้ใช้เพื่อเก็บข้อมูลสถิติที่ประกอบด้วย title, value และ percentageChange โดยที่แต่ละอ็อบเจกต์จะมี id ที่ไม่ซ้ำกันเพื่อให้สามารถระบุได้ ซึ่งสามารถนำไปใช้งานในแอปพลิเคชันที่ต้องการแสดงผลข้อมูลสถิติได้อย่างมีประสิทธิภาพ.

import Foundation // นำเข้า Foundation framework ซึ่งเป็นพื้นฐานที่สำคัญสำหรับการใช้งาน UUID และ Identifiable.

// กำหนดโครงสร้าง StatisticModel ที่เป็นไปตามโปรโตคอล Identifiable ซึ่งช่วยให้แต่ละอ็อบเจกต์มีเอกลักษณ์ที่สามารถระบุได้.
struct StatisticModel: Identifiable {
    let id = UUID().uuidString // สตริง UUID ที่สุ่มขึ้นมาเพื่อให้แต่ละอ็อบเจกต์มีเอกลักษณ์ที่สามารถระบุได้.
    let title: String // ชื่อของสถิติ.
    let value: String // ค่าเชิงตัวเลขหรือข้อมูลที่เกี่ยวข้องกับสถิติ.
    let percentageChange: Double? // เปอร์เซ็นต์การเปลี่ยนแปลงที่เป็นตัวเลือก (optional) ซึ่งมีค่าเป็น Double.
    
    // อินิเทียลไลเซอร์ที่กำหนดค่าให้กับแต่ละ property:
    init(title: String, value: String, percentageChange: Double? = nil) {
        
        // ชื่อของสถิติ.
        self.title = title
        
        // ค่าเชิงตัวเลขหรือข้อมูลที่เกี่ยวข้องกับสถิติ.
        self.value = value
        
        // เปอร์เซ็นต์การเปลี่ยนแปลงที่เป็นตัวเลือก (มีค่าเป็น Double และสามารถเป็น nil ได้).
        self.percentageChange = percentageChange
    }
}
