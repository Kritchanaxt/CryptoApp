//
//  LocalFileManager.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: โค้ดนี้ช่วยให้สามารถบันทึกและดึงภาพจากเครื่องได้อย่างง่ายดาย โดยมีการจัดการโฟลเดอร์และไฟล์อย่างมีประสิทธิภาพ

import Foundation
import SwiftUI

// สร้างคลาส LocalFileManager ที่ใช้จัดการไฟล์ในเครื่อง.
class LocalFileManager {
    
    // สร้างตัวแปร instance แบบ static เพื่อใช้งานทั่วแอป.
    static let instance = LocalFileManager()
    
    // ใช้ private init() เพื่อป้องกันการสร้าง instance ของคลาสจากภายนอก.
    private init() { }
    
    // ฟังก์ชัน saveImage ใช้เพื่อบันทึกภาพในเครื่อง.
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        // MARK: create folder
        // เรียก createFolderIfNeeded เพื่อสร้างโฟลเดอร์ถ้ายังไม่มี.
        createFolderIfNeeded(folderName: folderName)
        
        // MARK: get path for image
        // ใช้ guard เพื่อรับข้อมูลจากภาพในรูปแบบ PNG และ URL ที่จะบันทึกภาพ ถ้าขั้นตอนใดไม่สำเร็จจะออกจากฟังก์ชัน.
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
            else { return }
        
        // MARK: save image to path
        // ใช้ do-catch เพื่อพยายามเขียนข้อมูลภาพไปยัง URL ที่กำหนด ถ้ามีข้อผิดพลาดจะพิมพ์ข้อความแสดงข้อผิดพลาด.
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    // ฟังก์ชัน getImage ใช้เพื่อดึงภาพจากเครื่อง.
    func getImage(imageName: String, folderName: String) -> UIImage? {
        
        // ใช้ guard เพื่อรับ URL ของภาพและตรวจสอบว่ามีไฟล์อยู่ที่ URL นั้น ถ้าไม่สำเร็จจะคืนค่า nil.
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        // ถ้าพบไฟล์ที่ URL นั้นจะคืนค่าเป็น UIImage.
        return UIImage(contentsOfFile: url.path)
    }
    
    // ฟังก์ชัน createFolderIfNeeded ใช้เพื่อสร้างโฟลเดอร์ถ้ายังไม่มี.
    private func createFolderIfNeeded(folderName: String) {
        
        // ใช้ guard เพื่อรับ URL ของโฟลเดอร์ ถ้าไม่สำเร็จจะออกจากฟังก์ชัน.
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        // ตรวจสอบว่ามีโฟลเดอร์อยู่ที่ URL นั้นหรือไม่ ถ้าไม่มีจะใช้ do-catch เพื่อสร้างโฟลเดอร์และจัดการข้อผิดพลาด.
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    // ฟังก์ชัน getURLForFolder ใช้เพื่อรับ URL ของโฟลเดอร์ในไดเรกทอรี cachesDirectory.
    private func getURLForFolder(folderName: String) -> URL? {
        
        // ใช้ guard เพื่อรับ URL ของไดเรกทอรี cachesDirectory ถ้าไม่สำเร็จจะคืนค่า nil.
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        // ถ้าสำเร็จจะคืนค่า URL ของโฟลเดอร์ที่ต้องการ.
        return url.appendingPathComponent(folderName)
    }
    
    // ฟังก์ชัน getURLForImage ใช้เพื่อรับ URL ของภาพในโฟลเดอร์ที่กำหนด.
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        
        // ใช้ guard เพื่อรับ URL ของโฟลเดอร์ ถ้าไม่สำเร็จจะคืนค่า nil.
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        
        // ใช้ guard เพื่อรับ URL ของโฟลเดอร์ ถ้าไม่สำเร็จจะคืนค่า nil.
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
}
