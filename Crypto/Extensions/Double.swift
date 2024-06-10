//
//  Double.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: โค้ดที่ให้มาเป็นการสร้าง extension ของ Double ใน Swift ที่เพิ่มฟังก์ชันที่ช่วยในการแปลงค่า Double ให้เป็นรูปแบบที่ต้องการ เช่น แปลงเป็นสกุลเงิน, เลขทศนิยม, และรูปแบบอื่น ๆ ตามที่กำหนดไว้:

import Foundation

extension Double {
    
    // MARK: ฟังก์ชันนี้ใช้สร้าง NumberFormatter ที่ใช้สำหรับแปลง Double เป็นรูปแบบเงินที่มีทศนิยม 2 ตำแหน่ง (เช่น $1,234.56) โดยกำหนดให้ใช้ตัวคั่นหลักและสัญลักษณ์เงินตามการตั้งค่าของ NumberFormatter นี้.
    
    /// Converts a Double into a Currency with 2 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //formatter.locale = .current // <- default value
        //formatter.currencyCode = "usd" // <- change currency
        //formatter.currencySymbol = "$" // <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    // MARK: เมื่อเรียกใช้ฟังก์ชันนี้บนตัวแปร Double จะแปลงค่า Double นั้นเป็นสตริงที่เป็นเงินตามรูปแบบที่กำหนด (ทศนิยม 2 ตำแหน่ง) โดยใช้ currencyFormatter2 ที่ถูกสร้างขึ้นมาก่อนหน้านี้.
    
    /// Converts a Double into a Currency as a String with 2 decimal places
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    /// ```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }

    // MARK: เป็นฟังก์ชันที่ใช้สร้าง NumberFormatter ที่ใช้สำหรับแปลง Double เป็นรูปแบบเงินที่มีทศนิยมระหว่าง 2-6 ตำแหน่ง โดยกำหนดให้ใช้ตัวคั่นหลักและสัญลักษณ์เงินตามการตั้งค่าของ NumberFormatter นี้.
    /// Converts a Double into a Currency with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// Convert 12.3456 to $12.3456
    /// Convert 0.123456 to $0.123456
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //formatter.locale = .current // <- default value
        //formatter.currencyCode = "usd" // <- change currency
        //formatter.currencySymbol = "$" // <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    // MARK: เมื่อเรียกใช้ฟังก์ชันนี้บนตัวแปร Double จะแปลงค่า Double นั้นเป็นสตริงที่เป็นเงินตามรูปแบบที่กำหนด (ทศนิยม 2-6 ตำแหน่ง) โดยใช้ currencyFormatter6 ที่ถูกสร้างขึ้นมาก่อนหน้านี้.
    /// Converts a Double into a Currency as a String with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    /// Convert 12.3456 to "$12.3456"
    /// Convert 0.123456 to "$0.123456"
    /// ```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    // MARK: แปลง Double เป็นสตริงที่มีทศนิยม 2 ตำแหน่ง โดยใช้ String format ใน Swift.
    /// Converts a Double into string representation
    /// ```
    /// Convert 1.2345 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    // MARK: แปลง Double เป็นสตริงที่มีเครื่องหมายเปอร์เซ็นต์ที่สุดของตัวเลข โดยการเรียกใช้ฟังก์ชัน asNumberString() แล้วต่อท้ายด้วยเครื่องหมาย %.
    /// Converts a Double into string representation with percent symbol
    /// ```
    /// Convert 1.2345 to "1.23%"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    // MARK: แปลง Double เป็นสตริงที่มีเครื่องหมายเปอร์เซ็นต์ที่สุดของตัวเลข โดยการเรียกใช้ฟังก์ชัน asNumberString() แล้วต่อท้ายด้วยเครื่องหมาย %
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()

        default:
            return "\(sign)\(self)"
        }
    }

    
}
