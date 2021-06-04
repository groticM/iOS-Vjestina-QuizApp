struct Question: Codable {

    var id: Int
    var question: String
    var answers: [String]
    var correctAnswer: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case question
        case answers
        case correctAnswer = "correct_answer"
    }
    
    init() {
        id = 0
        question = ""
        answers = [String]()
        correctAnswer = -1
        
    }

}
