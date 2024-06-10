//
//  CryptoApp.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//


import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    init() {
        // ตั้งค่าลักษณะการแสดงผลของ UINavigationBar
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)] // ถูกตั้งค่าเพื่อกำหนดสีของข้อความเป็นสี accent ที่กำหนดในธีม
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)] // ถูกตั้งค่าเพื่อกำหนดสีของข้อความเป็นสี accent ที่กำหนดในธีม
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent) // ถูกตั้งค่าสีสำหรับไอคอนต่างๆ ในแถบการนำทาง
        UITableView.appearance().backgroundColor = UIColor.clear // ถูกตั้งค่าเป็นสีโปร่งใส
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // สร้าง NavigationView สำหรับ HomeView
                NavigationView {
                    HomeView()
                        // ซ่อนแถบการนำทาง
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                // เพื่อให้ HomeView และมุมมองอื่นๆ สามารถเข้าถึง HomeViewModel ได้
                .environmentObject(vm)

                ZStack {
                    // แสดง LaunchView เมื่อแอปเปิด
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading)) // ใช้ transition(.move(edge: .leading)) เพื่อเพิ่มเอฟเฟกต์การเปลี่ยนมุมมองเมื่อ LaunchView ปรากฏหรือหายไป

                    }
                }
                .zIndex(2.0) // ใช้ zIndex(2.0) เพื่อให้แน่ใจว่า LaunchView จะอยู่ด้านบนสุดของ HomeView
            }
        }
    }
}
