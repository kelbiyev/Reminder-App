//
//  Reminder.swift
//  finalProject(Reminder app)
//
//  Created by Salim Kalbiyev on 08.03.26.
//

import Foundation
import UIKit

// MARK: - The Model
struct Reminder: Codable, Equatable {
    var id = UUID().uuidString
    var title: String
    var date: Date
    var isCompleted: Bool = false
    var imageFileName: String?
}

// MARK: - The Data Manager
class DataManager {
    
    static let shared = DataManager()
    
    private let key = "saved_reminders"
    
    // MARK: - Saving/Loading Reminder Data
    func save(reminders: [Reminder]) {
        if let encoded = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func load() -> [Reminder] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Reminder].self, from: data) {
            return decoded
        }
        return []
    }
    
    // MARK: - Saving/Loading Images
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveImage(_ image: UIImage) -> String? {
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            try? imageData.write(to: fileURL)
            return fileName
        }
        return nil
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
}

