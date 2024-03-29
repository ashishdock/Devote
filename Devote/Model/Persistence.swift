//
//  Persistence.swift
//  Devote
//
//  Created by Ashish Sharma on 01/02/2023.
//

import CoreData

struct PersistenceController {
    //MARK: - 1. PERSISTENCE CONTROLLER
    static let shared = PersistenceController() //SINGLETON

    //MARK: - 2. PERSISTENT CONTAINER
    let container: NSPersistentContainer

    //MARK: - 3. INITIALIZATION (load the persistent core)
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Devote")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //MARK: - 4. PREVIEW (this is a test configuration solely for SwiftUI previews, here we are switching to inMemory for temp storage to only display)
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<5 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = "Sample task No.\(i)"
            newItem.completion = false
            newItem.id = UUID()
        }
        do {
            try viewContext.save()
        } catch {
            
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    
}
