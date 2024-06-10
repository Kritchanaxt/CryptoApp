//
//  Color.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: โค้ดนี้กำหนด extension สำหรับ struct Color ใน SwiftUI ซึ่งมี static properties สองตัว (theme และ launch) ที่อ้างอิงถึง instances ของ ColorTheme และ LaunchTheme ตามลำดับ เหล่าทีมสีเหล่านี้จะแพ็กเกจสีต่าง ๆ ที่ใช้ในแอปพลิเคชันไว้

import Foundation
import SwiftUI

extension Color {
    
    // MARK: สร้าง property static เพื่อ initialize instance ของ ColorTheme
    // ซึ่งประกอบด้วยค่าสีต่าง ๆ
    // ซึ่งถูกกำหนดใช้กับ assets สีชื่อ "AccentColor", "BackgroundColor", "GreenColor", "RedColor", และ "SecondaryTextColor" ตามลำดับ
    static let theme = ColorTheme()
    
    // MARK: สร้าง property static นี้ initialize instance ของ LaunchTheme
    // ซึ่งประกอบด้วยสีที่เฉพาะเจาะจงสำหรับขั้นตอนการเริ่มต้นของแอปพลิเคชัน (accent และ background) 
    // ซึ่งถูกกำหนดใช้กับ assets สี "LaunchAccentColor" และ "LaunchBackgroundColor" ตามลำดับ
    static let launch = LaunchTheme()
    
}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    
}

struct ColorTheme2 {
    let accent = Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))
    let background = Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
    let green = Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
    let red = Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))
    let secondaryText = Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))
}

struct LaunchTheme {
    
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
    
}
