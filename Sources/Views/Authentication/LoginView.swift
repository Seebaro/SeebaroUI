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
        logo: String? = nil,
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
        self.logo = logo
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
    public let logo: String?
    public let usernameFieldTitle: LocalizedStringKey
    public let usernameFieldSymbol: String
    public let passwordFieldTitle: LocalizedStringKey
    public let passwordFieldSymbol: String
    public let loginButtonTitle: LocalizedStringKey
    
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
            if let logo {
                Image(logo)
                    .resizable()
                    .foregroundStyle(.primary)
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .frame(maxHeight: 150)
                    .shadow(radius: 2)
            }
            #endif
            
            VStack {
                // MARK: - Fields
                VStack(alignment: .leading) {
                    Label {
                        // MARK: - Username Field
                        TextField(usernameFieldTitle, text: $username)
                            .submitLabel(.next)
                            .textContentType(.username)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .username)
                            .disabled(isLoading)
                            #if os(iOS)
                            .autocapitalization(.none)
                            #endif
                            .padding()
                            .onSubmit {
                                focusedField = .password
                            }
                    } icon: {
                        Image(systemName: usernameFieldSymbol)
                            .foregroundStyle(warningUsername ? .red : .primary)
                            .apply {
                                if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
                                    $0.symbolEffect(.wiggle, value: warningUsername)
                                } else {
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
                                } else {
                                    $0
                                }
                            }
                    }
                }
                .textFieldStyle(.plain)
                .padding(.horizontal)
                .apply {
                    if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, *) {
                        $0.glassEffect(in: .rect(cornerRadius: 16))
                    } else {
                        $0.background(.regularMaterial, in: .rect(cornerRadius: 16))
                    }
                }
                
                // MARK: - Login button
                ZStack {
                    Button(action: checkBeforeAction) {
                        Text(isLoading ? " " : loginButtonTitle)
                            .font(.body)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical)
                    .disabled(isLoading)
                    .sensoryFeedback(.error, trigger: !warningUsername || !warningPassword || !errorMessage.isEmpty)
                    .apply {
                        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, *) {
                            $0
                              .controlSize(.extraLarge)
                              .buttonStyle(.glassProminent)
                        } else {
                            $0
                              .controlSize(.large)
                              .buttonStyle(.borderedProminent)
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
