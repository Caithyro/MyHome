//
//  HeaterControlPageViewController.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 29.07.2022.
//

import UIKit

class HeaterControlPageViewController: UIViewController {
    
    var heaterControlPageViewModel: HeaterControlPageViewModel!
    var homePageViewModel: HomePageViewModel!
    
    weak var delegate: HomePageViewController?
    
    private var deviceImageView = UIImageView()
    private var deviceLabel = UILabel()
    private var deviceSwitch = UISwitch()
    private var heaterStepper = UIStepper()
    private var explanationAnnotationLabel = UILabel()
    private var onOffAnnotationLabel = UILabel()
    
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
        addHeaterControls()
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
    
    private func createDeviceSwitch() {
        
        let topSpacing = 16
        let leftSpacing = 8
        view.addSubview(deviceSwitch)
        deviceSwitch.translatesAutoresizingMaskIntoConstraints = false
        deviceSwitch.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor,
                                          constant: CGFloat(topSpacing)).isActive = true
        deviceSwitch.leftAnchor.constraint(equalTo: view.leftAnchor,
                                           constant: CGFloat(leftSpacing)).isActive = true
        deviceSwitch.addTarget(self, action: #selector(self.changedSwitchValue(_:)), for: .valueChanged)
    }
    
    private func createOnOffAnnotationLabel(deviceName: String) {
        
        let fontSize = 10
        let topSpacing = 56
        let leftSpacing = 8
        view.addSubview(onOffAnnotationLabel)
        onOffAnnotationLabel.text = NSLocalizedString("l.onOffLabelString", comment: "") + " " + deviceName
        onOffAnnotationLabel.textColor = .systemGray
        onOffAnnotationLabel.font = .systemFont(ofSize: CGFloat(fontSize))
        onOffAnnotationLabel.translatesAutoresizingMaskIntoConstraints = false
        onOffAnnotationLabel.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor,
                                                  constant: CGFloat(topSpacing)).isActive = true
        onOffAnnotationLabel.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                   constant: CGFloat(leftSpacing)).isActive = true
    }
    
    private func createExplanationAnnotationLabel(device: String) {
        
        let fontSize = 10
        let topSpacing = 56
        let rightSpacing = -8
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
        explanationAnnotationLabel.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                          constant: CGFloat(rightSpacing)).isActive = true
    }
    
    private func addHeaterControls() {
        
        let targetDevice = heaterControlPageViewModel.heatersArray.filter
        { $0.id == heaterControlPageViewModel.targetDeviceID }
        let topSpacing = 16
        let rightSpacing = -8
        let minValue = 7
        let maxValue = 28
        let stepValue = 0.5
        createDeviceSwitch()
        createOnOffAnnotationLabel(deviceName: targetDevice.first!.deviceName)
        createExplanationAnnotationLabel(device: deviceHeaterString)
        
        view.addSubview(heaterStepper)
        heaterStepper.translatesAutoresizingMaskIntoConstraints = false
        heaterStepper.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor,
                                           constant: CGFloat(topSpacing)).isActive = true
        heaterStepper.rightAnchor.constraint(equalTo: view.rightAnchor,
                                             constant: CGFloat(rightSpacing)).isActive = true
        heaterStepper.minimumValue = Double(minValue)
        heaterStepper.maximumValue = Double(maxValue)
        heaterStepper.value = Double(targetDevice.first?.temperature! ?? 0)
        heaterStepper.stepValue = stepValue
        heaterStepper.addTarget(self, action: #selector(self.heaterStepperButtonPressed(_:)), for: .valueChanged)
        
        if targetDevice.first?.mode == deviceModeOffString {
            deviceSwitch.isOn = false
            heaterStepper.isHidden = true
            explanationAnnotationLabel.isHidden = true
        } else {
            deviceSwitch.isOn = true
            heaterStepper.isHidden = false
            explanationAnnotationLabel.isHidden = false
        }
    }
    
    private func setDeviceImageAndText() {
        
        let targetDevice = heaterControlPageViewModel.heatersArray.filter
        { $0.id == heaterControlPageViewModel.targetDeviceID }
        let heaterDeviceIsText = targetDevice.first!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                          comment: "") + " "
        if targetDevice.first?.mode == deviceModeOnString {
            deviceImageView.image = UIImage(named: "DeviceHeaterOnIcon")!
            deviceLabel.text = heaterDeviceIsText + NSLocalizedString("l.deviceModeOnString",
                                                                      comment: "") + " " + NSLocalizedString("l.atString", comment: "") + " " + String(
                                                                        describing: (targetDevice.first!.temperature ?? 0)) + celsiusDegreeString
        } else {
            deviceImageView.image = UIImage(named: "DeviceHeaterOffIcon")!
            deviceLabel.text = heaterDeviceIsText + NSLocalizedString("l.deviceModeOffString",
                                                                      comment: "")
        }
    }
    
    @IBAction func changedSwitchValue(_ sender: UISwitch!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == heaterControlPageViewModel.targetDeviceID }
        let heaterDeviceIsText = targetDevice.first!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                          comment: "") + " "
        if sender.isOn == true {
            targetDevice.first?.mode = deviceModeOnString
            deviceImageView.image = UIImage(named: "DeviceHeaterOnIcon")
            deviceLabel.text = heaterDeviceIsText + NSLocalizedString("l.deviceModeOnString",
                                                                      comment: "") + " " + NSLocalizedString("l.atString", comment: "") + " " + String(
                                                                        describing: (targetDevice.first!.temperature ?? 0)) + celsiusDegreeString
            heaterStepper.isHidden = false
            explanationAnnotationLabel.isHidden = false
        } else {
            targetDevice.first?.mode = deviceModeOffString
            deviceImageView.image = UIImage(named: "DeviceHeaterOffIcon")!
            deviceLabel.text = heaterDeviceIsText + NSLocalizedString("l.deviceModeOffString",
                                                                      comment: "")
            heaterStepper.isHidden = true
            explanationAnnotationLabel.isHidden = true
        }
        homePageViewModel.heatersArray.removeAll()
    }
    
    @IBAction func heaterStepperButtonPressed(_ sender: UIStepper!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == heaterControlPageViewModel.targetDeviceID }
        let setTemperature = Int(sender.value)
        let heaterStepperIsText = targetDevice.first!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                           comment: "") + " "
        targetDevice.first?.temperature = Int(setTemperature)
        deviceLabel.text = heaterStepperIsText + NSLocalizedString("l.deviceModeOnString",
                                                                   comment: "") + " " + NSLocalizedString("l.atString",
                                                                                                          comment: "") + " " + String(
                                                                                                            describing: setTemperature) + celsiusDegreeString
        homePageViewModel.heatersArray.removeAll()
    }
    
}

