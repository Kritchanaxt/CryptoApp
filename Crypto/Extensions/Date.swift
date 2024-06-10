//
//  Date.swift
//  Crypto
//
//  Created by Kritchanat on 13/6/2567 BE.
//

// MARK: โค้ดนี้ช่วยในการจัดการกับวันที่ในรูปแบบต่าง ๆ โดยสามารถแปลงจาก string ที่มาจาก CoinGecko API เป็น Date และแสดงผลเป็นวันที่แบบย่อได้ง่าย

import Foundation

extension Date {
    
    // "2021-03-13T20:49:26.606Z"
    // MARK: initializer ที่ใช้สำหรับสร้าง Date object จาก string ที่มีรูปแบบเฉพาะที่มาจาก CoinGecko API
    init(coinGeckoString: String) {
        
        // ใช้ DateFormatter เพื่อกำหนดรูปแบบของวันที่ที่ต้องการแปลงจาก string ไปเป็น Date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // ในกรณีที่ไม่สามารถแปลง string เป็น Date ได้ (เช่น string ไม่ตรงกับ format ที่กำหนด) จะสร้าง Date object ด้วยค่า default ซึ่งก็คือปัจจุบัน.
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        
        // เป็น computed property ที่ใช้สร้าง DateFormatter ที่ตั้งค่าให้แสดงผลเป็นวันที่แบบย่อ (short date style).
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    // MARK: เป็น method ที่ใช้แปลง Date object ให้เป็นสตริงที่เป็นวันที่แบบย่อโดยใช้ shortFormatter ที่ถูกสร้างขึ้นมาก่อนหน้า.
    func asShortDateString() -> String {
        
        // คืนค่าเป็นสตริงที่เป็นวันที่แบบย่อ (เช่น "6/15/21" สำหรับวันที่ 15 มิถุนายน ปี 2021).
        return shortFormatter.string(from: self)
    }
    
}
