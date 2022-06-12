import Foundation

class AlertViewModel:ObservableObject {
    @Published var fatalError: LocalizedError?
    @Published var isShowAlert: Bool = false
}

enum CustomizedError: Error{
    // Throw when an invalid email and password is entered
    case invalidPassword

    // Throw when an expected resource is not found
    case notFound
   
    // Throw when can not to create new issue
    case createError
    
    // Throw when can not to delete issue
    case deleteError
    
    // Throw when can not to update issue's answer
    case answerUpdateError
    
    // Throw when can not to fetch data from firebase
    case fetchDataError

}

// For each error type return the appropriate localized description
extension CustomizedError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fetchDataError:
            return "Can not to fetch data from firebase"
                   
        case .answerUpdateError:
            return "Can not to update issue's answer"
                   
        case .invalidPassword:
            return "invalid email and password"
                   
        case .notFound:
            return "Error not Found"
                   
        case .createError:
            return "Can not to create new issue"
                   
        case .deleteError:
            return "Can not to delete issue"
                                     
        }
    }
}

enum CustomizeAlert: Error {
    // if  issue is deleted
    case deleteSuccessful
    
    // if  new issue is create
    case createSuccesful
    
    // When can to log in
    case loginSuccesful
    
    // Answer status updated
    case answerUpdateSuccesful
    
}

extension CustomizeAlert : LocalizedError {
    public var errorDescription: String? {
        switch self{
        
        case .deleteSuccessful:
            return "Issue deleted"
        case .createSuccesful:
            return "New issue created"
        case .loginSuccesful:
            return "Login Successful"
        case .answerUpdateSuccesful:
            return "Answer status updated "
        }
    }
}
