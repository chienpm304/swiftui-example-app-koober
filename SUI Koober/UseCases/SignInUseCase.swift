/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import Foundation

/// Use case for signing in users. Attempts to remotely authenticate user and stores the user's session.
class SignInUseCase {
  let username: String
  let password: String
  
  let remoteAPI: UserAuthenticationRemoteAPI
  let userSessionStore: UserSessionStore
  
  init(username: String,
       password: String,
       remoteAPI: UserAuthenticationRemoteAPI,
       userSessionStore: UserSessionStore) {
    self.username = username
    self.password = password
    self.remoteAPI = remoteAPI
    self.userSessionStore = userSessionStore
  }
  
  func start(onUseCaseComplete: @escaping (Result<UserSession, Never>) -> Void) {
    signIn(onUseCaseComplete: onUseCaseComplete)
  }
  
  func signIn(onUseCaseComplete: @escaping (Result<UserSession, Never>) -> Void) {
    remoteAPI.signIn(username: username, password: password) { result in
      switch result {
      case .success(let userSession):
        self.store(userSession: userSession, onComplete: onUseCaseComplete)
      default:
        fatalError()
      }
    }
  }
  
  func store(userSession: UserSession, onComplete: @escaping (Result<UserSession, Never>) -> Void) {
    userSessionStore.store(authenticatedUserSession: userSession,
                           onComplete: onComplete)
  }
}