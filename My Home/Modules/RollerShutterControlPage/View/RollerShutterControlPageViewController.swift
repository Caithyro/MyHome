//
//  RollerShutterControlPageViewController.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 29.07.2022.
//

import UIKit

class RollerShutterControlPageViewController: UIViewController {
    
    var rollerShutterControlPageViewModel: RollerShutterControlPageViewModel!
    var homePageViewModel: HomePageViewModel!
    
    weak var delegate: HomePageViewController?
    
    private var deviceImageView = UIImageView()
    private var deviceLabel = UILabel()
    private var controlSlider = UISlider()
    private var explanationAnnotationLabel = UILabel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.delegate?.homePageTableView.reloadData()
    }
    
    //MARK: - Private
    
    private func setupUI() {
        
        view = UIView()
        view.backgroundColor = .systemBackground
        
        createDeviceImageView()
        createDeviceLabel()
        addRollerShutterControls()
    }
    
    private func createDeviceImageView() {
        
        let topSpacing = 96
        view.addSubview(deviceImageView)
        deviceImageView.translatesAutoresizingMaskIntoConstraints = false
        deviceImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deviceImageView.topAnchor.constraint(equalTo: view.topAnchor,
                                             constant: CGFloat(topSpacing)).isActive = true
        setDeviceImageAndText()
    }
    
    private func createDeviceLabel() {
        
        let topSpacing = 16
        view.addSubview(deviceLabel)
        deviceLabel.translatesAutoresizingMaskIntoConstraints = false
        deviceLabel.numberOfLines = 0
        deviceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deviceLabel.topAnchor.constraint(equalTo: deviceImageView.bottomAnchor,
                                         constant: CGFloat(topSpacing)).isActive = true
    }
    
    private func createExplanationAnnotationLabel(device: String) {
        
        let fontSize = 10
        let topSpacing = 224
        view.addSubview(explanationAnnotationLabel)
        switch device {
        case deviceLightString:
            explanationAnnotationLabel.text = NSLocalizedString("l.explanationAnnotationLabelStringLight", comment: "")
        case deviceHeaterString:
            explanationAnnotationLabel.text = NSLocalizedString("l.explanationAnnotationLabelStringHeater", comment: "")
        case deviceRollerShutterString:
            explanationAnnotationLabel.text = NSLocalizedString("l.explanationAnnotationLabelStringRollerShutter", comment: "")
        default:
            print(NSLocalizedString("l.deviceUnknownString", comment: ""))
        }
        explanationAnnotationLabel.textColor = .systemGray
        explanationAnnotationLabel.font = .systemFont(ofSize: CGFloat(fontSize))
        explanationAnnotationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationAnnotationLabel.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor,
                                                        constant: CGFloat(topSpacing)).isActive = true
        explanationAnnotationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func createSliderControl(valueToChange: Int) {
        
        let minValue = 0
        let maxValue = 100
        view.addSubview(controlSlider)
        controlSlider.minimumValue = Float(minValue)
        controlSlider.maximumValue = Float(maxValue)
        controlSlider.value = Float(valueToChange)
        controlSlider.addTarget(self, action: #selector(self.changedSliderValue(_:)), for: .valueChanged)
    }
    
    private func addRollerShutterControls() {
        
        let targetDevice = rollerShutterControlPageViewModel.rollerShuttersArray.filter
        { $0.id == rollerShutterControlPageViewModel.targetDeviceID }
        let rotationAngle = CGFloat(-Double.pi / 2)
        let topSpacing = 104
        let width = 200
        createExplanationAnnotationLabel(device: deviceRollerShutterString)
        createSliderControl(valueToChange: targetDevice.first?.position ?? 0)
        controlSlider.transform = CGAffineTransform(rotationAngle: rotationAngle)
        controlSlider.translatesAutoresizingMaskIntoConstraints = false
        controlSlider.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor,
                                           constant: CGFloat(topSpacing)).isActive = true
        controlSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        controlSlider.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
    }
    
    private func setDeviceImageAndText() {
        
        let targetDevice = rollerShutterControlPageViewModel.rollerShuttersArray.filter
        { $0.id == rollerShutterControlPageViewModel.targetDeviceID }
        let rollerShutterDeviceIsText = targetDevice.first!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                                 comment: "") + " "
        if targetDevice.first?.position == 0 {
            deviceImageView.image = UIImage(named: "DeviceRollerShutterClosedIcon")!
            deviceLabel.text = rollerShutterDeviceIsText + NSLocalizedString("l.deviceStateClosedString",
                                                                             comment: "")
        } else {
            deviceImageView.image = UIImage(named: "DeviceRollerShutterOpenIcon")!
            deviceLabel.text = rollerShutterDeviceIsText + NSLocalizedString("l.deviceStateOpenedString",
                                                                             comment: "") + " " + NSLocalizedString("l.atString", comment: "") + " " + String(
                                                                                describing: (targetDevice.first!.position ?? 0)) + percentString
        }
    }
    
    @IBAction func changedSliderValue(_ sender: UISlider!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == rollerShutterControlPageViewModel.targetDeviceID }
        let setPosition = Int(sender.value)
        let deviceLabelTextFirstPart = targetDevice.first!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                                comment: "")
        var deviceLabelTextSecondPart = String()
        if setPosition == 0 {
            deviceLabelTextSecondPart = NSLocalizedString("l.deviceStateClosedString", comment: "")
            deviceImageView.image = UIImage(named: "DeviceRollerShutterClosedIcon")
        } else {
            deviceLabelTextSecondPart = NSLocalizedString("l.deviceStateOpenedString",
                                                          comment: "") + " " + NSLocalizedString("l.atString",
                                                                                                 comment: "") + " " + String(
                                                                                                    describing: setPosition) + percentString
            deviceImageView.image = UIImage(named: "DeviceRollerShutterOpenIcon")
        }
        deviceLabel.text = deviceLabelTextFirstPart + " " + deviceLabelTextSecondPart
        targetDevice.first?.position = setPosition
        homePageViewModel.rollerShuttersArray.removeAll()
    }
}
