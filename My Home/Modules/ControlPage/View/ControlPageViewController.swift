//
//  ControlPageViewController.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 23.07.2022.
//

import UIKit

class ControlPageViewController: UIViewController {
    
    var controlPageViewModel: ControlPageViewModel!
    var homePageViewModel: HomePageViewModel!
    
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
        
        createDeviceImageView()
        createDeviceLabel()
        
        switch controlPageViewModel.targetDeviceType {
        case deviceLightString:
            addLightsControls()
        case deviceHeaterString:
            addHeaterControls()
        case deviceRollerShutterString:
            addRollerShutterControls()
        default:
            print(NSLocalizedString("l.errorUnknownDeviceString", comment: ""))
        }
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
        let leftSpacing = 8
        let rightSpacing = -8
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
            let lightDeviceIsText = targetDevice.first!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                             comment: "") + " "
            if targetDevice.first?.mode == deviceModeOnString {
                deviceImageView.image = UIImage(named: "DeviceLightOnIcon")!
                deviceLabel.text = lightDeviceIsText + NSLocalizedString("l.deviceModeOnString",
                                                                         comment: "") + " " + NSLocalizedString("l.atString",
                                                                                                                comment: "") + " " + String(
                                                                                                                    describing: (targetDevice.first!.intensity ?? 0)) + percentString
            } else {
                deviceImageView.image = UIImage(named: "DeviceLightOffIcon")!
                deviceLabel.text = lightDeviceIsText + NSLocalizedString("l.deviceModeOffString",
                                                                         comment: "")
            }
        case "Heater":
            let targetDevice = controlPageViewModel.heatersArray.filter
            { $0.id == controlPageViewModel.targetDeviceID }
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
        case "RollerShutter":
            let targetDevice = controlPageViewModel.rollerShuttersArray.filter
            { $0.id == controlPageViewModel.targetDeviceID }
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
        default:
            print(NSLocalizedString("l.errorUnknownDeviceString", comment: ""))
        }
    }
    
    @IBAction func changedSliderValue(_ sender: UISlider!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == controlPageViewModel.targetDeviceID }
        
        switch targetDevice.first?.productType {
        case .light:
            let setIntensity = Int(sender.value)
            let deviceLabelTextFirstPart = targetDevice.first!.deviceName + " " + NSLocalizedString("l.isString", comment: "")
            let deviceLabelTextSecondPart = NSLocalizedString("l.deviceModeOnString",
                                                              comment: "") + " " + NSLocalizedString("l.atString",
                                                                                                     comment: "") + " " + String(
                                                                                                        describing: setIntensity) + percentString
            deviceLabel.text = deviceLabelTextFirstPart + " " + deviceLabelTextSecondPart
            targetDevice.first?.intensity = setIntensity
            homePageViewModel.lightsArray.removeAll()
        case .rollerShutter:
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
        case .heater:
            print(NSLocalizedString("l.errorNoSliderFoundString", comment: ""))
        case .none:
            print(NSLocalizedString("l.errorUnknownDeviceString", comment: ""))
        }
        self.delegate?.homePageTableView.reloadData()
    }
    
    @IBAction func changedSwitchValue(_ sender: UISwitch!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == controlPageViewModel.targetDeviceID }
        
        switch targetDevice.first?.productType {
        case .light:
            let lightDeviceIsText = targetDevice.first!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                             comment: "") + " "
            if sender.isOn == true {
                targetDevice.first?.mode = deviceModeOnString
                deviceImageView.image = UIImage(named: "DeviceLightOnIcon")!
                deviceLabel.text = lightDeviceIsText + NSLocalizedString("l.deviceModeOnString",
                                                                         comment: "") + " " + NSLocalizedString("l.atString",
                                                                                                                comment: "") + " " + String(
                                                                                                                    describing: (targetDevice.first!.intensity ?? 0)) + percentString
                controlSlider.isHidden = false
                explanationAnnotationLabel.isHidden = false
            } else {
                targetDevice.first?.mode = deviceModeOffString
                deviceImageView.image = UIImage(named: "DeviceLightOffIcon")!
                deviceLabel.text = lightDeviceIsText + NSLocalizedString("l.deviceModeOffString",
                                                                         comment: "")
                controlSlider.isHidden = true
                explanationAnnotationLabel.isHidden = true
            }
            homePageViewModel.lightsArray.removeAll()
        case .rollerShutter:
            print(NSLocalizedString("l.errorNoSwitchFoundString", comment: ""))
        case .heater:
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
        case .none:
            print(NSLocalizedString("l.errorUnknownDeviceString", comment: ""))
        }
        self.delegate?.homePageTableView.reloadData()
    }
    
    @IBAction func heaterStepperButtonPressed(_ sender: UIStepper!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == controlPageViewModel.targetDeviceID }
        let setTemperature = Int(sender.value)
        let heaterStepperIsText = targetDevice.first!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                           comment: "") + " "
        targetDevice.first?.temperature = Int(setTemperature)
        deviceLabel.text = heaterStepperIsText + NSLocalizedString("l.deviceModeOnString",
                                                                   comment: "") + " " + NSLocalizedString("l.atString",
                                                                                                          comment: "") + " " + String(
                                                                                                            describing: setTemperature) + celsiusDegreeString
        homePageViewModel.heatersArray.removeAll()
        self.delegate?.homePageTableView.reloadData()
    }
    
}
