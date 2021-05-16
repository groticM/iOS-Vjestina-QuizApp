struct QuizResults: Codable {
    
    let quizId: Int
    let userId: Int
    let time: Double
    let noOfCorrect: Int
    
    enum CodingKeys: String, CodingKey {
        case quizId = "quiz_id"
        case userId = "user_id"
        case time
        case noOfCorrect = "noOfCorrect"
        
    }
    
}
