//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Kritchanat on 13/6/2567 BE.
//

// MARK: คลาสนี้ทำหน้าที่จัดการพอร์ตโฟลิโอโดยการเพิ่ม, อัปเดต, และลบเหรียญจาก Core Data รวมถึงการดึงข้อมูลพอร์ตโฟลิโอทั้งหมด.

import Foundation
import CoreData // ใช้สำหรับการจัดการข้อมูลและใช้ Core Data.

// สร้างคลาส PortfolioDataService สำหรับการจัดการพอร์ตโฟลิโอ.
class PortfolioDataService {
    
    // ตัวแปรเก็บข้อมูล Persistent Container สำหรับ Core Data.
    private let container: NSPersistentContainer
    
    // ชื่อของ Persistent Container.
    private let containerName: String = "PortfolioContainer"
    
    // ชื่อของ Entity ที่ใช้ใน Core Data.
    private let entityName: String = "PortfolioEntity"
    
    // ตัวแปรที่เผยแพร่เพื่อเก็บรายการของ PortfolioEntity.
    @Published var savedEntities: [PortfolioEntity] = []
    
    // MARK: Initializer
    init() {
        // สร้างและโหลด Persistent Container.
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            // เรียกใช้ฟังก์ชัน getPortfolio() เพื่อดึงข้อมูลพอร์ตโฟลิโอเมื่อเริ่มต้น.
            self.getPortfolio()
        }
    }
    
    // MARK: PUBLIC
    
    // ฟังก์ชัน อัปเดตพอร์ตโฟลิโอโดยตรวจสอบว่าเหรียญนั้นมีอยู่ในพอร์ตโฟลิโอหรือไม่ ถ้ามีอยู่แล้วจะอัปเดตหรือลบ ถ้าไม่มีจะเพิ่มเข้าไป.
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE
    
    // ดึงข้อมูลพอร์ตโฟลิโอจาก Core Data.
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    // เพิ่มเหรียญเข้าไปในพอร์ตโฟลิโอ.
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    // อัปเดตจำนวนเหรียญในพอร์ตโฟลิโอ.
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    // ลบเหรียญออกจากพอร์ตโฟลิโอ.
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    // บันทึกการเปลี่ยนแปลงลงใน Core Data.
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    // เรียกใช้ฟังก์ชัน save() และ getPortfolio() เพื่อบันทึกและดึงข้อมูลพอร์ตโฟลิโอใหม่.
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
}
