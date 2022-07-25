//
//  ControlPageViewController.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 23.07.2022.
//

import UIKit

class ControlPageViewController: UIViewController {
    
    var controlPageViewModel = ControlPageViewModel.shared
    
    private var homePageViewModel = HomePageViewModel.shared
    
    weak var delegate: HomePageViewController?
    
    private var deviceImageView = UIImageView()
    private var deviceLabel = UILabel()
    private var deviceSwitch = UISwitch()
    private var controlSlider = UISlider()
    private var heaterStepper = UIStepper()
    private var currentStateLabel = UILabel()
    private var explanationAnnotationLabel = UILabel()
    private var onOffAnnotationLabel = UILabel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Private
    
    private func setupUI() {
        
        view = UIView()
        view.backgroundColor = .systemBackground
        
        addDeviceImageView()
        addDeviceLabel()
        
        switch controlPageViewModel.targetDeviceType {
        case deviceLightString:
            addLightsControls()
        case deviceHeaterString:
            addHeaterControls()
        case deviceRollerShutterString:
            addRollerShutterControls()
        default:
            print(errorUnknownDeviceString)
        }
    }
    
    private func addDeviceImageView() {
        
        let topSpacing = 96
        view.addSubview(deviceImageView)
        deviceImageView.translatesAutoresizingMaskIntoConstraints = false
        deviceImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deviceImageView.topAnchor.constraint(equalTo: view.topAnchor,
                                             constant: CGFloat(topSpacing)).isActive = true
        setDeviceImageAndText()
    }
    
    private func addDeviceLabel() {
        
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
        let leftSpacing = 16
        view.addSubview(deviceSwitch)
        deviceSwitch.translatesAutoresizingMaskIntoConstraints = false
        deviceSwitch.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor,
                                          constant: CGFloat(topSpacing)).isActive = true
        deviceSwitch.leftAnchor.constraint(equalTo: view.leftAnchor,
                                           constant: CGFloat(leftSpacing)).isActive = true
        deviceSwitch.addTarget(self, action: #selector(self.changedSwitchValue(_:)), for: .valueChanged)
    }
    
