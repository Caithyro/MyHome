//
//  ViewController.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 23.07.2022.
//

import UIKit

class HomePageViewController: UIViewController {
    
    let homePageTableView = UITableView.init(frame: .zero,
                                             style: .insetGrouped)
    let homePageViewModel = HomePageViewModel()
    let lightControlPageViewModel = LightControlPageViewModel()
    let heaterControlPageViewModel = HeaterControlPageViewModel()
    let rollerShutterControlPageViewModel = RollerShutterControlPageViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
        self.homePageTableView.dataSource = self
        self.homePageTableView.delegate = self
    }
    
    //MARK: - Private
    
    private func setupUI() {
        
        self.view.backgroundColor = .white
        createTableView()
    }
    
    private func createTableView() {
        
        self.view.addSubview(homePageTableView)
        homePageTableView.translatesAutoresizingMaskIntoConstraints = false
        homePageTableView.topAnchor.constraint(equalTo:
                                                view.topAnchor).isActive = true
        homePageTableView.leftAnchor.constraint(equalTo:
                                                    view.leftAnchor).isActive = true
        homePageTableView.rightAnchor.constraint(equalTo:
                                                    view.rightAnchor).isActive = true
        homePageTableView.bottomAnchor.constraint(equalTo:
                                                    view.bottomAnchor).isActive = true
        homePageViewModel.loadData {
            self.homePageTableView.reloadData()
        }
        self.homePageTableView.register(HomePageTableViewCell.self,
                                        forCellReuseIdentifier: String(describing: HomePageTableViewCell.self))
    }
    
    
}

extension HomePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return homePageViewModel.devicesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.homePageTableView.dequeueReusableCell(withIdentifier:
                                                                String(describing: HomePageTableViewCell.self),
                                                              for: indexPath) as! HomePageTableViewCell
        cell.deviceItem = homePageViewModel.devicesArray[indexPath.row]
        cell.homePageViewModel = homePageViewModel
        cell.configureCell()
        return cell
    }
    
    
    
}

extension HomePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let lightControlPage = LightControlPageViewController()
        let heaterControlPage = HeaterControlPageViewController()
        let rollerShutterControlPage = RollerShutterControlPageViewController()
        
        switch homePageViewModel.devicesArray[indexPath.row].productType {
        case .light:
            lightControlPage.lightControlPageViewModel = self.lightControlPageViewModel
            lightControlPage.homePageViewModel = self.homePageViewModel
            lightControlPage.lightControlPageViewModel.targetDeviceID = homePageViewModel.devicesArray[indexPath.row].id
            lightControlPage.lightControlPageViewModel.lightsArray = homePageViewModel.lightsArray
            lightControlPage.lightControlPageViewModel.targetDeviceType = deviceLightString
            self.present(lightControlPage, animated: true)
            lightControlPage.delegate = self
        case .heater:
            heaterControlPage.heaterControlPageViewModel = self.heaterControlPageViewModel
            heaterControlPage.homePageViewModel = self.homePageViewModel
            heaterControlPage.heaterControlPageViewModel.targetDeviceID = homePageViewModel.devicesArray[indexPath.row].id
            heaterControlPage.heaterControlPageViewModel.heatersArray = homePageViewModel.heatersArray
            heaterControlPage.heaterControlPageViewModel.targetDeviceType = deviceHeaterString
            self.present(heaterControlPage, animated: true)
            heaterControlPage.delegate = self
        case .rollerShutter:
            rollerShutterControlPage.rollerShutterControlPageViewModel = self.rollerShutterControlPageViewModel
            rollerShutterControlPage.homePageViewModel = self.homePageViewModel
            rollerShutterControlPage.rollerShutterControlPageViewModel.targetDeviceID = homePageViewModel.devicesArray[indexPath.row].id
            rollerShutterControlPage.rollerShutterControlPageViewModel.rollerShuttersArray = homePageViewModel.rollerShuttersArray
            rollerShutterControlPage.rollerShutterControlPageViewModel.targetDeviceType = deviceRollerShutterString
            self.present(rollerShutterControlPage, animated: true)
            rollerShutterControlPage.delegate = self
        }
    }
}
