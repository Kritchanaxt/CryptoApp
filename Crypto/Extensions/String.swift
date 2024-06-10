//
//  String.swift
//  Crypto
//
//  Created by Kritchanat on 13/6/2567 BE.
//

// MARK: โค้ดนี้เป็นการเพิ่ม extension ให้กับ String เพื่อเพิ่มฟังก์ชัน removingHTMLOccurances ที่จะลบ HTML tags ออกจากสตริง ซึ่งมีประโยชน์ในการทำความสะอาดข้อมูลข้อความที่ได้รับมาจาก HTML หรือเว็บไซต์ต่าง ๆ

import Foundation

// การสร้าง extension สำหรับ String ซึ่งเป็นคลาสหลักที่ใช้จัดการกับ String ใน Swift
extension String {
    // การเพิ่ม computed property ที่คืนค่าเป็นสตริงที่ลบ HTML tags ทั้งหมดออกแล้ว
    var removingHTMLOccurances: String {
        
        /*
         
         MARK: ใช้ replacingOccurrences(of:with:options:range:) เพื่อลบ HTML tags
         of: "<[^>]+>": กำหนดแพทเทิร์นของ HTML tags โดยใช้ regular expression <[^>]+>
         with: "": แทนที่ HTML tags ด้วยสตริงว่าง (ลบออก)
         options: .regularExpression: ใช้ regular expression เป็นออปชั่น
         range: nil: ใช้ช่วง (range) ทั้งหมดของสตริง
         
         */
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
