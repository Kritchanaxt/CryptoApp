//
//  ChartView.swift
//  Crypto
//
//  Created by Kritchanat on 14/6/2567 BE.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double] // ข้อมูลราคาที่จะนำมาแสดงบนกราฟ.
    private let maxY: Double // ค่าสูงสุดในข้อมูล data.
    private let minY: Double // ค่าต่ำสุดในข้อมูล data.
    private let lineColor: Color // สีของเส้นกราฟ.
    private let startingDate: Date // วันที่เริ่มต้นของช่วงเวลาแสดงผลกราฟ.
    private let endingDate: Date
    // วันที่สิ้นสุดของช่วงเวลาแสดงผลกราฟ.
    
    @State private var percentage: CGFloat = 0 // ค่าร้อยละที่ใช้ควบคุมการแสดงผลกราฟแบบแอนิเมชัน.
    
    init(coin: CoinModel) {
        // รับ coin เป็นพารามิเตอร์.
        data = coin.sparklineIn7D?.price ?? []
        
        // กำหนดค่าให้กับ data, maxY, และ minY.
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        // คำนวณการเปลี่ยนแปลงราคาจากค่าแรกและค่าสุดท้ายใน data และกำหนด lineColor เป็นสีเขียวถ้าราคาเพิ่มขึ้น และสีแดงถ้าราคาลดลง.
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        // กำหนด endingDate จากข้อมูลวันที่อัพเดตล่าสุดของเหรียญและ startingDate เป็น 7 วันก่อนหน้านั้น.
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        // จัดเรียงแนวตั้ง.
        VStack {
            
            // กราฟเส้นที่แสดงข้อมูล data มีความสูง 200 และมีพื้นหลังเป็น
            chartView
                .frame(height: 200)
                .background(chartBackground)
               
                // ป้ายแกน Y ที่แสดงค่าต่ำสุด, สูงสุด, และค่ากลาง.
                .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            
            // ป้ายวันที่ที่แสดงวันที่เริ่มต้นและสิ้นสุด.
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        
        // ใช้ onAppear เพื่อเรียกใช้งานแอนิเมชันของกราฟเมื่อวิวปรากฏ
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    
    private var chartView: some View {
        
        // ใช้ GeometryReader เพื่อให้สามารถวัดขนาดวิวได้.
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    
                    // วาดกราฟเส้นด้วย Path โดยคำนวณตำแหน่ง x และ y สำหรับแต่ละจุดใน data
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                }
            }
            // ใช้ .trim และ .stroke เพื่อสร้างเส้นกราฟพร้อมแอนิเมชัน.
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            
            // เพิ่มเงาให้กับเส้นกราฟ.
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }
    }
    
    private var chartBackground: some View {
        // สร้างพื้นหลังของกราฟโดยใช้ VStack และ Divider เพื่อแบ่งกราฟเป็นสามส่วน.
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        // สร้างป้ายแกน Y โดยแสดงค่าต่ำสุด, สูงสุด, และค่ากลางของข้อมูล.
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        // สร้างป้ายวันที่โดยใช้ HStack แสดงวันที่เริ่มต้นและสิ้นสุดของข้อมูล.
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
    
}
