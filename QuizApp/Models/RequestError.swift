enum Requesterror: Error {
    case clientError
    case serverError
    case noDataError
    case dataDecodingError
    
}
