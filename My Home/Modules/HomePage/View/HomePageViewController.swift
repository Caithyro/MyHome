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
    let controlPageViewModel = ControlPageViewModel()
    
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
        
        let controlPage = ControlPageViewController()
        controlPage.controlPageViewModel = self.controlPageViewModel
        controlPage.homePageViewModel = self.homePageViewModel
        controlPage.controlPageViewModel.targetDeviceID = homePageViewModel.devicesArray[indexPath.row].id
        
        switch homePageViewModel.devicesArray[indexPath.row].productType {
        case .light:
            controlPage.controlPageViewModel.lightsArray = homePageViewModel.lightsArray
            controlPage.controlPageViewModel.targetDeviceType = deviceLightString
        case .heater:
            controlPage.controlPageViewModel.heatersArray = homePageViewModel.heatersArray
            controlPage.controlPageViewModel.targetDeviceType = deviceHeaterString
        case .rollerShutter:
            controlPage.controlPageViewModel.rollerShuttersArray = homePageViewModel.rollerShuttersArray
            controlPage.controlPageViewModel.targetDeviceType = deviceRollerShutterString
        }
        controlPage.delegate = self
        self.present(controlPage, animated: true)
    }
}
