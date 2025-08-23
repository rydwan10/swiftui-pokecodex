import Foundation
import SwiftData

@Model
class User {
    var id: String
    var username: String
    var email: String
    var password: String
    var createdAt: Date
    
    init(id: String = UUID().uuidString, username: String, email: String, password: String) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.createdAt = Date()
    }
}
