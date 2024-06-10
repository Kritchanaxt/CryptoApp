//
//  XMarkButton.swift
//  Crypto
//
//  Created by Kritchanat on 14/6/2567 BE.
//


import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            // เมื่อปุ่มถูกกด (action), จะเรียกใช้ presentationMode.wrappedValue.dismiss() เพื่อปิด View ปัจจุบัน.
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
