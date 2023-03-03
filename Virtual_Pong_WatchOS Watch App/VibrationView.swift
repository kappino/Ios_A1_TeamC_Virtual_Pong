//
//  VibrationView.swift
//  Vpong Watch App
//
//  Created by Vincenzo Salzano on 28/02/23.
//

import SwiftUI
import WatchKit

struct VibrationView: View {
    
    @State var timeRemaining = 3.0 // inizialmente 4 secondi
    @State var timer: Timer?
    @State var rovescio = false
    @State var dritto = false
    
    var body: some View {
        ZStack {
            Image("bg01")
                .resizable()
                .ignoresSafeArea(.all)
            VStack {
                Text("\(timeRemaining)") // visualizza il tempo rimanente
                    .font(.largeTitle)
                Button(action: {
                    self.startTimer()
                }) {
                    Text("Start Timer") // bottone per l'attivazione del timer
                }
                HStack {
                    Button(action: {
                        self.rovescio = true // setta la variabile rovescio a true
                        self.checkColpoForte()
                    }) {
                        Text("Rovescio")
                    }
                    Button(action: {
                        self.dritto = true // setta la variabile dritto a true
                        self.checkColpoForte()
                    }) {
                        Text("Dritto")
                    }
                }
            }
        }
    }
    
    func startTimer() {
        self.timeRemaining = 3.0 // resetta il tempo rimanente
        self.timer?.invalidate() // invalida eventuali timer già in esecuzione
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.timeRemaining -= 1
            if self.timeRemaining == 1 {
                WKInterfaceDevice.current().play(.failure) // vibrazione quando il timer arriva a 1 secondo dalla scadenza
            } else if self.timeRemaining == 0 {
                WKInterfaceDevice.current().play(.success) // vibrazione alla scadenza del timer
                self.timer?.invalidate() // ferma il timer
            }
        }
    }
    
    func checkColpoForte() {
        if self.timeRemaining >= 1 && self.timeRemaining <= 2 {
            self.timeRemaining = 2 // riduce il tempo rimanente a 3 secondi
        } else {
            self.timeRemaining = 3 // resetta il tempo rimanente a 4 secondi
        }
        if self.rovescio {
            WKInterfaceDevice.current().play(.stop) // vibrazione quando si preme il bottone "rovescio"
            self.rovescio = false // resetta la variabile rovescio
        } else if self.dritto {
            WKInterfaceDevice.current().play(.directionUp) // vibrazione quando si preme il bottone "dritto"
            WKInterfaceDevice.current().play(.directionUp) // vibrazione quando si preme il bottone "dritto"
            self.dritto = false // resetta la variabile dritto
        }
    }
}
