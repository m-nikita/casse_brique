//
//  InformationsViewController.swift
//  Pong
//
//  Created by hp omen on 04/04/2022.
//  Copyright © 2022 hp omen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class InformationsViewController: UIViewController {
    
    var bruitage_bouton_navigation : AVAudioPlayer?

    @IBAction func bruitage_bouton_retour(_ sender: Any) {
        bruitage_bouton_navigation!.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // bruitage_bouton_navigation
        let chemin4 = Bundle.main.path(forResource: "bouton_navigation", ofType: "wav")
        let url4 = URL(fileURLWithPath: chemin4!)
        do {
            bruitage_bouton_navigation = try AVAudioPlayer(contentsOf: url4)
        } catch {
            print("Erreur à l'initialisation du son")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
