//
//  MarketDataService.swift
//  Crypto
//
//  Created by Kritchanat on 13/6/2567 BE.
//

// MARK: คลาส MarketDataService นี้ใช้ในการดึงข้อมูลตลาดจาก API และอัพเดตข้อมูลใน marketData โดยใช้ Combine framework เพื่อจัดการกับการสตรีมข้อมูลแบบ asynchronous.

import Foundation
import Combine // ใช้ Combine เพื่อจัดการกับการเรียก API, การประมวลผลข้อมูล

// สร้างคลาส MarketDataService สำหรับการดึงข้อมูลตลาด.
class MarketDataService {
    
    // ตัวแปรที่เผยแพร่เพื่อเก็บข้อมูลตลาดที่ดึงมา.
    @Published var marketData: MarketDataModel? = nil
    
    // ตัวแปรเก็บ subscription ของ Combine เพื่อจัดการกับการสตรีมข้อมูล.
    var marketDataSubscription: AnyCancellable?
    
    // เรียกใช้ฟังก์ชัน
    init() {
        getData()
    }
    
    func getData() {
        // ตรวจสอบและสร้าง URL จากสตริง.
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        // เริ่มการดาวน์โหลดข้อมูลจาก URL ที่ระบุ.
        marketDataSubscription = NetworkingManager.download(url: url)
        
            // ถอดรหัสข้อมูลที่ได้รับจาก JSON เป็น GlobalData.
            .decode(type: GlobalData.self, decoder: JSONDecoder())
        
            // รับข้อมูลบน main thread เพื่ออัพเดต UI.
            .receive(on: DispatchQueue.main)
        
            // สับสไครบ์เพื่อรับข้อมูลที่ดึงมาและจัดการกับความสำเร็จหรือความล้มเหลว.
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {
                [weak self] (returnedGlobalData) in 
                // [weak self]: ใช้เพื่อหลีกเลี่ยง strong reference cycles.

                // อัพเดตข้อมูลตลาดที่ได้รับ.
                self?.marketData = returnedGlobalData.data
                
                // ยกเลิก subscription เพื่อป้องกันการใช้งานทรัพยากรโดยไม่จำเป็น.
                self?.marketDataSubscription?.cancel()
            })
    }
    
}
