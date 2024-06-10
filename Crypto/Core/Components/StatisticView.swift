//
//  StatisticView.swift
//  Crypto
//
//  Created by Kritchanat on 14/6/2567 BE.
//


import SwiftUI

struct StatisticView: View {
    
    // ประกาศตัวแปรคงที่ stat ซึ่งเป็นแบบ StatisticModel. ตัวแปรนี้จะใช้เพื่อเก็บข้อมูลสถิติที่จะแสดง.
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            // แสดงชื่อของสถิติ
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            
            // แสดงค่าของสถิติ
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            
            HStack(spacing: 4) {
                // แสดงรูปสามเหลี่ยม
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                  
                    // MARK: ตั้งค่าหมุนของรูป
                    // ถ้า percentageChange มีค่าเท่ากับหรือมากกว่า 0, จะไม่หมุนรูป (0 องศา).
                    // ถ้า percentageChange น้อยกว่า 0, จะหมุนรูป 180 องศา.
                    .rotationEffect(
                        Angle(degrees:(stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                
                // แสดงค่า percentageChange เป็นสตริงเปอร์เซ็นต์ (asPercentString()).
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    // ตัวหนา
                    .bold()
            }
            // MARK: ตั้งสีข้อความของ HStack
            // ถ้า percentageChange มีค่าเท่ากับหรือมากกว่า 0, จะใช้สีเขียว (green) จากธีม.
            // ถ้า percentageChange น้อยกว่า 0, จะใช้สีแดง (red) จากธีม.
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            
            // MARK: ตั้งค่าความทึบแสง (opacity):
            // ถ้า percentageChange เป็น nil, ความทึบแสงจะเป็น 0.0 (มองไม่เห็น).
            // ถ้า percentageChange ไม่เป็น nil, ความทึบแสงจะเป็น 1.0 (มองเห็นได้ชัดเจน).
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

// สร้างตัวอย่าง (previews) ของ StatisticView เพื่อแสดงตัวอย่างการใช้งานในโหมดแสงสว่างและโหมดเข้ม.
struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.stat1)
                // ตั้งค่า previewLayout เป็น .sizeThatFits เพื่อให้ตัวอย่างขนาดพอดี.
                .previewLayout(.sizeThatFits)
            
                // ตั้งค่า preferredColorScheme เป็น .dark สำหรับตัวอย่างบางส่วนเพื่อแสดงในโหมดเข้ม.
                .preferredColorScheme(.dark)
            StatisticView(stat: dev.stat2)
                // ตั้งค่า previewLayout เป็น .sizeThatFits เพื่อให้ตัวอย่างขนาดพอดี.
                .previewLayout(.sizeThatFits)
            StatisticView(stat: dev.stat3)
                // ตั้งค่า previewLayout เป็น .sizeThatFits เพื่อให้ตัวอย่างขนาดพอดี.
                .previewLayout(.sizeThatFits)
            
                // ตั้งค่า preferredColorScheme เป็น .dark สำหรับตัวอย่างบางส่วนเพื่อแสดงในโหมดเข้ม.
                .preferredColorScheme(.dark)
        }
    }
}
