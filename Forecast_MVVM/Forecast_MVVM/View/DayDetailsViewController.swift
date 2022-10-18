//
//  DayDetailsViewController.swift
//  Forecast_MVVM
//
//  Created by Karl Pfister on 2/13/22.
//

import UIKit

class DayDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var dayForcastTableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHighLabel: UILabel!
    @IBOutlet weak var currentLowLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    
    //MARK: - Properties
    var forcastData: TopLevelDictionary?
    var days: [Day] = []
    var viewModel: DayDetailViewModel!
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Conform to the TBVS Protocols
        viewModel = DayDetailViewModel(delegate: self)
        dayForcastTableView.delegate = self
        
        dayForcastTableView.dataSource = self
        
        NetworkingContoller.fetchDays { result in
            
            switch result {
            case .success(let forcastData):
                self.forcastData = forcastData
                self.days = forcastData.days
                DispatchQueue.main.async {
                    self.updateViews()
                    self.dayForcastTableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching the data!", error.errorDescription!)
            }
        }
    }
}


//MARK: - Extenstions
extension DayDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayForcastTableViewCell else {return UITableViewCell()}
        let day = viewModel.days[indexPath.row]
        cell.updateViews(day: day)
        return cell
    }
}

extension DayDetailsViewController: DayDetailViewModelDelegate {
    func updateViews() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            let currentDay = self.viewModel.days[0]
            self.cityNameLabel.text = self.viewModel.forcastData?.cityName ?? "No City Found"
            self.currentDescriptionLabel.text = currentDay.weather.description
            self.currentTempLabel.text = "\(currentDay.temp)F"
            self.currentLowLabel.text = "\(currentDay.lowTemp)F"
            self.currentHighLabel.text = "\(currentDay.highTemp)F"
            self.dayForcastTableView.reloadData()
        }
    }
}


