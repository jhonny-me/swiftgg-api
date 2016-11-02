import Vapor
import VaporMongo
import HTTP
import CorsMiddleware

let drop = Droplet()
try drop.addProvider(VaporMongo.Provider.self)
drop.addConfigurable(middleware: CorsMiddleware(), name: "cors")
drop.preparations = [Post.self]

print(drop.workDir)

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("sign") { req in
    return try drop.view.make("signIn.html")
}

drop.resource("posts", PostController())

drop.run()
