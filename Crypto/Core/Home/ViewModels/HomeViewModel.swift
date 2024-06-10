//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Kritchanat on 11/6/2567 BE.
//

// MARK: HomeViewModel ใช้ Combine เพื่อจัดการข้อมูลที่เปลี่ยนแปลงตลอดเวลา, กรองและจัดเรียงข้อมูลเหรียญ, อัพเดทพอร์ตโฟลิโอ, และแมปข้อมูลตลาดเพื่อแสดงผลในแอป SwiftUI.

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    // ประกาศตัวแปรที่ใช้ร่วมกับ SwiftUI เพื่ออัพเดท UI อัตโนมัติเมื่อค่าของตัวแปรเหล่านี้เปลี่ยนแปลง.
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    // ประกาศตัวแปรที่ใช้เรียกบริการข้อมูล (Data Services) และเก็บการยกเลิกการสมัคร (cancellables).
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    // ประกาศ enum สำหรับตัวเลือกการจัดเรียงข้อมูล.
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    // (initializer) ที่เรียกฟังก์ชัน addSubscribers เพื่อเริ่มการสมัครรับข้อมูล
    init() {
        addSubscribers()
    }
    
    // ฟังก์ชันสำหรับรับข้อมูล (subscriptions) เพื่อรับการอัพเดทจากบริการข้อมูล.
    func addSubscribers() {
        
        // updates allCoins
        $searchText
            // รับข้อมูลการเปลี่ยนแปลงของ searchText, allCoins และ sortOption.
            .combineLatest(coinDataService.$allCoins, $sortOption)
           
            // ใช้ debounce เพื่อหน่วงเวลาการกรองและจัดเรียงข้อมูล.
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        
            // ใช้ map เพื่อกรองและจัดเรียงเหรียญตามตัวกรองและตัวเลือกการจัดเรียง.
            .map(filterAndSortCoins)
        
            // ใช้ sink เพื่ออัพเดทค่า allCoins.
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
           
            // เก็บการสมัครรับข้อมูลใน cancellables.
            .store(in: &cancellables)
        
        // updates portfolioCoins
        $allCoins
            // รับข้อมูลการเปลี่ยนแปลงของ allCoins และ savedEntities เพื่ออัพเดท portfolioCoins.
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)

        
        // updates marketData
        marketDataService.$marketData
         
            // รับข้อมูลการเปลี่ยนแปลงของ marketData และ portfolioCoins เพื่ออัพเดท statistics และตั้งค่า isLoading เป็น false.
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
    }
    
    // ฟังก์ชันสำหรับอัพเดทพอร์ตโฟลิโอด้วยข้อมูลเหรียญและจำนวน.
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    // ฟังก์ชันสำหรับโหลดข้อมูลใหม่โดยตั้งค่า isLoading เป็น true และเรียกบริการข้อมูล.
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    // ฟังก์ชันสำหรับกรองและจัดเรียงเหรียญ.
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    // ฟังก์ชันสำหรับกรองเหรียญตามข้อความค้นหา.
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    // ฟังก์ชันสำหรับจัดเรียงเหรียญตามตัวเลือกการจัดเรียง.
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    // ฟังก์ชันสำหรับจัดเรียงเหรียญในพอร์ตโฟลิโอหากจำเป็น.
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        // will only sort by holdings or reversedholdings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    // ฟังก์ชันสำหรับแมปข้อมูลเหรียญทั้งหมดไปยังเหรียญในพอร์ตโฟลิโอ.
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    // ฟังก์ชันสำหรับแมปข้อมูลตลาดทั่วโลกเพื่อสร้างสถิติ.
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
    
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue =
            portfolioCoins
                .map({ $0.currentHoldingsValue })
                .reduce(0, +)
        
        let previousValue =
            portfolioCoins
                .map { (coin) -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                    let previousValue = currentValue / (1 + percentChange)
                    return previousValue
                }
                .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
}
