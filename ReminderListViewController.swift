//
//  ReminderListViewController.swift
//  finalProject(Reminder app)
//
//  Created by Salim Kalbiyev on 01.03.26.
//
import UIKit
import SnapKit

class ReminderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddReminderDelegate {
    
    private let tableView = UITableView()
    private var reminders: [Reminder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Reminders"
        view.backgroundColor = .systemBackground
        
        reminders = DataManager.shared.load()
        
        NotificationManager.shared.requestPermission()
        
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        

        tableView.register(ReminderCell.self, forCellReuseIdentifier: ReminderCell.identifier)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func addTapped() {
        let addVC = AddReminderViewController()
        addVC.delegate = self
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    // MARK: - Delegate Method
    func didAddReminder(_ reminder: Reminder) {
        reminders.append(reminder)
        DataManager.shared.save(reminders: reminders)
        tableView.reloadData()
    }
    func didSaveReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
        } else {
            reminders.append(reminder)
        }
            
        reminders.sort { $0.date < $1.date }
            
        DataManager.shared.save(reminders: reminders)
        tableView.reloadData()
    }
    
    // MARK: - TableView Deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reminderToDelete = reminders[indexPath.row]
    
            NotificationManager.shared.removeNotification(for: reminderToDelete.id)
                
            reminders.remove(at: indexPath.row)
            DataManager.shared.save(reminders: reminders)
                
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
        
    
    // MARK: - TableView Editing
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editVC = AddReminderViewController()
        editVC.delegate = self
        editVC.reminderToEdit = reminders[indexPath.row] 
        
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderCell.identifier, for: indexPath) as? ReminderCell else {
            return UITableViewCell()
        }
            
        let reminder = reminders[indexPath.row]
            
        cell.configure(with: reminder)
        
        cell.onToggleCompletion = { [weak self] in
            guard let self = self else { return }
            
            self.reminders[indexPath.row].isCompleted.toggle()
            let updatedReminder = self.reminders[indexPath.row]
                
           
            if updatedReminder.isCompleted {
                NotificationManager.shared.removeNotification(for: updatedReminder.id)
            } else if updatedReminder.date > Date() {
                NotificationManager.shared.scheduleNotification(for: updatedReminder)
            }
                
            
            DataManager.shared.save(reminders: self.reminders)
                
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

            return cell
        }
}
