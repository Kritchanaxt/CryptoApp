//
//  NetworkingManager .swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: โค้ดนี้จัดการการร้องขอข้อมูลจาก URL และจัดการข้อผิดพลาดที่อาจเกิดขึ้นระหว่างการร้องขอได้อย่างมีประสิทธิภาพ.

import Foundation
import Combine // สำหรับการจัดการการทำงานแบบ reactive.

// กำหนดคลาสที่จะใช้สำหรับการจัดการการทำงานเกี่ยวกับเครือข่าย
class NetworkingManager {
    
    // สร้าง enum เพื่อจัดการข้อผิดพลาดที่อาจเกิดขึ้น.
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        // อธิบายของข้อผิดพลาด.
        var errorDescription: String? {
            switch self {
                 // ใช้เมื่อได้การตอบสนองที่ไม่ถูกต้องจาก URL
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
                // ใช้สำหรับข้อผิดพลาดที่ไม่รู้จัก
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    // ฟังก์ชันแบบ static ที่รับ URL และคืนค่าเป็น AnyPublisher<Data, Error>.
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        
        // ใช้เพื่อทำการร้องขอข้อมูลจาก URL.
         return URLSession.shared.dataTaskPublisher(for: url)
         
            // ใช้เพื่อจัดการการตอบสนองและเรียกฟังก์ชัน handleURLResponse.
            .tryMap({ try handleURLResponse(output: $0, url: url) })
         
            // ใช้เพื่อทำการ retry การร้องขอใหม่อีก 3 ครั้งถ้าเกิดข้อผิดพลาด.
            .retry(3)
        
            // ใช้เพื่อแปลงผลลัพธ์เป็น AnyPublisher.
            .eraseToAnyPublisher()
    }
    
    // ฟังก์ชัน handleURLResponse รับ parameter output ของชนิด URLSession.DataTaskPublisher.Output และ url ของชนิด URL.
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        
        // ตรวจสอบว่าการตอบสนอง (response) เป็น HTTPURLResponse และมีสถานะรหัส (status code) อยู่ในช่วง 200 ถึง 299.
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            
            // ถ้าไม่ตรงตามเงื่อนไข จะโยนข้อผิดพลาด NetworkingError.badURLResponse(url: url)
            throw NetworkingError.badURLResponse(url: url)
        }
        
        // ถ้าตรงตามเงื่อนไข จะคืนค่า output.data.
        return output.data
    }
    
    // ฟังก์ชัน handleCompletion รับ parameter completion ของชนิด Subscribers.Completion<Error>.
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        
        // เพื่อตรวจสอบสถานะของ completion
        switch completion {
            //ถ้าเป็น .finished ไม่ต้องทำอะไร.
        case .finished:
            break
            // ถ้าเป็น .failure(let error) จะพิมพ์คำอธิบายของข้อผิดพลาด 
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
}
