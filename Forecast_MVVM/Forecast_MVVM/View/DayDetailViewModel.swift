//
//  DayDetailViewModel.swift
//  Forecast_MVVM
//
//  Created by Matheus Oliveira on 10/18/22.
//

import Foundation

protocol DayDetailViewModelDelegate: DayDetailsViewController {
   func updateViews()
}

class DayDetailViewModel {
    //Mark - Properties
    var forcastData: TopLevelDictionary?
    private weak var delegate: DayDetailViewModelDelegate?
    var days: [Day] {
        self.forcastData?.days ?? []
    }
    
    private let networkingController: NetworkingContoller
    
    init(delegate: DayDetailViewModelDelegate, networkingController: NetworkingContoller = NetworkingContoller()) {
        self.delegate = delegate
        self.networkingController = networkingController
        fetchForcastData()
    }
    func fetchForcastData() {
        NetworkingContoller.fetchDays { result in
            switch result {
            case .failure(let error):
                print("Error fetching data fetchDays!", error.errorDescription!)
            case .success(let forecastData):
                self.forcastData = forecastData
                self.delegate?.updateViews()
            }
        }
    }
}
