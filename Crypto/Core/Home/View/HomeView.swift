//
//  HomeView.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: HomeView เป็นมุมมองหลักในแอปพลิเคชัน SwiftUI ที่แสดงรายการเหรียญดิจิทัลทั้งหมดหรือเฉพาะเหรียญในพอร์ตโฟลิโอของผู้ใช้ มุมมองนี้รวมถึงการจัดการการแสดงผลพอร์ตโฟลิโอ การค้นหาเหรียญ และการนำทางไปยังรายละเอียดของเหรียญที่เลือก

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel // เชื่อมต่อกับ HomeViewModel
    @State private var showPortfolio: Bool = false // สลับการแสดงผลพอร์ตโฟลิโอ
    @State private var showPortfolioView: Bool = false // สลับแสดงหน้าต่างพอร์ตโฟลิโอ
    @State private var showSettingsView: Bool = false // สลับแสดงหน้าต่างตั้งค่า
    @State private var selectedCoin: CoinModel? = nil // เหรียญที่เลือกในปัจจุบัน
    @State private var showDetailView: Bool = false // สลับการแสดงผลหน้ารายละเอียดเหรียญ
    
    var body: some View {
        ZStack {
            // MARK: background layer
            // ใช้สีพื้นหลังจากธีมและแสดงหน้าต่างพอร์ตโฟลิโอเมื่อ showPortfolioView เป็นจริง
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            
            // MARK: content layer
            // จัดเรียงเนื้อหาในแนวตั้งด้วย VStack รวมถึงหัวเรื่อง สถิติ แถบค้นหา และรายการเหรียญ
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    ZStack(alignment: .top) {
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                            portfolioEmptyText
                        } else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView, content: {
                SettingsView()
            })
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() })
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    
    // MARK: เลเยอร์เนื้อหา
    private var homeHeader: some View {
        
        // จัดการการแสดงผลของหัวเรื่องและปุ่มนำทางสำหรับการสลับมุมมองพอร์ตโฟลิโอ
        HStack {
            
            // ปุ่มนำทางและการจัดการสลับมุมมอง
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    // MARK: รายการเหรียญทั้งหมดและพอร์ตโฟลิโอ
    private var allCoinsList: some View {
        
        // แสดงรายการเหรียญทั้งหมดหรือเหรียญในพอร์ตโฟลิโอโดยใช้ List และ CoinRowView
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    // MARK: ส่วนข้อความเมื่อพอร์ตโฟลิโอว่าง
    private var portfolioCoinsList: some View {
        
        // แสดงรายการเหรียญทั้งหมดหรือเหรียญในพอร์ตโฟลิโอโดยใช้ List และ CoinRowView
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    // MARK: ส่วนข้อความเมื่อพอร์ตโฟลิโอว่าง
    private var portfolioEmptyText: some View {
        
        // แสดงข้อความเมื่อพอร์ตโฟลิโอว่างเปล่า
        Text("You haven't added any coins to your portfolio yet. Click the + button to get started! 🧐")
            .font(.callout)
            .foregroundColor(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    // MARK: การจัดการการนำทางไปยังหน้ารายละเอียดเหรียญ
    private func segue(coin: CoinModel) {
        // ฟังก์ชันสำหรับจัดการการนำทางไปยังหน้ารายละเอียดเหรียญเมื่อเลือกเหรียญ
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    // MARK: ส่วนหัวของคอลัมน์
    private var columnTitles: some View {
        HStack {
            // MARK: Coin Column
            // แสดงชื่อ "Coin" พร้อมสัญลักษณ์ chevron.down ซึ่งจะแสดงตามสถานะการจัดเรียง (เรียงตามลำดับหรือย้อนลำดับ)
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            // การแตะที่คอลัมน์จะเปลี่ยนสถานะการจัดเรียงเป็น .rank หรือ .rankReversed
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            // MARK: Holdings Column (Visible only if showPortfolio is true)
            // แสดงเฉพาะเมื่อ showPortfolio เป็นจริง
            if showPortfolio {
                HStack(spacing: 4) {
                    // แสดงชื่อ "Holdings" พร้อมสัญลักษณ์ chevron.down เช่นเดียวกับคอลัมน์ Coin
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                // การแตะที่คอลัมน์จะเปลี่ยนสถานะการจัดเรียงเป็น .holdings หรือ .holdingsReversed
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            
            // MARK: Price Column
            HStack(spacing: 4) {
                
                // แสดงชื่อ "Price" พร้อมสัญลักษณ์ chevron.down และจัดเรียงอยู่ทางด้านขวา
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
            // การแตะที่คอลัมน์จะเปลี่ยนสถานะการจัดเรียงเป็น .price หรือ .priceReversed
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            
            // MARK: Reload Button
            // เมื่อกดปุ่มจะทำการรีโหลดข้อมูลใหม่พร้อมกับแอนิเมชันการหมุนของไอคอน goforward
            Button(action: {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            // การหมุนของไอคอนจะถูกควบคุมโดยสถานะ isLoading ของ HomeViewModel
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        // มีการตั้งค่าระยะขอบแนวนอน
        .padding(.horizontal)
    }

    
}
