//
//  HomeStatsView.swift
//  Crypto
//
//  Created by Kritchanat on 15/6/2567 BE.
//

// MARK: HomeStatsView เป็นวิวที่แสดงสถิติในรูปแบบแนวนอน โดยมีการปรับตำแหน่งของสถิติให้แสดงทางซ้ายหรือขวาตามค่า showPortfolio.

import SwiftUI

struct HomeStatsView: View {
    
    // เชื่อมต่อกับ HomeViewModel ที่เก็บข้อมูลสถิติต่างๆ ผ่าน EnvironmentObject.
    @EnvironmentObject private var vm: HomeViewModel
    
    // ตัวแปรที่ถูกผูกให้แสดงหรือซ่อนพอร์ตโฟลิโอ ซึ่งสามารถเปลี่ยนแปลงค่าได้จากภายนอก.
    @Binding var showPortfolio: Bool
    
    var body: some View {
        
        // ใช้ HStack เพื่อจัดเรียงสถิติในแนวนอน.
        HStack {
            
            // ใช้ ForEach เพื่อวนลูปผ่าน vm.statistics และสร้าง StatisticView สำหรับแต่ละสถิติ โดยตั้งค่าความกว้างของแต่ละ StatisticView เป็น 1 ใน 3 ของความกว้างหน้าจอ.
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        // ตั้งค่า frame ของ HStack ให้มีความกว้างเท่ากับความกว้างหน้าจอและจัดแนว alignment ตามค่า showPortfolio.
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        // ใช้สำหรับการแสดงตัวอย่างของ HomeStatsView ใน Xcode.
        HomeStatsView(showPortfolio: .constant(false))
           
            // สร้างตัวอย่าง HomeStatsView โดยตั้งค่า showPortfolio เป็น false และเชื่อมต่อกับ homeVM ผ่าน environmentObject.
            .environmentObject(dev.homeVM)
    }
}
