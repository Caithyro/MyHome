//
//  LightControlPageViewController.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 29.07.2022.
//

import UIKit

class LightControlPageViewController: UIViewController {
    
    var lightControlPageViewModel: LightControlPageViewModel!
    var homePageViewModel: HomePageViewModel!
    
    weak var delegate: HomePageViewController?
    
    private var deviceImageView = UIImageView()
    private var deviceLabel = UILabel()
    private var deviceSwitch = UISwitch()
    private var controlSlider = UISlider()
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
        addLightsControls()
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
        explanationAnnotationLabel.text = NSLocalizedString("l.explanationAnnotationLabelStringLight", comment: "")
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
        let targetDevice = lightControlPageViewModel.lightsArray.filter
        { $0.id == lightControlPageViewModel.targetDeviceID }
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
    
    private func setDeviceImageAndText() {
        
        let targetDevice = lightControlPageViewModel.lightsArray.filter
        { $0.id == lightControlPageViewModel.targetDeviceID }
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
    }
    
    @IBAction func changedSliderValue(_ sender: UISlider!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == lightControlPageViewModel.targetDeviceID }
        let setIntensity = Int(sender.value)
        let deviceLabelTextFirstPart = targetDevice.first!.deviceName + " " + NSLocalizedString("l.isString", comment: "")
        let deviceLabelTextSecondPart = NSLocalizedString("l.deviceModeOnString",
                                                          comment: "") + " " + NSLocalizedString("l.atString",
                                                                                                 comment: "") + " " + String(
                                                                                                    describing: setIntensity) + percentString
        deviceLabel.text = deviceLabelTextFirstPart + " " + deviceLabelTextSecondPart
        targetDevice.first?.intensity = setIntensity
        homePageViewModel.lightsArray.removeAll()
    }
    
    @IBAction func changedSwitchValue(_ sender: UISwitch!) {
        
        let targetDevice = homePageViewModel.devicesArray.filter
        { $0.id == lightControlPageViewModel.targetDeviceID }
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
    }
}
