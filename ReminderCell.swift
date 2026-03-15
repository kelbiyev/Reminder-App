//
//  ReminderCell.swift
//  finalProject(Reminder app)
//
//  Created by Salim Kalbiyev on 01.03.26.
//

import UIKit
import SnapKit

class ReminderCell: UITableViewCell {
    
    static let identifier = "ReminderCell"
    
    var onToggleCompletion: (() -> Void)?
    
    private let checkmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews(){
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(textStackView)
            
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(dateLabel)
    }
    
    private func setupConstraints(){
        checkmarkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc private func checkmarkTapped() {
        onToggleCompletion?()
    }
    
    func configure(with reminder: Reminder) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: reminder.date)
        
        if reminder.isCompleted {
            checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkmarkButton.tintColor = .systemGreen
            
            
            let attributeString = NSMutableAttributedString(string: reminder.title)
            attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
            titleLabel.textColor = .secondaryLabel
        } else {
            checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkmarkButton.tintColor = .systemBlue
            
            
            let attributeString = NSMutableAttributedString(string: reminder.title)
            titleLabel.attributedText = attributeString
            titleLabel.textColor = .label
        }
    }
}
