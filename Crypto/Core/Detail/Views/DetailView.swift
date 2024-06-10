//
//  DetailView.swift
//  Crypto
//
//  Created by Kritchanat on 14/6/2567 BE.
//

import SwiftUI

struct DetailLoadingView: View {
    
    // ใช้ในการเชื่อมโยงค่าระหว่างวิวสองตัว (ใช้สำหรับรับค่า coin).
    @Binding var coin: CoinModel?

    var body: some View {
        ZStack {
            
            // ตรวจสอบว่ามีค่า coin หรือไม่ ถ้ามี จะสร้าง DetailView พร้อมส่งค่า coin.
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
    
}

struct DetailView: View {
    
    // ใช้สร้างและเก็บสถานะของวัตถุที่สืบทอดจาก ObservableObject.
    @StateObject private var vm: DetailViewModel
    @State private var showFullDescription: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    // รับ coin เป็นพารามิเตอร์.
    init(coin: CoinModel) {
        // กำหนด vm เป็น StateObject ที่ห่อหุ้ม DetailViewModel ด้วยค่า coin.
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)

                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                }
                .padding()
            }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
        
        // ตั้งค่าชื่อของ navigation เป็นชื่อของเหรียญ
        .navigationTitle(vm.coin.name)
        .toolbar {
            // กำหนดปุ่มเครื่องมือใน navigation bar.
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

// ส่วนขยายของ DetailView ที่เพิ่มฟังก์ชันเพิ่มเติม.
extension DetailView {
    
    // ฟังก์ชัน navigationBarTrailingItems สร้างปุ่มและข้อความในแถบเครื่องมือของ navigation bar.
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    // ฟังก์ชัน overviewTitle สร้างหัวข้อ "Overview" ที่มีฟอนต์แบบ title, ตัวหนา, และสี accent.
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // ฟังก์ชัน additionalTitle สร้างหัวข้อ "Additional Details" ที่มีฟอนต์แบบ title, ตัวหนา, และสี accent.
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // ฟังก์ชัน descriptionSection สร้างส่วนที่แสดงคำอธิบายของเหรียญ:
    private var descriptionSection: some View {
        ZStack {
            
            // ถ้ามีคำอธิบาย (coinDescription) และไม่ว่างเปล่า จะแสดงข้อความและปุ่ม "Read more..".
            if let coinDescription = vm.coinDescription,
               !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)

                    // ปุ่มสามารถเปลี่ยนสถานะ showFullDescription เมื่อถูกกด เพื่อแสดงหรือซ่อนคำอธิบายเพิ่มเติม.
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Less" : "Read more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    // ฟังก์ชัน overviewGrid สร้างกริดแนวตั้งที่แสดงสถิติภาพรวมโดยใช้ LazyVGrid.
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
        })
    }
    
    // ฟังก์ชัน additionalGrid สร้างกริดแนวตั้งที่แสดงสถิติเพิ่มเติมโดยใช้ LazyVGrid.
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
        })
    }
    
    // ฟังก์ชัน websiteSection สร้างส่วนที่แสดงลิงก์ไปยังเว็บไซต์และ Reddit ของเหรียญ
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // ถ้ามี URL ของเว็บไซต์หรือ Reddit จะสร้างลิงก์ที่สามารถคลิกได้.
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            
            if let redditString = vm.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
            
        }
        // กำหนดสีลิงก์เป็นสีน้ำเงิน (accentColor) และฟอนต์เป็น headline.
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
}
