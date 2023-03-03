//
//  tempoColpo.swift
//  Virtual Ping Pong
//
//  Created by Crescenzo Esposito on 29/10/22.
//


import Foundation


func tempoColpo (time:Double,maxTime:Double,colpito:Bool, molt:Double) -> String {
    var time = time
    var maxTime = maxTime * molt
    var colpo: String = "b"
    print("Tiro abbiamo \(maxTime) per colpire")
    let timer = Timer.scheduledTimer(withTimeInterval: 1.0*molt, repeats: true) { timer in

        
        if time == 0 && colpito {
            print("Anticipo")
            colpo = "anti"
            timer.invalidate()
        } else if time == 2*molt && colpito {
            colpo = "qant"
            print("Quasi anticipo")
            timer.invalidate()
        } else if time == 4*molt && colpito {
            colpo = "perf"
            print("Perfetto")
            timer.invalidate()
        }else if time == 6*molt && colpito {
            colpo = "qman"
            print("Quasi mancato")
            timer.invalidate()
        }else if time == 7*molt && !colpito {
            colpo = "manc"
            timer.invalidate()
            print("Mancato")
        }
        
        
        if time < 7*molt {
            time += 1*molt
            print ("\(time)")
        }
        
    }
 
    return colpo
    

}

/*
 
 
 
 switch(time, colpito){
 case (0, true):
     print("Anticipo")
     colpo = "anti"
     timer.invalidate()
     //  reset()
 case (1...2, true):
     print("Quasi in anticipo")
     colpo = "qant"
     timer.invalidate()
     //  reset()
 case (3...4, true):
     colpito = true
     print("Perfetto")
     colpo = "perf"
     timer.invalidate()
     //  reset()
     
 case (5...6, true):
     print("Quasi ritardo")
     colpo = "qrit"
     timer.invalidate()
     // reset()
     
 case (maxTime, false):
     print("Mancato")
     colpo = "manc"
     timer.invalidate()
     
 default:
     print("")
 }
 
 if time == 0 && colpito {
     print("Anticipo")
     timer.invalidate()
 } else if time == 2 && colpito {
     
         print("Quasi anticipo")
         timer.invalidate()
 } else if time == 4 && colpito {
     
         print("Perfetto")
         timer.invalidate()
 }else if time == 6 && colpito {
     
         print("Quasi mancato")
         timer.invalidate()
 }else if time == 7 && !colpito {
     
         print("Mancato")
         timer.invalidate()
 }
 
 switch(time, colpito){
 case (0, true):
         print("Failure anticipo")
     timer.invalidate()
   //  reset()
 case (1...2, true):
         print("Così e così")
     timer.invalidate()
   //  reset()
 case (3...4, true):
      colpito = true
         print("Perfect!")
     timer.invalidate()
   //  reset()

 case (5...6, true):
         print("Quasi in ritardo")
     timer.invalidate()
    // reset()

 case (7, false):
         print("Failure ritardo")
     timer.invalidate()
   //  reset()

 default:
    print("")
 }
 */
/* func Blow (TypeBlow: String) {
    

   
    } */
   
   // start()
    
       
//}


/* func start()
 {
 timer = Timer.scheduledTimer(timeInterval: 1, target: Any, selector: #selector(counter), userInfo: nil, repeats: false)
 }
 
 func reset()
 {
 timer.invalidate()
 time = 0
 
 }
 
 func counter() -> Void {
 time += 1
 print("Timer = \(time)")
 }
 */
