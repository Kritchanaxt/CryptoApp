//
//  CoinRowView.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: CoinRowView จะแสดงข้อมูลเหรียญในแถวเดียว พร้อมตัวเลือกการแสดงข้อมูลการถือครองเหรียญ.

import SwiftUI

struct CoinRowView: View {
    
    // ใช้สำหรับการแสดงหรือซ่อนคอลัมน์กลาง.
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        // ใช้เพื่อจัดเรียงองค์ประกอบในแนวนอน โดยมีการแยกเป็นคอลัมน์ซ้าย, กลาง (ถ้ามี), และขวา.
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        
        // ใช้ background สีโปร่งแสงเพื่อให้สามารถคลิกได้.
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
}

// สร้างตัวอย่างที่มีทั้งธีมสว่างและมืด.
struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)

            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

// ส่วนขยาย CoinRowView เพื่อจัดการคอลัมน์ซ้าย.
extension CoinRowView {
    
    // leftColumn ประกอบด้วย rank ของเหรียญ, รูปเหรียญ, และสัญลักษณ์เหรียญ.
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    // centerColumn แสดงค่าของเหรียญที่ถือครองในรูปแบบค่าเงินและจำนวนเหรียญที่ถือครอง.
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    // rightColumn แสดงราคาปัจจุบันของเหรียญและการเปลี่ยนแปลงราคาใน 24 ชั่วโมงในรูปแบบเปอร์เซ็นต์.
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0 >= 0) ?
                    Color.theme.green :
                    Color.theme.red
                )
        }
        // ตั้งค่า frame ของคอลัมน์ขวาเพื่อให้มีความกว้างที่เหมาะสม.
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