    private func createOnOffAnnotationLabel(deviceName: String) {
        
        let fontSize = 11
        let topSpacing = 56
        let leftSpacing = 16
        view.addSubview(onOffAnnotationLabel)
        onOffAnnotationLabel.text = onOffLabelString + " " + deviceName
        onOffAnnotationLabel.textColor = .systemGray
        onOffAnnotationLabel.font = .systemFont(ofSize: CGFloat(fontSize))
        onOffAnnotationLabel.translatesAutoresizingMaskIntoConstraints = false
        onOffAnnotationLabel.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor,
                                                  constant: CGFloat(topSpacing)).isActive = true
        onOffAnnotationLabel.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                   constant: CGFloat(leftSpacing)).isActive = true
    }
    
    private func createExplanationAnnotationLabel(device: String) {
        
        let fontSize = 11
        let topSpacing = 56
        let rightSpacing = -16
        view.addSubview(explanationAnnotationLabel)
        switch device {
        case deviceLightString:
            explanationAnnotationLabel.text = explanationAnnotationLabelStringLight
        case deviceHeaterString:
            explanationAnnotationLabel.text = explanationAnnotationLabelStringHeater
        case deviceRollerShutterString:
            explanationAnnotationLabel.text = explanationAnnotationLabelStringRollerShutter
        default:
            print(errorUnknownDeviceString)
        }
        explanationAnnotationLabel.textColor = .systemGray
        explanationAnnotationLabel.font = .systemFont(ofSize: CGFloat(fontSize))
        explanationAnnotationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationAnnotationLabel.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor,
                                                        constant: CGFloat(topSpacing)).isActive = true
        explanationAnnotationLabel.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                          constant: CGFloat(rightSpacing)).isActive = true
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
    
    private func addLightsControls() {
        
        let topSpacing = 16
        let leftSpacing = 16
        let rightSpacing = -16
        let targetDevice = controlPageViewModel.lightsArray.filter
        { $0.id == controlPageViewModel.targetDeviceID }
        createDeviceSwitch()
        createOnOffAnnotationLabel(deviceName: targetDevice.first!.deviceName)
        createExplanationAnnotationLabel(device: deviceLightString)
        createSliderControl(valueToChange: targetDevice.first!.intensity ?? 0)
        controlSlider.translatesAutoresizingMaskIntoConstraints = false
        controlSlider.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor,
                                           constant: CGFloat(topSpacing)).isActive = true
        controlSlider.leftAnchor.constraint(equalTo: deviceSwitch.rightAnchor,
                                            constant: CGFloat(leftSpacing)).isActive = true
        controlSlider.rightAnchor.constraint(equalTo: view.rightAnchor,
                                             constant: CGFloat(rightSpacing)).isActive = true

        if targetDevice.first!.mode == deviceModeOffString {
            controlSlider.isHidden = true
            deviceSwitch.isOn = false
            explanationAnnotationLabel.isHidden = true
        } else {
            controlSlider.isHidden = false
            deviceSwitch.isOn = true
            explanationAnnotationLabel.isHidden = false
        }
    }
    
    private func addHeaterControls() {
        
        let targetDevice = controlPageViewModel.heatersArray.filter
        { $0.id == controlPageViewModel.targetDeviceID }
        let topSpacing = 16
        let rightSpacing = -16
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
    
    private func addRollerShutterControls() {
        
        let targetDevice = controlPageViewModel.rollerShuttersArray.filter
        { $0.id == controlPageViewModel.targetDeviceID }
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
        
        switch controlPageViewModel.targetDeviceType {
        case deviceLightString:
            let targetDevice = controlPageViewModel.lightsArray.filter
            { $0.id == controlPageViewModel.targetDeviceID }
            let lightDeviceIsText = targetDevice.first!.deviceName + " " + isString + " "
            if targetDevice.first?.mode == deviceModeOnString {
                deviceImageView.image = UIImage(named: "DeviceLightOnIcon")!
                deviceLabel.text = lightDeviceIsText + targetDevice.first!.mode! + " " + atString + " " + String(
                    describing: (targetDevice.first!.intensity ?? 0)) + percentString
            } else {
                deviceImageView.image = UIImage(named: "DeviceLightOffIcon")!
                deviceLabel.text = lightDeviceIsText + targetDevice.first!.mode!
            }
        case "Heater":
            let targetDevice = controlPageViewModel.heatersArray.filter
            { $0.id == controlPageViewModel.targetDeviceID }
            let heaterDeviceIsText = targetDevice.first!.deviceName + " " + isString + " "
            if targetDevice.first?.mode == deviceModeOnString {
                deviceImageView.image = UIImage(named: "DeviceHeaterOnIcon")!
                deviceLabel.text = heaterDeviceIsText + targetDevice.first!.mode! + " " + atString + String(
                    describing: (targetDevice.first!.temperature ?? 0)) + celsiusDegreeString
            } else {
                deviceImageView.image = UIImage(named: "DeviceHeaterOffIcon")!
                deviceLabel.text = heaterDeviceIsText + targetDevice.first!.mode!
            }
        case "RollerShutter":
            let targetDevice = controlPageViewModel.rollerShuttersArray.filter
            { $0.id == controlPageViewModel.targetDeviceID }
            let rollerShutterDeviceIsText = targetDevice.first!.deviceName + " " + isString + " "
            if targetDevice.first?.position == 0 {
                deviceImageView.image = UIImage(named: "DeviceRollerShutterIcon")!
                deviceLabel.text = rollerShutterDeviceIsText + deviceStateClosedString
            } else {
                deviceImageView.image = UIImage(named: "DeviceRollerShutterIcon")!
                deviceLabel.text = rollerShutterDeviceIsText + deviceStateOpenedString + " " + atString + " " + String(
                    describing: (targetDevice.first!.position ?? 0)) + percentString
            }
        default:
            print(errorUnknownDeviceString)
        }
    }
    
    @IBAction func changedSliderValue(_ sender: UISlider!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == controlPageViewModel.targetDeviceID }
        
        switch targetDevice.first?.productType {
        case .light:
            let setIntensity = Int(sender.value)
            let deviceLabelTextFirstPart = targetDevice.first!.deviceName + " " + isString
            let deviceLabelTextSecondPart = targetDevice.first!.mode! + " " + atString + " " + String(
                describing: setIntensity) + percentString
            deviceLabel.text = deviceLabelTextFirstPart + " " + deviceLabelTextSecondPart
            targetDevice.first?.intensity = setIntensity
            homePageViewModel.lightsArray.removeAll()
        case .rollerShutter:
            let setPosition = Int(sender.value)
            let deviceLabelTextFirstPart = targetDevice.first!.deviceName + " " + isString
            var deviceLabelTextSecondPart = String()
            if setPosition == 0 {
                deviceLabelTextSecondPart = deviceStateClosedString
            } else {
                deviceLabelTextSecondPart = deviceStateOpenedString + " " + atString + " " + String(
                    describing: setPosition) + percentString
            }
            deviceLabel.text = deviceLabelTextFirstPart + " " + deviceLabelTextSecondPart
            targetDevice.first?.position = setPosition
            homePageViewModel.rollerShuttersArray.removeAll()
        case .heater:
            print(errorNoSliderFoundString)
        case .none:
            print(errorUnknownDeviceString)
        }
        self.delegate?.homePageTableView.reloadData()
    }
    
    @IBAction func changedSwitchValue(_ sender: UISwitch!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == controlPageViewModel.targetDeviceID }
        
        switch targetDevice.first?.productType {
        case .light:
            let lightDeviceIsText = targetDevice.first!.deviceName + " " + isString + " "
            if sender.isOn == true {
                targetDevice.first?.mode = deviceModeOnString
                deviceImageView.image = UIImage(named: "DeviceLightOnIcon")!
                deviceLabel.text = lightDeviceIsText + targetDevice.first!.mode! + " " + atString + " " + String(
                    describing: (targetDevice.first!.intensity ?? 0)) + percentString
                controlSlider.isHidden = false
                explanationAnnotationLabel.isHidden = false
            } else {
                targetDevice.first?.mode = deviceModeOffString
                deviceImageView.image = UIImage(named: "DeviceLightOffIcon")!
                deviceLabel.text = lightDeviceIsText + targetDevice.first!.mode!
                controlSlider.isHidden = true
                explanationAnnotationLabel.isHidden = true
            }
            homePageViewModel.lightsArray.removeAll()
        case .rollerShutter:
            print(errorNoSwitchFoundString)
        case .heater:
            let heaterDeviceIsText = targetDevice.first!.deviceName + " " + isString + " "
            if sender.isOn == true {
                targetDevice.first?.mode = deviceModeOnString
                deviceImageView.image = UIImage(named: "DeviceHeaterOnIcon")
                deviceLabel.text = heaterDeviceIsText + targetDevice.first!.mode! + " " + atString + " " + String(
                    describing: (targetDevice.first!.temperature ?? 0)) + celsiusDegreeString
                heaterStepper.isHidden = false
                explanationAnnotationLabel.isHidden = false
            } else {
                targetDevice.first?.mode = deviceModeOffString
                deviceImageView.image = UIImage(named: "DeviceHeaterOffIcon")!
                deviceLabel.text = heaterDeviceIsText + targetDevice.first!.mode!
                heaterStepper.isHidden = true
                explanationAnnotationLabel.isHidden = true
            }
            homePageViewModel.heatersArray.removeAll()
        case .none:
            print(errorUnknownDeviceString)
        }
        self.delegate?.homePageTableView.reloadData()
    }
    
    @IBAction func heaterStepperButtonPressed(_ sender: UIStepper!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == controlPageViewModel.targetDeviceID }
        let setTemperature = Int(sender.value)
        let heaterStepperIsText = targetDevice.first!.deviceName + " " + isString + " "
        targetDevice.first?.temperature = Int(setTemperature)
        deviceLabel.text = heaterStepperIsText + targetDevice.first!.mode! + " " + atString + " " + String(
            describing: setTemperature) + celsiusDegreeString
        homePageViewModel.heatersArray.removeAll()
        self.delegate?.homePageTableView.reloadData()
    }
    
}
