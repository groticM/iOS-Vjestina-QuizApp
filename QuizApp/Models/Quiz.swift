struct Quiz: Codable {

    var id: Int
    var title: String
    var description: String
    var category: QuizCategory
    var level: Int
    var imageUrl: String
    var questions: [Question]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case level
        case imageUrl = "image"
        case questions
        
    }
    
    init() {
        id = 0
        title = ""
        description = ""
        category = QuizCategory.sport
        level = 0
        imageUrl = ""
        questions = [Question]()
        
    }

}
