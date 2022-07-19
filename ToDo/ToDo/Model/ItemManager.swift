//
//  ItemManager.swift
//  ToDo
//
//  Created by Stanly Shiyanovskiy on 18.06.2022.
//

import UIKit

class ItemManager: NSObject {
    var toDoCount: Int { todoItems.count }
    var doneCount: Int { doneItems.count }
    
    private var todoItems: [ToDoItem] = []
    private var doneItems: [ToDoItem] = []
    
    var toDoPathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
            print("Something went wrong. Documents url could not be found")
            fatalError()
        }
        
        return documentURL.appendingPathComponent("toDoItems.plist")
    }
    
    var donePathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
            print("Something went wrong. Documents url could not be found")
            fatalError()
        }
        
        return documentURL.appendingPathComponent("doneItems.plist")
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        
        if let nsToDoItems = NSArray(contentsOf: toDoPathURL) {
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! [String:Any]) { todoItems.append(toDoItem)
                }
            }
        }
        
        if let nsDoneItems = NSArray(contentsOf: donePathURL) {
            for dict in nsDoneItems {
                if let doneItem = ToDoItem(dict: dict as! [String:Any]) { doneItems.append(doneItem)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }
    
    func add(_ item: ToDoItem) {
        guard !todoItems.contains(item) else { return }
        todoItems.append(item)
    }
    
    func item(at index: Int) -> ToDoItem {
        return todoItems[index]
    }
    
    func checkItem(at index: Int) {
        let item = todoItems.remove(at: index)
        doneItems.append(item)
    }
    
    func uncheckItem(at index: Int) {
        let item = doneItems.remove(at: index)
        todoItems.append(item)
    }
    
    func doneItem(at index: Int) -> ToDoItem {
        return doneItems[index]
    }
    
    func removeAll() {
        todoItems.removeAll()
        doneItems.removeAll()
    }
    
    @objc
    func save() {
        saveToDoItems()
        saveDoneItems()
    }
    
    private func saveToDoItems() {
        let nsToDoItems = todoItems.map { $0.plistDict }

        guard nsToDoItems.count > 0 else {
            try? FileManager.default.removeItem(at: toDoPathURL)
            return
        }
        
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: nsToDoItems, format: PropertyListSerialization.PropertyListFormat.xml, options: PropertyListSerialization.WriteOptions(0))
            try plistData.write(to: toDoPathURL, options: Data.WritingOptions.atomic)
        } catch {
            print(error)
        }
    }
    
    private func saveDoneItems() {
        let nsDoneItems = doneItems.map { $0.plistDict }

        guard nsDoneItems.count > 0 else {
            try? FileManager.default.removeItem(at: donePathURL)
            return
        }
        
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: nsDoneItems, format: PropertyListSerialization.PropertyListFormat.xml, options: PropertyListSerialization.WriteOptions(0))
            try plistData.write(to: donePathURL, options: Data.WritingOptions.atomic)
        } catch {
            print(error)
        }
    }
}
