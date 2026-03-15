//
//  SettingsViewController.swift
//  finalProject(Reminder app)
//
//  Created by Salim Kalbiyev on 01.03.26.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private let appearanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark Mode"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let appearanceSwitch: UISwitch = {
        let toggle = UISwitch()
        return toggle
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemGroupedBackground
        
        appearanceSwitch.isOn = traitCollection.userInterfaceStyle == .dark
        appearanceSwitch.addTarget(self, action: #selector(toggleAppearance), for: .valueChanged)
    
        setupUI()
    }
    
    private func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews(){
        view.addSubview(containerView)
        containerView.addSubview(appearanceLabel)
        containerView.addSubview(appearanceSwitch)
    }
    
    private func setupConstraints(){
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        appearanceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        appearanceSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func toggleAppearance(_ sender: UISwitch) {
        UIView.transition(with: view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.view.window?.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
        }, completion: nil)
    }
}
