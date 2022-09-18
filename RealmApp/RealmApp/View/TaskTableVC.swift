//
//  TaskTableVC.swift
//  RealmApp
//
//  Created by Артем Пашевич on 16.09.22.
//

import UIKit
import RealmSwift

class TaskTableVC: UITableViewController {

    var currentTasksList: TasksList!
    
    private var notCompletedTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList.name
        filteringTasks()
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Not completed tasks" : "Completed tasks"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? notCompletedTasks.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskCell
        let isFirstSection = indexPath.section == 0
        let task = isFirstSection ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        cell.nameTask.text = task.name
        cell.noteTask.text = task.note
        return cell
    }

     func filteringTasks() {
        notCompletedTasks = currentTasksList.tasks.filter("isComplete = false")
        completedTasks = currentTasksList.tasks.filter("isComplete = true")
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        if cell.imageMark.image == #imageLiteral(resourceName: "unmark.png") {
            cell.imageMark.image = #imageLiteral(resourceName: "checkbox")
            StorageManager.makeDone(task)
            tableView.reloadData()
        } else {
            cell.imageMark.image = #imageLiteral(resourceName: "unmark")
            StorageManager.makeDone(task)
            self.filteringTasks()
            tableView.reloadData()
        }
        
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }
        
        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.alertForAddAndUpdateList(task)
        }
        
        
        editContextItem.backgroundColor = .orange
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem])
        
        return swipeActions
    }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // MealsData.shared.meals.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
//        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        currentTasksList.tasks.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }

}
