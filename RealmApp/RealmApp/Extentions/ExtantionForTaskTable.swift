//
//  ExtantionForTaskTable.swift
//  RealmApp
//
//  Created by Артем Пашевич on 16.09.22.
//

import Foundation
import UIKit

extension TaskTableVC {
    
    func alertForAddAndUpdateList(_ taskForEditing: Task? = nil) {
    
        let title = "Task"
        let message = taskForEditing == nil ? "Please insert new task" : "Please edit your task"
        let doneButton = taskForEditing == nil ? "Save" : "Update"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var nameTaskTF: UITextField!
        var noteTaskTF: UITextField!
        
        let addAction = UIAlertAction(title: doneButton, style: .default) { _ in
            
            guard let nameTaskTF = nameTaskTF.text, !nameTaskTF.isEmpty,
                  let noteTaskTF = noteTaskTF.text, !noteTaskTF.isEmpty else { return }
            
            if let taskForEditing = taskForEditing {
                    StorageManager.editTask(taskForEditing,
                                            newNameTask: nameTaskTF,
                                            newNote: noteTaskTF)
            } else {
                let task = Task()
                task.name = nameTaskTF
                task.note = noteTaskTF
                StorageManager.saveTask(self.currentTasksList, task: task)
            }
            self.filteringTasks()
        }
        
        let cencelAction = UIAlertAction(title: "Cencel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cencelAction)
        
        alert.addTextField { textField in
            nameTaskTF = textField
            nameTaskTF.placeholder = "New task"

            if let taskName = taskForEditing {
                nameTaskTF.text = taskName.name
            }
        }

        alert.addTextField { textField in
            noteTaskTF = textField
            noteTaskTF.placeholder = "Note"

            if let taskName = taskForEditing {
                noteTaskTF.text = taskName.note
            }
        }

        present(alert, animated: true)
        
    }
}

extension TaskTableVC: UITableViewDragDelegate {
func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension TaskTableVC: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
}
