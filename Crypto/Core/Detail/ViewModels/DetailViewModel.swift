//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Kritchanat on 14/6/2567 BE.
//

// MARK: โค้ดนี้จัดการดึงและแปลงข้อมูลเกี่ยวกับเหรียญคริปโตเคอร์เรนซีจากบริการภายนอก และแปลงข้อมูลเหล่านั้นเป็นสถิติที่พร้อมใช้งานในแอป SwiftUI

import Foundation
import Combine // ใช้เพื่อจัดการกับการเรียก API

// คลาสนี้สืบทอดจาก ObservableObject ใช้กับ SwiftUI เพื่อให้สามารถอัพเดต UI ได้เมื่อข้อมูลเปลี่ยนแปลง.
class DetailViewModel: ObservableObject {
    
    // ประกาศตัวแปร @Published ที่ช่วยแจ้ง SwiftUI ให้รู้เมื่อมีการเปลี่ยนแปลงค่าเพื่ออัพเดต UI
    @Published var overviewStatistics: [StatisticModel] = [] // ข้อมูลสถิติภาพรวม.
    @Published var additionalStatistics: [StatisticModel] = [] // ข้อมูลสถิติเพิ่มเติม.
    @Published var coinDescription: String? = nil // คำอธิบายเหรียญ
    @Published var websiteURL: String? = nil // ลิงค์เว็บไซต์ของเหรียญ.
    @Published var redditURL: String? = nil // ลิงค์ Reddit ของเหรียญ.
    @Published var coin: CoinModel // ข้อมูลเหรียญ.
    
    // ประกาศตัวแปรตัวจัดการข้อมูลรายละเอียดเหรียญ.
    private let coinDetailService: CoinDetailDataService
    
    // ประกาศตัวแปรเป็นชุดของ AnyCancellable สำหรับเก็บการสมัครสมาชิก (subscriptions) เพื่อจัดการการยกเลิกการสมัครสมาชิก.
    private var cancellables = Set<AnyCancellable>()
    
    // รับ coin เป็นพารามิเตอร์และใช้ในการสร้าง coinDetailService และเรียกฟังก์ชัน addSubscribers() เพื่อสมัครรับข้อมูล.
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    // ฟังก์ชันใช้สำหรับสมัครรับข้อมูลจาก coinDetailService
    private func addSubscribers() {
        
        // สมัครรับข้อมูลจาก coinDetailService และ coin
        coinDetailService.$coinDetails
        
            // รวมทั้งสองค่าเข้าด้วยกัน
            .combineLatest($coin)
        
            // แปลงข้อมูลด้วยฟังก์ชัน mapDataToStatistics
            .map(mapDataToStatistics)
        
            // แล้วอัพเดต overviewStatistics และ additionalStatistics.
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        // สมัครรับข้อมูลจาก coinDetailService
        coinDetailService.$coinDetails
        
            // เมื่อได้รับข้อมูลรายละเอียดเหรียญ
            .sink { [weak self] (returnedCoinDetails) in
                
                // อัพเดต coinDescription, websiteURL, และ redditURL.
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    // ฟังก์ชันแปลงข้อมูลจาก CoinDetailModel และ CoinModel เป็นคู่ของ arrays ที่ประกอบด้วย overview และ additional statistics
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        
        // เรียกใช้ createOverviewArray และ createAdditionalArray.
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        return (overviewArray, additionalArray)
    }
    
    // ฟังก์ชัน createOverviewArray: สร้าง array ของ StatisticModel สำหรับข้อมูลสถิติภาพรวม
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        
        // ราคาปัจจุบัน
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        
        // การเปลี่ยนแปลงเปอร์เซ็นต์ราคา
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        // มูลค่าตลาด
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        // อันดับ
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        // ปริมาณการซื้อขาย
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overviewArray
    }
    
    // ฟังก์ชัน createAdditionalArray: สร้าง array ของ StatisticModel สำหรับข้อมูลสถิติเพิ่มเติม
    private func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        
        // ราคา 24 ชั่วโมงสูงสุด
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        // ต่ำสุด
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        // การเปลี่ยนแปลงราคา 24 ชั่วโมง
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        // การเปลี่ยนแปลงมูลค่าตลาด 24 ชั่วโมง
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        // เวลาในการสร้างบล็อก
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        // อัลกอริทึมการแฮช
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        return additionalArray
    }
    
}
