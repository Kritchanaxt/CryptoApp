//
//  CoinImageView.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//


import SwiftUI

struct CoinImageView: View {
    
    // ถูกใช้เพื่อสร้างและจัดการวงจรชีวิตของ CoinImageViewModel ที่ใช้สำหรับการโหลดภาพของเหรียญ
    @StateObject var vm: CoinImageViewModel
    
    // สร้าง ViewModel พร้อมกับเหรียญที่ระบุ
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            
            // ถ้ามีภาพ (vm.image) ให้แสดงภาพโดยใช้ Image(uiImage: image) และกำหนดให้ภาพสามารถปรับขนาดได้ (resizable()) และคงอัตราส่วนภาพ 
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
                // ถ้ากำลังโหลดภาพ (vm.isLoading) ให้แสดง ProgressView แทน
            } else if vm.isLoading {
                ProgressView()
                
                // ถ้าไม่มีภาพและไม่ได้กำลังโหลด แสดงสัญลักษณ์เครื่องหมายคำถาม
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
