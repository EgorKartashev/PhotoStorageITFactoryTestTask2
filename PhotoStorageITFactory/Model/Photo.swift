
import Foundation

struct Photo: Codable,Equatable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case albumId, id, title, url,thumbnailUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.albumId = try container.decode(Int.self, forKey: .albumId)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
        self.isFavorite = false
    }
    
    // УБрать?
    
//    init() { // Добавьте стандартный инициализатор
//           self.albumId = 0
//           self.id = 0
//           self.title = ""
//           self.url = ""
//           self.thumbnailUrl = ""
//           self.isFavorite = false
//       }
}
