//
//  AuthViewModel.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//



import Combine

final class AuthViewModel: ObservableObject {
    
    
    
    
    private let authService: AuthService
    private var cancelBag = CancelBag()
    
    @Published var textIO = TextIO()
    @Published var progress = Progress()
    @Published var loginButton = LoginButton()
    
    init(container: AuthContainerProtocol) {
        self.authService = container.authService
        
        cancelBag.collect {
            $progress.map(\.status)
                .map { $0.statusMessage }
                .assign(to: \.textIO.message, on: self)
            Publishers.CombineLatest3(
                $textIO.map(\.login),
                $textIO.map(\.password),
                $progress.map { $0.status.isLoading })
                .map { (login, password, isLoading) -> AuthViewModel.LoginButton.Status in
                    if isLoading {
                        return .loading
                    }
                    return login.count > 0 && password.count > 0 ?
                        .enabledLogin : .disabledLogin
                }
                .removeDuplicates()
                .assign(to: \.loginButton.status, on: self)
        }
    }
    
}

// MARK: - Elements

extension AuthViewModel {
    struct TextIO {
        let loginTitle: String = "Login"
        let passwordTitle: String = "Password"
        var login: String = ""
        var password: String = ""
        var message: String = ""
    }
    
    struct Progress {
        var status: Loadable<AuthToken> = .notRequested
    }

    struct LoginButton {
        var title: String = ""
        var isEnabled: Bool = false
        var status: Status = .disabledLogin {
            didSet {
                isEnabled = status != .disabledLogin
                title = status == .loading ? "Cancel" : "Sign In"
            }
        }
    }
}

extension AuthViewModel.LoginButton {
    enum Status {
        case disabledLogin
        case enabledLogin
        case loading
    }
}

fileprivate extension Loadable {
    var statusMessage: String {
        switch self {
        case .notRequested:
//            return "Привет!!!\n Тестовый логин и пароль\n login=test and  password=123"
            return ""
        case .loaded:
            return ""
        case .isLoading:
            return "Logging in..."
        case .failed(let error):
            return "Error: " + error.localizedDescription
        case .notValid:
            return "Неправильный логин или пароль"
        }
    }
}

// MARK: - Side Effects

extension AuthViewModel {
    
    func authenticate() {

     
        authService.authenticate(login: textIO.login, password: textIO.password) { (response) in
            if let response = response, response.isStatus() {

                let _ = KeyChain.save(key: "token", data: response.code.data(using: .utf8)!)

                self.progress.status = .loaded(AuthToken(value: response.code))
            } else {
                self.progress.status = .notValid
            }
        }

        
    }
    
    func cancelLoading() {
        progress.status.cancelLoading()
    }
}
