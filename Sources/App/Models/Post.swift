import Vapor
import Fluent
import HTTP

final class Post: Model {
    var id: Node?
    var name: String?
    var contact: String?
    var company: String?
    
    
    var githubID: String?
    var comingForDinner: Bool = false
    var exists = false
}

// MARK: NodeConvertible

extension Post {
    convenience init(node: Node, in context: Context) throws {
        self.init()
        id = node["id"]
        githubID = node["githubID"]?.string
        name = node["name"]?.string
        contact = node["contact"]?.string
        company = node["company"]?.string
        
        comingForDinner = node["comingForDinner"]?.bool ?? false
    }

    func makeNode(context: Context) throws -> Node {
        // model won't always have value to allow proper merges, 
        // database defaults to false
        return try Node.init(node:
            [
                "id": id,
                "githubID": githubID,
                "name": name,
                "contact": contact,
                "comingForDinner": comingForDinner,
                
                "company": company
            ]
        )
    }
}

// MARK: Database Preparations

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("users") { posts in
            posts.string("githubID")
            posts.string("name")
            posts.string("contact")
            posts.bool("comingForDinner")
            
            posts.string("company")
            posts.int("order", optional: true)
        }
    }

    static func revert(_ database: Database) throws {
        fatalError("unimplemented \(#function)")
    }
}

// MARK: Merge

extension Post {
    func merge(updates: Post) {
        id = updates.id ?? id
        githubID = updates.githubID ?? githubID
        name = updates.name ?? name
        contact = updates.contact ?? contact
        comingForDinner = updates.comingForDinner
        
        company = updates.company ?? company
    }
}


