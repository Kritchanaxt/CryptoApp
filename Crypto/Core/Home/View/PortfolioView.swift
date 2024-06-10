//
//  PortfolioView.swift
//  Crypto
//
//  Created by Kritchanat on 15/6/2567 BE.
//

// MARK: PortfolioView ช่วยให้ผู้ใช้สามารถค้นหาเหรียญ เลือกเหรียญเพื่อแก้ไขจำนวนที่ถือ และบันทึกการเปลี่ยนแปลงได้ มันมอบอินเตอร์เฟซที่ใช้งานง่ายสำหรับการจัดการพอร์ตโฟลิโอสกุลเงินดิจิทัลด้วยแอนิเมชั่นที่ลื่นไหลและการออกแบบที่สะอาดตา

import SwiftUI

struct PortfolioView: View {
    
    // เชื่อมต่อกับ HomeViewModel
    @EnvironmentObject private var vm: HomeViewModel
    
    // เก็บเหรียญที่เลือกในปัจจุบัน
    @State private var selectedCoin: CoinModel? = nil
    
    // เก็บจำนวนของเหรียญที่ป้อน
    @State private var quantityText: String = ""
    
    // จัดการการแสดงผลของเครื่องหมายถูกหลังจากบันทึก
    @State private var showCheckmark: Bool = false
        
    var body: some View {
        
        // ห่อเนื้อหาหลักใน NavigationView และ ScrollView เพื่อให้มีความสามารถในการนำทางและเลื่อนดู
        NavigationView {
            
            // ใช้ VStack เพื่อจัดเรียงแถบค้นหาและรายการเหรียญในแนวตั้ง
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // รวม SearchBarView ที่ผูกกับ vm.searchText
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .background(
                Color.theme.background
                    .ignoresSafeArea()
            )
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
        
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}


extension PortfolioView {
    
    // รายการโลโก้ของเหรียญ
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            
            // แสดงรายการโลโก้ของเหรียญในแนวนอน
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        // เน้นเหรียญที่เลือกด้วยขอบสีเขียว
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear
                                        , lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        })
    }
    
    // ฟังก์ชันช่วยเหลือ
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    // ฟังก์ชันช่วยเหลือ
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    // ส่วนป้อนข้อมูลพอร์ตโฟลิโอ
    private var portfolioInputSection: some View {
        
        // แสดงช่องป้อนข้อมูลสำหรับราคาปัจจุบันของเหรียญ จำนวนที่ถือ และมูลค่าปัจจุบัน
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    // ปุ่มนำทางด้านบนขวา
    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            // ประกอบด้วยภาพเครื่องหมายถูกและปุ่มบันทึก
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            
            // ปุ่มบันทึกจะปรากฏเฉพาะเมื่อเลือกเหรียญและจำนวนได้เปลี่ยนไป
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ?
                    1.0 : 0.0
            )
        }
        .font(.headline)
    }
    
    // ฟังก์ชันช่วยเหลือ
    private func saveButtonPressed() {
        
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
            else { return }
        
        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
        
    }
    
    // ฟังก์ชันช่วยเหลือ
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
    
}
