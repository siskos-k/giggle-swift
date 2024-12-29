import SwiftUI

struct RegisterView: View {
    
    @StateObject var registerVM = RegisterViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width, height: 500)
                    .foregroundColor(Color.green)
//                    .offset(y: -100)
                
                VStack {
                    HeaderView()
                        .offset(y: -100)
                    ZStack {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Divider()
                            Text("Welcome!")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Divider()
                            
                            Text("We're excited to have you here. Take the first step towards transforming your passion into a rewarding journey.")
                                .font(.body)
                                .foregroundColor(.black)
                            Divider()

                            Text("Fill in the form below and let's get started on building your dreams into reality!")
                                .font(.body)
                                .foregroundColor(.black)
                            Divider()

                        }
                        }
                    .padding(.horizontal, 20)
                    .offset(y: -100)

                    Form {
                        if !registerVM.errorMessage.isEmpty {
                            Text(registerVM.errorMessage)
                                .foregroundColor(Color.red)
                        }
                        
                        TextField("Full Name", text: $registerVM.name)
                        
                        TextField("Email Address", text: $registerVM.email)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        
                        SecureField("Password", text: $registerVM.password)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                        
                        Button(action: {
                            registerVM.register()
                        }) {
                            Text("Register")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .offset(y: -100)

                }
            }
        }
        Spacer()
    }
}
#Preview {
    RegisterView()
}
