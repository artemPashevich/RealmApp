//
//  Task.swift
//  RealmApp
//
//  Created by Артем Пашевич on 15.09.22.
//

import Foundation
import RealmSwift

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}
