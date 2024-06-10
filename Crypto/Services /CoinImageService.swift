//
//  CoinImageService.swift
//  Crypto
//
//  Created by Kritchanat on 13/6/2567 BE.
//

// MARK: คลาสนี้ใช้ในการดาวน์โหลดและจัดเก็บภาพของเหรียญ Crypto จาก URL และบันทึกลงในระบบไฟล์ท้องถิ่น โดยใช้ Combine framework เพื่อจัดการกับข้อมูลแบบ asynchronous และ LocalFileManager เพื่อการจัดการกับไฟล์ท้องถิ่นที่จัดเก็บภาพของเหรียญ Crypto ได้เป็นอย่างดีแล้วในการใช้งานประจำวันในแอปพลิเคชัน

import Foundation
import SwiftUI
import Combine // ใช้ Combine เพื่อจัดการกับการเรียก API, การประมวลผลข้อมูล

class CoinImageService {
    
    // ตัวแปรที่ใช้เผยแพร่เพื่อเก็บภาพของเหรียญ Crypto ที่ดาวน์โหลดมา.
    @Published var image: UIImage? = nil
    
    // ตัวแปรเก็บ subscription ของ Combine เพื่อจัดการกับการสตรีมข้อมูล.
    private var imageSubscription: AnyCancellable?
    
    // ข้อมูลของเหรียญ Crypto ที่ใช้ในการดาวน์โหลดภาพ.
    private let coin: CoinModel
    
    // อ็อบเจกต์ LocalFileManager เพื่อจัดการกับไฟล์ท้องถิ่น.
    private let fileManager = LocalFileManager.instance
    
    // ชื่อโฟลเดอร์ที่ใช้เก็บภาพของเหรียญ Crypto.
    private let folderName = "coin_images"
    
    // ชื่อภาพของเหรียญ Crypto ที่จะใช้เป็นชื่อไฟล์.
    private let imageName: String
    
    // อินิเชียลไร์ซ์เมื่อสร้างอ็อบเจกต์ CoinImageService จะรับ CoinModel เพื่อดาวน์โหลดภาพของเหรียญ Crypto นั้น.
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    // ตรวจสอบว่ามีภาพของเหรียญ Crypto นี้อยู่ในระบบไฟล์ท้องถิ่นหรือไม่ ถ้ามีจะใช้ภาพที่ถูกบันทึกไว้ ถ้าไม่มีจะดาวน์โหลดภาพ.
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    // ดาวน์โหลดภาพของเหรียญ Crypto จาก URL และจัดการกับข้อมูลที่ได้รับผ่าน Combine:
    private func downloadCoinImage() {
        
        // เริ่มการดาวน์โหลดข้อมูลจาก URL ที่ระบุ.
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            // ทำการถอดรหัสข้อมูลที่ดาวน์โหลดได้เป็น UIImage.
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            
            // รับข้อมูลบน main thread เพื่ออัพเดต UI.
            .receive(on: DispatchQueue.main)
        
            // สับสไครบ์เพื่อรับข้อมูลที่ดาวน์โหลดมาและจัดการกับความสำเร็จหรือความล้มเหลว:
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                
                // อัพเดตภาพที่ดาวน์โหลดได้.
                self.image = downloadedImage
                
                // ยกเลิก subscription เพื่อป้องกันการใช้งานทรัพยากรโดยไม่จำเป็น.
                self.imageSubscription?.cancel()
                
                // บันทึกภาพลงในระบบไฟล์ท้องถิ่น.
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
    
}
