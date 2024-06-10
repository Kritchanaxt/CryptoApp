//
//  CircleButtonAnimationView.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: โค้ดนี้เป็นการสร้างวิวที่เป็นวงกลมและสามารถทำแอนิเมชันการปรับขนาดและความโปร่งใสได้ โดยควบคุมผ่านตัวแปร animate.

import SwiftUI

struct CircleButtonAnimationView: View {
    
    // ใช้ในการเชื่อมโยงค่าระหว่างวิวสองตัว (ใช้สำหรับรับค่า animate).
    @Binding var animate: Bool
    
    var body: some View {
        
        // สร้างวงกลม (Circle).
        Circle()
            // ใช้เพื่อวาดขอบของวงกลมด้วยความหนา 5.0.
            .stroke(lineWidth: 5.0)
            
            // ใช้เพื่อปรับขนาดของวงกลมตามค่าของ animate
            .scale(animate ? 1.0 : 0.0)
        
            // ใช้เพื่อปรับความโปร่งใสของวงกลมตามค่าของ animate
            .opacity(animate ? 0.0 : 1.0)
        
            // ใช้เพื่อกำหนดแอนิเมชันสำหรับการเปลี่ยนแปลงขนาดและความโปร่งใส.
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
            .foregroundColor(.red)
            .frame(width: 100, height: 100)
    }
}
