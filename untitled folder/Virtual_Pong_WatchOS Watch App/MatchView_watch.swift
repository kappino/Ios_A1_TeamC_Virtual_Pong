//
//  SecondView.swift
//  Vpong Watch App
//
//  Created by Vincenzo Salzano on 01/03/23.
//

import SwiftUI

struct InsertCodeView: View {
    
    @State private var isShowingVibrationView = false
    
    var body: some View {
        ZStack {
            Image("Green")
                .resizable()
                .ignoresSafeArea(.all)
            VStack {
            }
        }
            
                
    }
    struct CodeTextField: View {
        @Binding var text: String
        
        var body: some View {
            TextField("", text: $text)
                .position(x:18 ,y: 40)
                .frame(width: 35, height: 30)
        }
    }
}
