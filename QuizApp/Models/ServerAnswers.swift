enum ServerAnswers: String, Codable {

    case ok = "200 OK"
    case badRequest = "400 BAD REQUEST"
    case unauthorized = "401 UNAUTHORIZED"
    case forbidden = "403 FORBIDDEN"
    case notFound = "404 NOTFOUND"
    case error
    
}
