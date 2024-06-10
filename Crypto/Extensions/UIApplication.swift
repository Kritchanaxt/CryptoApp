//
//  UIApplication.swift
//  Crypto
//
//  Created by Kritchanat on 13/6/2567 BE.
//

// MARK: โค้ดนี้เป็นการเพิ่ม extension ให้กับ UIApplication เพื่อให้สามารถเรียกใช้ฟังก์ชั่น endEditing() ที่จะช่วยยกเลิกการแก้ไขของ UIResponder ทุกตัว ซึ่งมีประโยชน์ในการปิดคีย์บอร์ดเมื่อผู้ใช้เสร็จสิ้นการพิมพ์ใน TextField หรือ TextView โดยไม่ต้องระบุ View ใด ๆ โดยเฉพาะ

/*
 
 MARK: พารามิเตอร์ของ sendAction:
 #selector(UIResponder.resignFirstResponder): ตัวเลือก (selector) ที่จะถูกเรียกใช้ เป็นการบอกให้ UIResponder ที่เป็น first responder ยกเลิกการตอบสนอง (resign first responder)
 to: nil: ส่งไปยังผู้รับที่ไม่ระบุ (nil) หมายถึงส่งไปยังทุก ๆ UIResponder ในแอปพลิเคชัน
 from: nil: ตัวส่ง action (nil) หมายถึงไม่ระบุว่ามาจากใคร
 for: nil: เหตุการณ์ที่เป็นต้นเหตุ (nil) หมายถึงไม่ระบุเหตุการณ์
 
 */

import Foundation
import SwiftUI

// การสร้าง extension สำหรับ UIApplication ซึ่งเป็นคลาสหลักที่ใช้จัดการกับการทำงานทั่วไปของแอปพลิเคชัน
extension UIApplication {
    
    // ฟังก์ชั่นนี้ไม่มีพารามิเตอร์และไม่มีค่าผลลัพธ์
    func endEditing() {
        // เรียกใช้ sendAction กับ #selector(UIResponder.resignFirstResponder) ซึ่งเป็นการส่ง action เพื่อยกเลิกการเป็น first responder ของทุก UIResponder (เช่น TextField, TextView) ในแอปพลิเคชัน
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
