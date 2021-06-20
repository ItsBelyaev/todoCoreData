//
//  TableViewController.swift
//  todoCoreData
//
//  Created by Daniil Belyaev on 20.06.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var todoes: [Task] = []
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        
        let fetchRequest: NSFetchRequest <Task> = Task.fetchRequest()
        let sortDesc = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDesc]
        do {
            todoes = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    private func saveTask(title: String) {
        
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else {return}
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            todoes.insert(taskObject, at: 0)
        } catch {
            print(error)
        }
    }
    

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New", message: "", preferredStyle: .alert)
        
        alert.addTextField { tf in
            tf.placeholder = "Todo"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .cancel) { act in
            if let text = alert.textFields?.first?.text {
                self.saveTask(title: text)
                print(self.todoes)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }


    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let context = self.getContext()
            let fetchRequest: NSFetchRequest <Task> = Task.fetchRequest()
            if let result = try? context.fetch(fetchRequest) {
                context.delete(result[indexPath.row])
                self.tableView.reloadData()

                    do {
                        try context.save()
                    } catch {
                        print(error)
                    }
            }
        }
        
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return actions
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = todoes[indexPath.row].title
        
        return cell
    }
   

}
