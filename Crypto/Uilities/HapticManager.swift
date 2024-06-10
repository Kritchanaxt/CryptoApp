//
//  HapticManager.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: การใช้ Haptic Feedback ช่วยให้ผู้ใช้รับรู้ถึงสถานะหรือการกระทำต่าง ๆ ในแอปพลิเคชันผ่านการสั่นสะเทือน ทำให้มีประสบการณ์การใช้งานที่ดียิ่งขึ้น.

import Foundation
import SwiftUI

// สร้างคลาส HapticManager ซึ่งจะใช้ในการจัดการ Haptic Feedback.
class HapticManager {
    
    // MARK: UINotificationFeedbackGenerator ใช้ในการสร้างฟีดแบ็คการสั่นสะเทือนของการแจ้งเตือน.
    // สร้างตัวแปร generator แบบ static และ private ของประเภท UINotificationFeedbackGenerator.
    static private let generator = UINotificationFeedbackGenerator()
    
    // สร้างฟังก์ชัน notification แบบ static ซึ่งรับพารามิเตอร์ type ที่เป็นประเภท UINotificationFeedbackGenerator.FeedbackType.
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        
        // ฟังก์ชันนี้เรียกใช้เมธอด notificationOccurred ของ UINotificationFeedbackGenerator เพื่อสร้างฟีดแบ็คการสั่นสะเทือนตามประเภทที่กำหนด.
        generator.notificationOccurred(type)
    }
    
}

/*
 MARK: วิธีการใช้งาน
 - สามารถเรียกใช้ Haptic Feedback ได้ง่าย ๆ โดยเรียกฟังก์ชัน HapticManager.notification
 พร้อมกับระบุประเภทของฟีดแบ็คที่ต้องการ เช่น:

 HapticManager.notification(type: .success)
 HapticManager.notification(type: .warning)
 HapticManager.notification(type: .error)

 .success: สั่นสะเทือนเมื่อมีการดำเนินการที่สำเร็จ.
 .warning: สั่นสะเทือนเมื่อมีการเตือน.
 .error: สั่นสะเทือนเมื่อเกิดข้อผิดพลาด.
 
 */
