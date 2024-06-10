//
//  CoinDetailDataService.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: คลาส CoinDetailDataService นี้ใช้ในการดาวน์โหลดข้อมูลรายละเอียดของเหรียญ Crypto จาก API ของ CoinGecko โดยใช้ Combine framework เพื่อจัดการกับข้อมูลแบบ asynchronous และอัพเดตข้อมูลที่ได้รับในตัวแปรที่เผยแพร่ coinDetails เพื่อให้อ็อบเจกต์อื่น ๆ สามารถรับข้อมูลนี้และอัพเดต UI ได้.

import Foundation
import Combine // ใช้ Combine เพื่อจัดการกับการเรียก API, การประมวลผลข้อมูล

class CoinDetailDataService {
    
    // ตัวแปรที่ใช้เผยแพร่ข้อมูลรายละเอียดของเหรียญ Crypto.
    @Published var coinDetails: CoinDetailModel? = nil
    
    // ตัวแปรเก็บ subscription ของ Combine เพื่อจัดการกับการสตรีมข้อมูล.
    var coinDetailSubscription: AnyCancellable?
    
    // ข้อมูลของเหรียญ Crypto ที่ต้องการดาวน์โหลดรายละเอียด.
    let coin: CoinModel
    
    // อินิเชียลไร์ซ์เมื่อสร้างอ็อบเจกต์ CoinDetailDataService จะรับ CoinModel เพื่อดาวน์โหลดข้อมูลรายละเอียดของเหรียญ Crypto นั้น.
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    // ดาวน์โหลดข้อมูลรายละเอียดของเหรียญ Crypto จาก API
    func getCoinDetails() {
        
        // สร้าง URL สำหรับการร้องขอข้อมูลจาก API โดยใช้ coin.id
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        // เริ่มการดาวน์โหลดข้อมูลจาก URL ที่ระบุ.
        coinDetailSubscription = NetworkingManager.download(url: url)
        
            // ทำการถอดรหัสข้อมูลที่ดาวน์โหลดได้เป็น CoinDetailModel.
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
        
            // รับข้อมูลบน main thread เพื่ออัพเดต UI.
            .receive(on: DispatchQueue.main)
        
            // สับสไครบ์เพื่อรับข้อมูลที่ดาวน์โหลดมาและจัดการกับความสำเร็จหรือความล้มเหลว
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetails) in
                
                // อัพเดตข้อมูลรายละเอียดของเหรียญ Crypto ที่ได้รับ.
                self?.coinDetails = returnedCoinDetails
                
                // ยกเลิก subscription เพื่อป้องกันการใช้งานทรัพยากรโดยไม่จำเป็น.
                self?.coinDetailSubscription?.cancel()
            })
    }
    
}
