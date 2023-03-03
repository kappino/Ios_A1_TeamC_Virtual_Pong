//
//  SwiftUIView.swift
//  Virtual Ping Pong
//
//  Created by Crescenzo Esposito on 31/10/22.
//

import CoreMotion
import AVFoundation
import SwiftUI


struct TrainingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
    
    let motionManager = CMMotionManager()
    
    let queue = OperationQueue()
    
    @State private var roll = Double.zero
    @State private var z = Double.zero
    @State private var radice = Double.zero
    @State private var turn = true
    @State private var colpito = false
    @State private var punt = 0
    @State private var maxTime = 4.0
    @State var isRun = false
    @State var direzione = "destra"
    @State var record = 0
    @State var potenza = "lento"
    @State private var colpo = ""
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            ZStack {
                Color(hex: "039445").ignoresSafeArea(.all)
                Image("BlackPaddle")
                    .aspectRatio(contentMode: .fit)
                VStack {
                    Text("Time: \(maxTime)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                                        
                    if colpo != "" {
                        HeadText(text: (colpo.capitalized+"!"))
                    }
                    //                    if direzione != "" {
                    //                        HeadText(text: direzione)
                    //                    }
                    //
                    Spacer()
                    //Prova DIREZIONE COLPO
                    //                    RoundedButton(name: "Colpo Dx")
                    //                        .onTapGesture {
                    ////                            if direzione == "destra" {
                    //                                tempoColpo()
                    ////                                direzione = "sinistra"
                    ////                            } else  {
                    ////                                if punt > record {
                    ////                                    record = punt
                    ////                                }
                    ////                                punt = 0
                    ////                            }
                    //                        }
                    
                    
                    
                    
                    Scoreboard(player1: "Punti", player2: "Record", score1: punt, score2: record)
                }
                .onReceive(timer) {
                    //Azione del timer, decrementa il tempo ogni secondo
                    
                    time in
                    
                    if maxTime == 1 && turn {
                        self.turn = false
                        playSound(sound: "mancato", type: "mp3")
                    }
                    
                        if maxTime > 0 {
                            turn = true
                            maxTime -= 1
                        }
                    
                }
                .onReceive(timer2) {
                    time in
                    colpito = false
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .onAppear {
            stopTimer()
            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                guard let data = data else {
                    print("Error: \(error!)")
                    return
                }
                motionManager.accelerometerUpdateInterval = 0.1
                
                let userAcc: CMAcceleration = data.userAcceleration
                let attitude: CMAttitude = data.attitude
                
                DispatchQueue.main.async {
                    
                    self.roll = attitude.roll
                    
                    self.radice = sqrt(pow(self.z-userAcc.z,2))
                    //  print("funzione \(radice)")
                    if  radice > 1.1  && !colpito {
                        
                        print("roll: \(attitude.roll)")
                        print("z: \(Float(userAcc.z*1000.0)) self.z: \(self.z*1000.0) incremento: \(radice)")
                        colpito = true
                        if self.z - userAcc.z > 0 {
                            self.colpo = "Rovescio"
                            playSound(sound: "pop-39222", type: "mp3")
                            if potenza == "forte" {
                                playSound2(sound: "forte", type: "wav")
                            } else {
                                playSound2(sound: "lento", type: "wav")
                            }

                        } else {
                            self.colpo = "Dritto"
                            playSound(sound: "pop-94319", type: "mp3")
                            if potenza == "forte" {
                                playSound2(sound: "forte", type: "wav")
                            } else {
                                playSound2(sound: "lento", type: "wav")
                            }
                            
                        }
                    }
                    self.z = userAcc.z

                    
                    
                }
                
                if !isRun && radice > 1.1 {
                    radice = 0
                    //Fa partire il timer solo se non è già attivo
                    self.startTimer()
                    isRun = true
                } else if isRun {
                    //Se colpiamo prima dei 3 secondi avremo un buon colpo e non cambierà il moltiplicatore del tempo
                    if maxTime > 0 && radice > 1.3 {
                        isRun = false
                        potenza = "forte"
                        maxTime = 2
                        
                        punt += 1
                        
                    } else if maxTime > 0 && radice > 1.1 {
                        isRun = false

                        potenza = "lento"
                        maxTime = 4
                        punt += 1
                    }
                    //Se finisce il tempo e colpiamo dopo lo 0 avremo mancato il colpo
                    else if maxTime == 0 {
                        isRun = false

                        radice = 0
                        potenza = "mancato"
                        maxTime = 4
                        stopTimer()
                        if punt > record {
                            record = punt
                            sleep(1)
                            playSound2(sound: "finePartita", type: "mp3")

                        }
//                        else {
//                            playSound(sound: "lose", type: "mp3")
//                        }
                        punt = 0
                        sleep(4)
                        startTimer()
                        

                    }
                    //Se colpiamo nell'intervallo 0...3 avremo quasi mancato il colpo dunque avremo meno tempo per colpire
                    //o il nostro avversario avrà più tempo
                    
                    
                    
                    //Aggiorna su parthenokit il risultato del colpo effettuato
                }
                
            }
            
        }
    }
    
    //    func tempoColpo () {
    //        if !isRun && radice > 1.2 {
    //            //Fa partire il timer solo se non è già attivo
    //            self.startTimer()
    //            isRun = true
    //            self.maxTime = 6*molt
    //        } else if isRun {
    //            //Se colpiamo prima dei 3 secondi avremo un buon colpo e non cambierà il moltiplicatore del tempo
    //            if maxTime > 3*molt && radice > 1.2 {
    //                stopTimer()
    //                print("TEST")
    //                isRun = false
    //                colpo = "buono"
    //                self.molt = 1
    //                punt += 1
    //            }
    //            //Se finisce il tempo e colpiamo dopo lo 0 avremo mancato il colpo
    //            else if maxTime == 0 && radice > 1.2 {
    //                stopTimer()
    //                isRun = false
    //                colpo = "mancato"
    //                turno = 0
    //                self.molt = 1
    //                if punt > record {
    //                    record = punt
    //                }
    //                punt = 0
    //            }
    //            //Se colpiamo nell'intervallo 0...3 avremo quasi mancato il colpo dunque avremo meno tempo per colpire
    //            //o il nostro avversario avrà più tempo
    //            else if maxTime < 3*molt && maxTime > 0 && radice > 1.2 {
    //                stopTimer()
    //                isRun = false
    //                colpo = "quasi mancato"
    //                self.molt = 0.5
    //                punt += 1
    //            }
    //            //Aggiorna su parthenokit il risultato del colpo effettuato
    //        }
    //    }
    //Se chiamata ferma il timer
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    //Se chiamata fa partire il timer
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)

                audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audio.play()
            } catch {
                print("ERROR")
            }
        }
    }
}


func playSound2(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            
            audio2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audio2.play()
        } catch {
            print("ERROR")
        }
    }
}
