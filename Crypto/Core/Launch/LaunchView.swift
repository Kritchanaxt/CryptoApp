//
//  LaunchView.swift
//  Crypto
//
//  Created by Kritchanat on 15/6/2567 BE.
//

// MARK: โค้ดนี้เกี่ยวกับการจัดการการโหลดข้อความและการแสดงมุมมองการเปิดตัว (launch view) ในแอปพลิเคชัน

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your portfolio...".map { String($0) }
    @State private var showLoadingText: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.accent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
                
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                
                // กำหนดค่า lastIndex ให้เป็นดัชนีสุดท้ายของอาร์เรย์ loadingText ซึ่งคำนวณโดยการลบ 1 ออกจากความยาวทั้งหมดของ loadingText เนื่องจากดัชนีเริ่มต้นที่ 0.
                let lastIndex = loadingText.count - 1
                
                // ดูว่าถึงจุดสิ้นสุดของ loadingText หรือยัง.
                if counter == lastIndex {
                    
                    // ถ้าเงื่อนไขเป็นจริง, รีเซ็ตตัวแปร counter ให้เป็น 0 เพื่อเริ่มต้นนับใหม่.
                    counter = 0
                    
                    // เพิ่มค่าของตัวแปร loops ขึ้นทีละ 1 เพื่อบันทึกจำนวนรอบที่ได้วนครบทั้งหมด.
                    loops += 1
                    
                    // ตรวจสอบว่าตัวแปร loops มีค่ามากกว่าหรือเท่ากับ 2 หรือไม่, ถ้าใช่, ตั้งค่าตัวแปร showLaunchView เป็น false เพื่อซ่อนมุมมองการเปิดตัว.
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    // ถ้าไม่เป็นจริง, เพิ่มค่าของตัวแปร counter ขึ้นทีละ 1 เพื่อย้ายไปยังดัชนีถัดไปของ loadingText.
                    counter += 1
                }
            }
        })
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
