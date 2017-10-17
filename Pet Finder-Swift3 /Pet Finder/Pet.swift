
import Foundation

struct Pet {
  let name: String
  let type: String
  let imageName: String
}

// MARK: - Equatable
extension Pet: Equatable {

  static func == (lhs: Pet, rhs: Pet) -> Bool {
    return lhs.name == rhs.name && lhs.type == rhs.type
  }
}
