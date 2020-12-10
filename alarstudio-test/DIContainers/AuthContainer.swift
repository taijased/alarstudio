//
//  AuthContainer.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//

import Foundation







struct AuthContainer: AuthContainerProtocol {
    let authService: AuthService = RealAuthService()
}



#if DEBUG
struct TempraryAuthContainer: AuthContainerProtocol {
    let authService: AuthService = TempraryAuthService()
}
#endif
