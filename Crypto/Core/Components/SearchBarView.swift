//
//  SearchBarView.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: SearchBarView นี้สร้างช่องค้นหาพร้อมกับไอคอนแว่นขยายและปุ่มล้างข้อความที่สามารถแตะได้เพื่อเคลียร์ข้อความในช่องค้นหา.


import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            // แสดงไอคอนรูปแว่นขยายจากระบบ
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    // ถ้า searchText ว่างเปล่า จะใช้สี secondaryText.
                    searchText.isEmpty ?
                    
                    // ถ้า searchText ไม่ว่างเปล่า จะใช้สี accent.
                    Color.theme.secondaryText : Color.theme.accent
                )
            
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
            
                // ใช้ overlay เพื่อแสดงไอคอน xmark.circle.fill ที่ขอบขวาของ TextField
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            // ตั้งการจัดการแตะ (onTapGesture) ให้ปิดคีย์บอร์ดและเคลียร์ searchText เมื่อไอคอนถูกแตะ.
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //โหมดสีสว่าง (light).
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            // โหมดสีเข้ม (dark).
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)

        }
    }
}
