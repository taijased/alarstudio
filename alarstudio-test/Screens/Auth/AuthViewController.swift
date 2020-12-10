//
//  AuthViewController.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//


import SwiftUI
import UIKit
import Combine

class AuthViewController: UIHostingController<AuthView> {
    
    private let viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(rootView:  AuthView(viewModel: viewModel))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct AuthView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.textIO.message)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(10)
            if viewModel.progress.status.isLoading {
                ProgressView()
                    .padding(10)
                Button(action: { self.viewModel.cancelLoading() },
                       label: { Text(viewModel.loginButton.title) })
            } else {
                TextField(viewModel.textIO.loginTitle, text: $viewModel.textIO.login)
                    .modifier(TextFieldAppearance())
                TextField(viewModel.textIO.passwordTitle, text: $viewModel.textIO.password)
                    .modifier(TextFieldAppearance())
                Button(action: { self.viewModel.authenticate() },
                       label: { Text(viewModel.loginButton.title)
                        .foregroundColor(Color(.systemBackground)) })
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(viewModel.loginButton.isEnabled ? .systemBlue : .systemGray)))
                    .disabled(!viewModel.loginButton.isEnabled)
            }
        }
        .frame(width: 200)
    }
}

extension AuthView {
    struct TextFieldAppearance: ViewModifier {
        
        func body(content: Content) -> some View {
            content
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.separator), lineWidth: 1))
        }
    }
}

// MARK: - Preview

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(viewModel: .init(container: TempraryAuthContainer()))
    }
}
