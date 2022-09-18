//
//  TasksListTVC.swift
//  RealmApp
//
//  Created by Артем Пашевич on 15.09.22.
//

import UIKit
import RealmSwift

class TasksListTVC: UITableViewController {

    var tasksLists: Results<TasksList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.clearsSelectionOnViewWillAppear = true
        tasksLists = StorageManager.getAllTasksLists()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TasksListCell
        let tasksList = tasksLists[indexPath.row]
        cell.nameTask.text = tasksList.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentList = tasksLists[indexPath.row]
        
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteTasksList(tasksList: currentList)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editeContextItem = UIContextualAction(style: .destructive, title: "Edite") { _, _, _ in
            self.alertForAddAndUpdatesListTasks(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        editeContextItem.backgroundColor = .orange
        
        let swipeAtions = UISwipeActionsConfiguration(actions: [deleteContextItem, editeContextItem])

        return swipeAtions
    }
    
    @IBAction func addTasksList(_ sender: Any) {
        alertForAddAndUpdatesListTasks { [weak self] in
            self?.navigationItem.title = "alertForAddAndUpdatesListTasks"
        }
    }
    
    
    @IBAction func swithSorted(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {
            tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        tableView.reloadData()
    }
    
    private func alertForAddAndUpdatesListTasks(_ tasksList: TasksList? = nil,
                                                complition: @escaping () -> Void)
    {
        let title = tasksList == nil ? "New List" : "Edit List"
        let message = "Please insert list name"
        let doneButtonName = tasksList == nil ? "Save" : "Update"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        var alertTextField: UITextField!
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { _ in
            guard let newListName = alertTextField.text, !newListName.isEmpty else {
                return
            }

            if let tasksList = tasksList {
                StorageManager.editList(tasksList, newListName: newListName, complition: complition)
            } else {
                let tasksList = TasksList()
                tasksList.name = newListName
                StorageManager.addTasksList(tasksList: tasksList)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.addTextField { textField in
            alertTextField = textField
            if let listName = tasksList {
                alertTextField.text = listName.name
            }
            alertTextField.placeholder = "List Name"
        }
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taskVC = segue.destination as? TaskTableVC,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        taskVC.currentTasksList = tasksLists[indexPath.row]
    }
    
    
    

}
