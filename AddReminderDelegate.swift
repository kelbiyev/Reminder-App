import UIKit
import SnapKit
import UserNotifications
import PhotosUI


protocol AddReminderDelegate: AnyObject {
    func didSaveReminder(_ reminder: Reminder)
}


class AddReminderViewController: UIViewController, PHPickerViewControllerDelegate {
    
    weak var delegate: AddReminderDelegate?
    var reminderToEdit: Reminder?
    private var selectedImage: UIImage?
    
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    private let contentView = UIView()
    
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "What do you need to do?"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.minimumDate = Date()
        return picker
    }()
    
    private let photoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(" Add Photo", for: .normal)
        btn.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        btn.backgroundColor = .secondarySystemBackground
        btn.tintColor = .systemBlue
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    
    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save Reminder", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.layer.cornerRadius = 12
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        
        if let reminder = reminderToEdit {
            title = "Edit Reminder"
            titleTextField.text = reminder.title
            datePicker.date = reminder.date
            saveButton.setTitle("Update Reminder", for: .normal)
            
            
            if let fileName = reminder.imageFileName, let savedImage = DataManager.shared.loadImage(fileName: fileName) {
                self.selectedImage = savedImage
                photoButton.setImage(savedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                photoButton.setTitle("", for: .normal)
            }
        } else {
            title = "New Reminder"
        }
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleTextField)
        contentView.addSubview(datePicker)
        contentView.addSubview(photoButton)
        contentView.addSubview(saveButton)
    }
    
    private func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        photoButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150) 
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(photoButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(55)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    // MARK: - Photo Picker Logic
        
        @objc private func photoButtonTapped() {
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = .images
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self, let uiImage = image as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self.selectedImage = uiImage
                    self.photoButton.setImage(uiImage.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.photoButton.setTitle("", for: .normal)
                }
            }
        }
    
    @objc private func saveTapped() {
            guard let text = titleTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            
            var savedReminder: Reminder
            var imageFileName: String? = reminderToEdit?.imageFileName
            
            if let newImage = selectedImage {
                imageFileName = DataManager.shared.saveImage(newImage)
            }
            
            if var existing = reminderToEdit {
                NotificationManager.shared.removeNotification(for: existing.id)
                existing.title = text
                existing.date = datePicker.date
                existing.imageFileName = imageFileName
                savedReminder = existing
            } else {
                savedReminder = Reminder(title: text, date: datePicker.date, imageFileName: imageFileName)
            }
            
            NotificationManager.shared.scheduleNotification(for: savedReminder)
            delegate?.didSaveReminder(savedReminder)
            navigationController?.popViewController(animated: true)
        }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    

}
