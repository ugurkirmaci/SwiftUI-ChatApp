//
//  SortArrayExtension.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 24.06.2022.
//

import Foundation

enum IssueSortBy: String, Identifiable, CaseIterable {
    var id: String { self.rawValue }
    case Date
    case Title
    case Language
    case Answered
}
// Sort Issue Array by 'IssueSortBy' enum
extension Array where Element == Issue {
    func sort(sortBy: IssueSortBy ) -> [Issue]{
        switch sortBy {
        case .Date:
            return self.sorted(by: { $0.date > $1.date })
        case .Title:
            return self.sorted(by: {$0.title > $1.title })
        case .Language:
            return self.sorted(by: {$0.programmingLanguage > $1.programmingLanguage })
        case .Answered:
            return self.filter( {$0.isAnswered})
        }
    }
}
