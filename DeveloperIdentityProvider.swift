
import Foundation
import AWSCore

protocol CognitoAuthenticator {
    func retrieveToken(success: (identityId: String?, token: String?, userIdentifier: String?) -> Void, failure: (error: NSError) -> Void)
}

class DeveloperIdentityProvider : AWSAbstractCognitoIdentityProvider {
    
    private let authenticator: CognitoAuthenticator!
    private let _providerName: String!
    private var _token: String!
    
    init(providerName: String!, authenticator: CognitoAuthenticator!) {
        self.authenticator = authenticator
        self._providerName = providerName
        super.init()
    }
    
    override var providerName : String {
        return _providerName
    }
    
    override var token: String {
        return _token
    }
    
    override func getIdentityId() -> AWSTask! {
        if self.identityId != nil {
            return AWSTask(result: self.identityId)
        }
        else {
            return AWSTask(result: nil).continueWithBlock({ (task) -> AnyObject! in
                return self.refresh()
            })
        }
    }
   
    override func refresh() -> AWSTask! {
        let task = AWSTaskCompletionSource()
        self.authenticator.retrieveToken({ (identityId, token, userIdentifier) in
                if let identityId = identityId, token = token, userIdentifier = userIdentifier {
                    self.logins = [self.providerName: userIdentifier]
                    self.identityId = identityId
                    self._token = token
                    task.setResult(self.identityId)
                }
                else {
                    task.setError(Error.errorWithCode(5000, failureReason: "CognitoAuthenicator returned no token"))
                }
            },
            failure: { error in
               task.setError(error)
            }
        )
        return task.task
    }
    
    private func errorWithCode(code: Int, failureReason: String) -> NSError {
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        return NSError(domain: "com.app", code: code, userInfo: userInfo)
    }
}
