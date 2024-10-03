//
//  LoginUIView.swift
//  SeebaroUI
//
//  Created by Armin on 9/26/24.
//

import SwiftUI

public struct LoginView: View {
    
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
    
    /// Warning checks
    @State private var warningUsername: Bool = false
    @State private var warningPassword: Bool = false
}

extension LoginView {
    func checkBeforeAction() {
        warningUsername = username.isEmpty
        warningPassword = password.isEmpty
        
        if !warningUsername && !warningPassword {
            loginAction()
        }
    }
}

extension LoginView {
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                content
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
            }
            #if !os(watchOS)
            .clipped()
            #endif
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
            #if !os(watchOS)
            Spacer()
            
            // MARK: - App Logo
            Image(.seebaro)
                .resizable()
                .foregroundStyle(.primary)
                .aspectRatio(contentMode: .fit)
                .padding()
                .frame(maxHeight: 150)
                .shadow(radius: 2)
            #endif
            
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
                            .foregroundStyle(warningUsername ? .red : .primary)
                            .apply {
                                if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
                                    $0.symbolEffect(.wiggle, value: warningUsername)
                                        
                                } else if #available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *) {
                                    $0.symbolEffect(.bounce, value: warningUsername)
                                }
                            }
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
                            .onSubmit(checkBeforeAction)
                    } icon: {
                        Image(systemName: passwordFieldSymbol)
                            .foregroundStyle(warningPassword ? .red : .primary)
                            .apply {
                                if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
                                    $0.symbolEffect(.wiggle, value: warningPassword)
                                        
                                } else if #available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *) {
                                    $0.symbolEffect(.bounce, value: warningPassword)
                                }
                            }
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
                    Button(action: checkBeforeAction) {
                        Text(isLoading ? " " : loginButtonTitle)
                            .font(.body)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    .disabled(isLoading)
                    .apply {
                        if #available(iOS 17.0, *) {
                            $0.sensoryFeedback(.error, trigger: !warningUsername || !warningPassword || !errorMessage.isEmpty)
                        }
                    }
                    
                    if isLoading {
                        ProgressView()
                    }
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
    
    LoginView(
        username: $username,
        password: $password,
        isLoading: loading,
        errorMessage: errorMessage
    ) {
        loading.toggle()
    }
}
