//
//  CoinDataService.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: คลาส CoinDataService นี้ใช้ในการดาวน์โหลดข้อมูลเหรียญ Crypto ทั้งหมดจาก API ของ CoinGecko โดยใช้ Combine framework เพื่อจัดการกับข้อมูลแบบ asynchronous และอัพเดตข้อมูลที่ได้รับในตัวแปรที่เผยแพร่ allCoins เพื่อให้อ็อบเจกต์อื่น ๆ สามารถรับข้อมูลนี้และอัพเดต UI ได้.

import Foundation
import Combine // ใช้ Combine เพื่อจัดการกับการเรียก API, การประมวลผลข้อมูล

class CoinDataService {
    
    // ตัวแปรที่ใช้เผยแพร่ข้อมูลของเหรียญ Crypto ทั้งหมด
    @Published var allCoins: [CoinModel] = []
    
    // ตัวแปรเก็บ subscription ของ Combine เพื่อจัดการกับการสตรีมข้อมูล.
    var coinSubscription: AnyCancellable?
    
    // อินิเชียลไร์ซ์เมื่อสร้างอ็อบเจกต์ CoinDataService
    init() {
        
        // เรียกฟังก์ชัน getCoins() เพื่อดาวน์โหลดข้อมูลเหรียญ Crypto.
        getCoins()
    }
    
    func getCoins() {
        
        // สร้าง URL สำหรับการร้องขอข้อมูลจาก API โดยใช้ URL ที่ระบุ.
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        // เริ่มการดาวน์โหลดข้อมูลจาก URL ที่ระบุ.
        coinSubscription = NetworkingManager.download(url: url)
        
            // ทำการถอดรหัสข้อมูลที่ดาวน์โหลดได้เป็นอาเรย์ของ CoinModel.
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
        
            // รับข้อมูลบน main thread เพื่ออัพเดต UI.
            .receive(on: DispatchQueue.main)
        
            // สับสไครบ์เพื่อรับข้อมูลที่ดาวน์โหลดมาและจัดการกับความสำเร็จหรือความล้มเหลว:
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                
                // อัพเดตข้อมูลเหรียญ Crypto ที่ได้รับ.
                self?.allCoins = returnedCoins
                
                // ยกเลิก subscription เพื่อป้องกันการใช้งานทรัพยากรโดยไม่จำเป็น.
                self?.coinSubscription?.cancel()
            })
    }
    
}
