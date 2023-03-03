//
//  ConnectView.swift
//  Virtual Ping Pong
//
//  Created by Crescenzo Esposito on 26/10/22.
//

import SwiftUI
import ParthenoKit
import Foundation


struct ConnectView: View {
    private var players: Int  = 0
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let codeToShare = randomString(length: 6)
    
    var sTeam = "TeamC92FKSZ"
    var sTag = ""
    var sKey = ""
    var sVal = ""
    var sName = ""
    var result: [String:String] = [:]
    var p = ParthenoKit()
    
    
    
    
    @State var matchcode = ""
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            
            Image(systemName:"arrowshape.turn.up.backward.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: rosso))
        }
    }
    }
    
    
    
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(hex: sfondo).ignoresSafeArea(.all)
                Image("bg01")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .opacity(0.50)
                VStack {
                    
                    
                    
                    HeadText(text: "Share the code!")
                    ZStack{
                        RoundedButton(name: codeToShare)
                            .onAppear() {
                                let _ = p.writeSync(team: "TeamC92FKSZ", tag: codeToShare, key: "players", value:"0")
                            }
                        Text("\(codeToShare)")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(Color(hex: rosso))
                            .shadow(color: Color(.black),radius: 1)
                        
                    }
                    
                    HeadText(text: "Or\nJoin a match!")
                        .multilineTextAlignment( .center)
                    
                    TextField("Insert here!", text: $matchcode)
                    
                        .foregroundColor(.black)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    
                    /*
                     key = matchcode
                     test
                     if p.readSync(team: sTeam, tag: sTag, key: sKey) == connesso
                     codice giusto passJoin = true
                     else inserire codice giusto
                     
                     se il player riceve passJoin l'host riceverà passHost controllo
                     sia su player che su host per startare la partita
                     */
                    
                    Spacer()
                    //                        p.writeSync(team: "TeamC92FKSZ", tag: codeToShare, key: "players", value: "\(players+1)")
                    
                    
                    //  let _ = p.writeSync(team: "TeamC92FKSZ", tag: "Test", key: "players", value:"\(players+1)")
                    if matchcode == "" {
                        NavigationLink(destination: MatchView(codeToShare: codeToShare)) {
                            RoundedButton(name: "Start")
                                .position(x:200, y:300)
                        }
                    }
                    
                    
                    else {
                        if matchcode.count == 6 {
                            let res = p.readSync(team: "TeamC92FKSZ", tag: matchcode, key: "players")
                            if let pl = res["players"]{
                                var players = Int(pl)!
                                if players != 1 {
                                    
                                    NavigationLink(destination: MatchView(codeToShare: matchcode)) {
                                        RoundedButton(name: "Join")
                                            .position(x:200,y:300)
                                            .onAppear() {
                                                let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                                    if players < 1 {
                                                        let res = p.readSync(team: "TeamC92FKSZ", tag: matchcode, key: "players")
                                                        players = Int(res["players"]!)!
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                .textFieldStyle(OvalTextFieldStyle())
                Spacer()
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        
    }
}



struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView()
    }
}



func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}


