
import SwiftUI
import ParthenoKit

struct JoinView: View {
    
    @State var matchcode = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(hex: sfondo).ignoresSafeArea(.all)
                
                VStack {
                    
                    Text("Insert Match Code")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(Color(hex: bianco))
                        .padding(.top, 35.0)
                        .shadow(color: Color(hex: rosso),radius: 1)
                        .shadow(color: Color(hex: rosso),radius: 1)
                        .shadow(color: Color(hex: rosso),radius: 1)
                        .shadow(color: Color(hex: rosso),radius: 1)
                    
                    
                        


                    
                    TextField("Insert Code", text: $matchcode)
                        .disableAutocorrection(true)
                    Spacer()
                    RoundedButton(name: "START")
                }
                .textFieldStyle(OvalTextFieldStyle())
                
                
                
                
                
            }
        }
    }
}


struct JoinView_Previews: PreviewProvider {
    static var previews: some View {
        JoinView()
    }
}

