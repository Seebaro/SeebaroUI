//
//  LoginUIView.swift
//  SeebaroUI
//
//  Created by Armin on 9/26/24.
//

import SwiftUI

public struct LoginUIView: View {
    
    public init(
        username: Binding<String>,
        password: Binding<String>,
        isLoading: Bool,
        errorMessage: String,
        usernameFieldTitle: LocalizedStringKey = "Username",
        usernameFieldSymbol: String = "at",
        passwordFieldTitle: LocalizedStringKey = "Password",
        passwordFieldSymbol: String = "lock",
        loginButtonTitle: LocalizedStringKey = "Login",
        loginAction: @escaping () -> Void
    ) {
        self._username = username
        self._password = password
        self.isLoading = isLoading
        self.errorMessage = errorMessage
        self.usernameFieldTitle = usernameFieldTitle
        self.usernameFieldSymbol = usernameFieldSymbol
        self.passwordFieldTitle = passwordFieldTitle
        self.passwordFieldSymbol = passwordFieldSymbol
        self.loginButtonTitle = loginButtonTitle
        self.loginAction = loginAction
    }
    
    /// Necessary fields
    @Binding public var username: String
    @Binding public var password: String
    public var isLoading: Bool
    public var errorMessage: String
    
    /// Customizations
    public var usernameFieldTitle: LocalizedStringKey
    public var usernameFieldSymbol: String
    public var passwordFieldTitle: LocalizedStringKey
    public var passwordFieldSymbol: String
    public var loginButtonTitle: LocalizedStringKey
    
    /// Login action
    public var loginAction: () -> Void
    
    /// Field focusing
    @FocusState private var focusedField: LoginField?
    private enum LoginField: Hashable {
        case username, password
    }
}

extension LoginUIView {
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                content
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
            }
            .clipped()
        }
        
        #if os(macOS)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            VisualEffectBlur(state: .active)
                .edgesIgnoringSafeArea(.all)
        }
        #endif
    }
    
    var content: some View {
        VStack {
            Spacer()
            
            // MARK: - App Logo
            Image(.seebaro)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.primary)
                .aspectRatio(contentMode: .fit)
                .padding()
                .frame(maxHeight: 150)
                .shadow(radius: 2)
            
            VStack {
                // MARK: - Fields
                VStack(alignment: .leading) {
                    Label {
                        // MARK: - Username Field
                        TextField(usernameFieldTitle, text: $username)
                            .textContentType(.username)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .username)
                            .disabled(isLoading)
                            .padding()
                            .disableAutocorrection(true)
                            #if os(iOS)
                            .autocapitalization(.none)
                            #endif
                            .onSubmit {
                                focusedField = .password
                            }
                    } icon: {
                        Image(systemName: usernameFieldSymbol)
                    }
                    
                    Label {
                        // MARK: - Password Field
                        SecureField(passwordFieldTitle, text: $password)
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .privacySensitive(true)
                            .submitLabel(.done)
                            .disabled(isLoading)
                            .padding()
                            .onSubmit(loginAction)
                    } icon: {
                        Image(systemName: passwordFieldSymbol)
                    }
                }
                .textFieldStyle(.plain)
                .padding(.horizontal)
                .background(
                    .regularMaterial,
                    in: RoundedRectangle(cornerRadius: 10)
                )
                
                // MARK: - Login button
                ZStack {
                    ProgressView()
                        .opacity(isLoading ? 1 : 0)
                    
                    Button(action: loginAction) {
                        Text(loginButtonTitle)
                            .font(.body)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    .opacity(isLoading ? 0 : 1)
                }
                
                // MARK: - Response message
                Text(errorMessage)
                    .font(.callout)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: 300)
            
            Spacer()
        }
        .padding()
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
#Preview {
    @Previewable @State var username: String = ""
    @Previewable @State var password: String = ""
    @Previewable @State var loading: Bool = false
    @Previewable @State var errorMessage: String = ""
    
    LoginUIView(
        username: $username,
        password: $password,
        isLoading: loading,
        errorMessage: errorMessage
    ) {
        loading.toggle()
    }
}
