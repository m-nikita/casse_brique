//
//  MenuViewController.swift
//  Pong
//
//  Created by hp omen on 30/03/2022.
//  Copyright © 2022 hp omen. All rights reserved.
//

import UIKit

class NiveauxViewController: UIViewController {
    
    
    @IBOutlet var boutons_niveaux: [UIButton]!
    
    @IBAction func retour_niveaux(_ sender: UIStoryboardSegue) {
     // No code needed, no need to connect the IBAction explicitely

    }
    
    var niveau1_reussi = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.*
        
        print(niveau1_reussi)
        
        for bouton_niveau in boutons_niveaux {
            
            // NIVEAU 2 - LOCK
            if bouton_niveau.tag == 2 {
                bouton_niveau.alpha = 0.5
                bouton_niveau.isEnabled = false
                
                // NIVEAU 2 - UNLOCK
                if niveau1_reussi == true {
                    bouton_niveau.alpha = 1
                    bouton_niveau.isEnabled = true
                }
            }
            
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let Niveau1ViewController = segue.destination as? Niveau1ViewController {
            Niveau1ViewController.callback = { message in
                self.niveau1_reussi = true
                print(self.niveau1_reussi)
                for bouton_niveau in self.boutons_niveaux {
                    self.view.addSubview(bouton_niveau)
                }
            }
        }
    }
    

}
