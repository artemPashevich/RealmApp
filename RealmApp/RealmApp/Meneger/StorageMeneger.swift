//
//  StorageMeneger.swift
//  RealmApp
//
//  Created by Артем Пашевич on 15.09.22.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func getAllTasksLists() -> Results<TasksList> {
        realm.objects(TasksList.self)
    }
    
    static func addTasksList(tasksList: TasksList) {
        do {
            try realm.write {
                realm.add(tasksList)
            }
        } catch {
            print(error)
        }
    }
    
    static func deleteTasksList(tasksList: TasksList) {
        do {
            try realm.write {
                realm.delete(tasksList.tasks)
                realm.delete(tasksList)
            }
        } catch {
            print(error)
        }
    }
    
    static func makeAllDone(tasksList: TasksList) {
        do {
            try realm.write {
                tasksList.tasks.setValue(true, forKey: "isComplete")
            }
        } catch {
            print(error)
        }
    }
    
    static func editList(_ tasksList: TasksList,
                         newListName: String,
                         complition: @escaping () -> Void) {
        do {
            try realm.write {
                tasksList.name = newListName
                complition()
            }
        } catch {
            print(error)
        }
    }
    
    static func saveTask(_ tasksList: TasksList, task: Task) {
        do {
            try realm.write {
            tasksList.tasks.append(task)
           }
        } catch {
            print(error)
        }
    }

    static func editTask(_ task: Task, newNameTask: String, newNote: String) {
        do {
            try realm.write {
            task.name = newNameTask
            task.note = newNote
           }
        } catch {
            print(error)
        }
    }

    static func deleteTask(_ task: Task) {
        do {
            try realm.write {
            realm.delete(task)
           }
        } catch {
            print(error)
        }
    }

    static func makeDone(_ task: Task) {
        do {
            try realm.write {
            task.isComplete.toggle()
           }
        } catch {
            print(error)
            
        }
    }
    
}
