//
//  CoinImageViewModel.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: คลาส CoinImageViewModel นี้ใช้เพื่อจัดการการโหลดและการแสดงภาพของเหรียญ โดยใช้ Combine เพื่อสมัครรับข้อมูลจากบริการที่โหลดภาพ (CoinImageService) และอัปเดตสถานะการโหลดและภาพตามข้อมูลที่ได้รับ.

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    // MARK: ประกาศตัวแปร @Published สองตัวเพื่อให้ SwiftUI สามารถสังเกตการเปลี่ยนแปลงค่าได้
    // เป็นตัวแปรแบบ UIImage? (อาจเป็น nil) สำหรับเก็บภาพของเหรียญ.
    @Published var image: UIImage? = nil
    // เป็นตัวแปรแบบ Bool เพื่อแสดงสถานะการโหลดข้อมูล (เริ่มต้นเป็น false).
    @Published var isLoading: Bool = false
    
    // ประกาศตัวแปร coin และ dataService เป็น let เนื่องจากค่าของพวกมันจะไม่เปลี่ยนแปลงหลังจากถูกกำหนด.
    private let coin: CoinModel
    private let dataService: CoinImageService
    
    // ประกาศ cancellables เป็นเซ็ตของ AnyCancellable เพื่อเก็บการสมัครรับข้อมูลที่สามารถยกเลิกได้.
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        // กำหนดค่า coin จากพารามิเตอร์ที่รับเข้ามา.
        self.coin = coin
        
        // สร้างอินสแตนซ์ของ CoinImageService โดยส่ง coin ให้กับมัน.
        self.dataService = CoinImageService(coin: coin)
        
        // เรียกใช้ฟังก์ชัน addSubscribers() เพื่อสมัครรับข้อมูลจาก dataService.
        self.addSubscribers()
        
        // กำหนดค่า isLoading เป็น true เพื่อแสดงสถานะการโหลดข้อมูล.
        self.isLoading = true
    }
    
    private func addSubscribers() {
        
        // ใช้ dataService.$image ซึ่งเป็น Published ของ image ใน CoinImageService.
        dataService.$image
        
            // ใช้ sink เพื่อรับค่าที่ส่งมาจาก dataService
            .sink { [weak self] (_) in
                
                // ตั้ง isLoading เป็น false ทันทีเมื่อได้รับข้อมูล (แม้จะยังไม่ได้รับภาพ).
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                
                // กำหนดค่า image ให้เป็นภาพที่ได้รับ.
                self?.image = returnedImage
            }
            // ใช้เพื่อเก็บการสมัครรับข้อมูลนี้ใน cancellables เพื่อให้สามารถยกเลิกได้ในภายหลัง.
            .store(in: &cancellables)
        
    }
    
}
